--- Agent Skills for codecompanion
---
--- Simulates Claude Code's Agent Skills pattern:
---   Level 1: Skill name + description in system prompt (always present, ~20 tokens each)
---   Level 2: Full SKILL.md injected as system message only when user message matches
---   Level 3: Project files read via existing tools (read_file, grep_search, etc.)
---
--- Skills live in <cwd>/.claude/skills/<name>/SKILL.md
--- YAML-like frontmatter is supported:
---   ---
---   description: Short description for the index
---   globs: ["*.tsx", "src/components/**"]
---   ---

local Path = require('plenary.path')

local fmt = string.format

---@class AgentSkill
---@field name string
---@field description string
---@field globs string[]
---@field path string Absolute path to SKILL.md
---@field content string Full SKILL.md body (below frontmatter)

--- Parse YAML-like frontmatter from a SKILL.md file
---@param text string
---@return { description: string, globs: string[] }, string frontmatter fields and body
local function parse_frontmatter(text)
  local meta = { description = '', globs = {} }

  -- Check for frontmatter delimiters
  local fm_start, fm_end = text:match('^%s*()%-%-%-\n()')
  if not fm_start then
    return meta, text
  end

  local rest_start = text:find('\n%-%-%-', fm_end)
  if not rest_start then
    return meta, text
  end

  local frontmatter = text:sub(fm_end, rest_start - 1)
  local body = text:sub(rest_start + 4) -- skip the closing ---
  body = body:gsub('^\n+', '') -- trim leading newlines from body

  -- Parse description
  local desc = frontmatter:match('description:%s*(.-)%s*\n')
  if desc then
    -- Remove surrounding quotes if present
    desc = desc:gsub("^[\"'](.-)[\"']%s*$", '%1')
    meta.description = desc
  end

  -- Parse globs (simple array format)
  local globs_str = frontmatter:match('globs:%s*%[(.-)%]')
  if globs_str then
    for glob in globs_str:gmatch('"([^"]+)"') do
      table.insert(meta.globs, glob)
    end
    if #meta.globs == 0 then
      for glob in globs_str:gmatch("'([^']+)'") do
        table.insert(meta.globs, glob)
      end
    end
  end

  return meta, body
end

--- Discover all skills in .claude/skills/
---@param base_dir? string
---@return AgentSkill[]
local function discover_skills(base_dir)
  base_dir = base_dir or vim.fn.getcwd()
  local skills_dir = Path:new(base_dir, '.claude', 'skills')
  local skills = {}

  if not skills_dir:exists() then
    return skills
  end

  local handle = vim.uv.fs_scandir(skills_dir:absolute())
  if not handle then
    return skills
  end

  while true do
    local name, entry_type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if entry_type == 'directory' then
      local skill_file = Path:new(skills_dir:absolute(), name, 'SKILL.md')
      if skill_file:exists() and skill_file:is_file() then
        local raw = skill_file:read()
        local meta, body = parse_frontmatter(raw)

        -- Fallback: if no description in frontmatter, use first non-header, non-empty line
        if meta.description == '' then
          for line in body:gmatch('[^\n]+') do
            local trimmed = vim.trim(line)
            if trimmed ~= '' and not trimmed:match('^#') then
              meta.description = trimmed
              break
            end
          end
        end

        table.insert(skills, {
          name = name,
          description = meta.description,
          globs = meta.globs,
          path = skill_file:absolute(),
          content = body,
        })
      end
    end
  end

  table.sort(skills, function(a, b)
    return a.name < b.name
  end)

  return skills
end

--- Check if a file path matches any of the glob patterns
---@param filepath string
---@param globs string[]
---@return boolean
local function matches_globs(filepath, globs)
  if #globs == 0 then
    return false
  end
  for _, glob in ipairs(globs) do
    if vim.fn.globpath('.', glob, false, true) then
      -- Use Vim's glob matching
      local pattern = vim.fn.glob2regpat(glob)
      if vim.fn.match(filepath, pattern) >= 0 then
        return true
      end
    end
  end
  return false
end

--- Check if a skill is relevant based on the current context
---@param skill AgentSkill
---@param ctx { buffers: string[], message: string? }
---@return boolean
local function is_skill_relevant(skill, ctx)
  -- Check glob patterns against open/attached buffers
  if #skill.globs > 0 and ctx.buffers then
    for _, buf_path in ipairs(ctx.buffers) do
      if matches_globs(buf_path, skill.globs) then
        return true
      end
    end
  end

  -- Check if skill name appears in user message
  if ctx.message then
    local lower_msg = ctx.message:lower()
    local lower_name = skill.name:lower():gsub('%-', ' ')
    if lower_msg:find(lower_name, 1, true) or lower_msg:find(skill.name:lower(), 1, true) then
      return true
    end
  end

  return false
end

--- Build the Level 1 index (lightweight, for system prompt)
---@param skills AgentSkill[]
---@return string
local function build_index(skills)
  if #skills == 0 then
    return ''
  end

  local lines = {
    'You have access to Agent Skills in `.claude/skills/`. Relevant skills are automatically loaded below.',
    'When a loaded skill influences your response, briefly announce it at the start (e.g. _"Applying **conventional-commits** skill."_).',
    '',
    'All available skills:',
  }

  for _, skill in ipairs(skills) do
    if skill.description ~= '' then
      table.insert(lines, fmt('- **%s**: %s', skill.name, skill.description))
    else
      table.insert(lines, fmt('- **%s**', skill.name))
    end
  end

  return table.concat(lines, '\n')
end

--- Build the Level 2 content (full skill body for relevant skills)
---@param skills AgentSkill[]
---@return string
local function build_skill_content(skills)
  if #skills == 0 then
    return ''
  end

  local parts = {}
  for _, skill in ipairs(skills) do
    table.insert(parts, fmt('## Skill: %s\n\n%s', skill.name, skill.content))
  end

  return '\n\n--- Loaded Agent Skills ---\n\n' .. table.concat(parts, '\n\n---\n\n')
end

local M = {}

M.discover_skills = discover_skills
M.parse_frontmatter = parse_frontmatter
M.is_skill_relevant = is_skill_relevant
M.build_index = build_index
M.build_skill_content = build_skill_content

--- Get the combined system prompt addition (index + relevant skill bodies)
--- Called from the chat system prompt or from an autocmd
---@param ctx? { buffers: string[], message: string? }
---@return string index The lightweight index for system prompt
---@return string content The full body of relevant skills (may be empty)
function M.get_prompt_parts(ctx)
  ctx = ctx or {}
  local skills = discover_skills()

  if #skills == 0 then
    return '', ''
  end

  local index = build_index(skills)

  -- If no context provided, return just the index
  if not ctx.buffers and not ctx.message then
    return index, ''
  end

  -- Find relevant skills based on context
  local relevant = {}
  for _, skill in ipairs(skills) do
    if is_skill_relevant(skill, ctx) then
      table.insert(relevant, skill)
    end
  end

  return index, build_skill_content(relevant)
end

--- Inject skills into a chat as system messages (no tool call needed)
--- Call this from CodeCompanionChatCreated or before submit
---@param chat table The CodeCompanion chat object
---@param opts? { message: string? }
function M.inject_skills(chat, opts)
  opts = opts or {}
  local config = require('codecompanion.config')

  -- Gather buffer context from chat
  local buffers = {}
  if chat.context_items then
    for _, item in ipairs(chat.context_items) do
      if item.source == 'buffer' or item.source == 'file' then
        local path = item.path or item.filename or ''
        if path ~= '' then
          table.insert(buffers, path)
        end
      end
    end
  end

  local index, content = M.get_prompt_parts {
    buffers = buffers,
    message = opts.message,
  }

  if index == '' then
    return
  end

  -- Remove any previous skill messages
  chat.messages = vim
    .iter(chat.messages)
    :filter(function(msg)
      return not (msg._meta and msg._meta.tag == 'agent_skills')
    end)
    :totable()

  -- Inject index as system message (Level 1 — always present)
  local prompt = index
  if content ~= '' then
    prompt = prompt .. content
  end

  chat:add_message(
    { role = config.constants.SYSTEM_ROLE, content = prompt },
    { visible = false, _meta = { tag = 'agent_skills' } }
  )
end

--- Auto-inject all skills whose globs match (for use without user message context)
--- This loads skills based purely on glob patterns vs current buffers
---@param chat table
function M.inject_matching_skills(chat)
  local config = require('codecompanion.config')
  local skills = discover_skills()

  if #skills == 0 then
    return
  end

  -- Gather attached file paths from the chat
  local buffers = {}
  if chat.context_items then
    for _, item in ipairs(chat.context_items) do
      local path = item.path or item.filename or ''
      if path ~= '' then
        table.insert(buffers, path)
      end
    end
  end
  -- Also add the current buffer
  local cur_buf = vim.api.nvim_buf_get_name(0)
  if cur_buf ~= '' then
    table.insert(buffers, cur_buf)
  end

  local relevant = {}
  for _, skill in ipairs(skills) do
    if #skill.globs > 0 and is_skill_relevant(skill, { buffers = buffers }) then
      table.insert(relevant, skill)
    end
  end

  if #relevant == 0 and #skills > 0 then
    -- Only inject the lightweight index
    local index = build_index(skills)
    chat:add_message(
      { role = config.constants.SYSTEM_ROLE, content = index },
      { visible = false, _meta = { tag = 'agent_skills' } }
    )
    return
  end

  -- Inject index + matched skill bodies
  local index = build_index(skills)
  local content = build_skill_content(relevant)

  chat:add_message(
    { role = config.constants.SYSTEM_ROLE, content = index .. content },
    { visible = false, _meta = { tag = 'agent_skills' } }
  )
end

return M
