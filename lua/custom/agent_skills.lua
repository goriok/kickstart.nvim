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
---   name: my-skill
---   description: Short description for the index
---   globs: ["*.tsx", "src/components/**"]
---   disable-model-invocation: true
---   user-invocable: false
---   allowed-tools: Read, Grep, Glob
---   argument-hint: [issue-number]
---   ---

local Path = require('plenary.path')

local fmt = string.format

---@class AgentSkillFile
---@field name string Filename relative to skill dir
---@field content string File contents

---@class AgentSkill
---@field name string
---@field description string
---@field globs string[]
---@field path string Absolute path to SKILL.md
---@field dir string Absolute path to skill directory
---@field content string Full SKILL.md body (below frontmatter)
---@field disable_model_invocation boolean If true, only user can invoke
---@field user_invocable boolean If false, only model can invoke
---@field allowed_tools string[] Tools allowed without confirmation
---@field argument_hint string? Hint for autocomplete
---@field files AgentSkillFile[] Supporting files (templates, examples, scripts)

--- Parse YAML-like frontmatter from a SKILL.md file
---@param text string
---@return { description: string, globs: string[], name: string?, disable_model_invocation: boolean, user_invocable: boolean, allowed_tools: string[], argument_hint: string? }, string frontmatter fields and body
local function parse_frontmatter(text)
  local meta = {
    description = '',
    globs = {},
    name = nil,
    disable_model_invocation = false,
    user_invocable = true,
    allowed_tools = {},
    argument_hint = nil,
  }

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
  -- Ensure frontmatter ends with newline for consistent pattern matching
  if not frontmatter:match('\n$') then
    frontmatter = frontmatter .. '\n'
  end
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

  -- Parse name
  local name_val = frontmatter:match('name:%s*(.-)%s*\n')
  if name_val then
    name_val = name_val:gsub("^[\"'](.-)[\"']%s*$", '%1')
    if name_val ~= '' then
      meta.name = name_val
    end
  end

  -- Parse disable-model-invocation
  local dmi = frontmatter:match('disable%-model%-invocation:%s*(.-)%s*\n')
  if dmi and dmi:lower() == 'true' then
    meta.disable_model_invocation = true
  end

  -- Parse user-invocable
  local ui = frontmatter:match('user%-invocable:%s*(.-)%s*\n')
  if ui and ui:lower() == 'false' then
    meta.user_invocable = false
  end

  -- Parse allowed-tools (comma-separated)
  local tools = frontmatter:match('allowed%-tools:%s*(.-)%s*\n')
  if tools then
    tools = tools:gsub("^[\"'](.-)[\"']%s*$", '%1')
    for tool in tools:gmatch('[^,]+') do
      table.insert(meta.allowed_tools, vim.trim(tool))
    end
  end

  -- Parse argument-hint
  local hint = frontmatter:match('argument%-hint:%s*(.-)%s*\n')
  if hint then
    hint = hint:gsub("^[\"'](.-)[\"']%s*$", '%1')
    if hint ~= '' then
      meta.argument_hint = hint
    end
  end

  return meta, body
end

--- Recursively discover supporting files in a skill directory
--- Skips SKILL.md itself and hidden files
---@param skill_dir string Absolute path to the skill directory
---@return AgentSkillFile[]
local function discover_supporting_files(skill_dir)
  local files = {}

  local function scan(dir, prefix)
    local handle = vim.uv.fs_scandir(dir)
    if not handle then
      return
    end
    while true do
      local entry_name, entry_type = vim.uv.fs_scandir_next(handle)
      if not entry_name then
        break
      end
      -- Skip hidden files and SKILL.md
      if not entry_name:match('^%.') and entry_name ~= 'SKILL.md' then
        local rel = prefix ~= '' and (prefix .. '/' .. entry_name) or entry_name
        local abs = dir .. '/' .. entry_name
        if entry_type == 'directory' then
          scan(abs, rel)
        elseif entry_type == 'file' then
          local p = Path:new(abs)
          if p:exists() then
            local ok, content = pcall(function()
              return p:read()
            end)
            if ok and content then
              table.insert(files, { name = rel, content = content })
            end
          end
        end
      end
    end
  end

  scan(skill_dir, '')
  table.sort(files, function(a, b)
    return a.name < b.name
  end)
  return files
end
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
      local skill_dir_path = skills_dir:absolute() .. '/' .. name
      local skill_file = Path:new(skill_dir_path, 'SKILL.md')
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

        -- Discover supporting files (templates, examples, scripts)
        local supporting_files = discover_supporting_files(skill_dir_path)

        table.insert(skills, {
          name = meta.name or name,
          description = meta.description,
          globs = meta.globs,
          path = skill_file:absolute(),
          dir = skill_dir_path,
          content = body,
          disable_model_invocation = meta.disable_model_invocation,
          user_invocable = meta.user_invocable,
          allowed_tools = meta.allowed_tools,
          argument_hint = meta.argument_hint,
          files = supporting_files,
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
    local pattern = vim.fn.glob2regpat(glob)
    if vim.fn.match(filepath, pattern) >= 0 then
      return true
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

--- Substitute $ARGUMENTS, $ARGUMENTS[N], and $N placeholders in skill content
---@param content string The skill content with placeholders
---@param arguments string? The raw arguments string
---@return string
local function substitute_arguments(content, arguments)
  if not arguments or arguments == '' then
    return content
  end

  -- Split arguments into parts by whitespace
  local parts = {}
  for part in arguments:gmatch('%S+') do
    table.insert(parts, part)
  end

  -- Check if content uses $ARGUMENTS at all
  local has_placeholder = content:find('%$ARGUMENTS') or content:find('%$%d')

  -- Replace $ARGUMENTS[N] (indexed access)
  content = content:gsub('%$ARGUMENTS%[(%d+)%]', function(idx)
    local i = tonumber(idx) + 1 -- 0-based to 1-based
    return parts[i] or ''
  end)

  -- Replace $N shorthand (e.g. $0, $1, $2)
  content = content:gsub('%$(%d+)', function(idx)
    local i = tonumber(idx) + 1 -- 0-based to 1-based
    return parts[i] or ''
  end)

  -- Replace $ARGUMENTS with the full string
  content = content:gsub('%$ARGUMENTS', arguments)

  -- If no placeholder was found, append arguments at the end
  if not has_placeholder then
    content = content .. '\n\nARGUMENTS: ' .. arguments
  end

  return content
end

--- Substitute ${CLAUDE_SKILL_DIR} in skill content
---@param content string
---@param skill_dir string
---@return string
local function substitute_skill_dir(content, skill_dir)
  return content:gsub('%${CLAUDE_SKILL_DIR}', skill_dir)
end

--- Build supporting files section for a skill
---@param files AgentSkillFile[]
---@return string
local function build_supporting_files_section(files)
  if #files == 0 then
    return ''
  end

  local parts = {}
  for _, file in ipairs(files) do
    -- Determine language from extension for code fencing
    local ext = file.name:match('%.([^%.]+)$') or ''
    local lang_map = {
      lua = 'lua',
      py = 'python',
      sh = 'bash',
      bash = 'bash',
      zsh = 'zsh',
      js = 'javascript',
      ts = 'typescript',
      rb = 'ruby',
      go = 'go',
      json = 'json',
      yaml = 'yaml',
      yml = 'yaml',
      toml = 'toml',
      md = 'markdown',
    }
    local lang = lang_map[ext] or ''

    table.insert(parts, fmt('### `%s`\n\n```%s\n%s\n```', file.name, lang, file.content))
  end

  return '\n\n## Supporting Files\n\n' .. table.concat(parts, '\n\n')
end

--- Build the Level 1 index (lightweight, for system prompt)
--- Skills with disable_model_invocation=true are excluded from the index
--- (the model should not know about them unless the user invokes them)
---@param skills AgentSkill[]
---@return string
local function build_index(skills)
  if #skills == 0 then
    return ''
  end

  -- Filter out skills that the model should not auto-invoke
  local visible = vim.tbl_filter(function(s)
    return not s.disable_model_invocation
  end, skills)

  if #visible == 0 then
    return ''
  end

  local lines = {
    'You have access to Agent Skills in `.claude/skills/`. Relevant skills are automatically loaded below.',
    'When a loaded skill influences your response, briefly announce it at the start (e.g. _"Applying **conventional-commits** skill."_).',
    '',
    'All available skills:',
  }

  for _, skill in ipairs(visible) do
    if skill.description ~= '' then
      table.insert(lines, fmt('- **%s**: %s', skill.name, skill.description))
    else
      table.insert(lines, fmt('- **%s**', skill.name))
    end
  end

  return table.concat(lines, '\n')
end

--- Build the Level 2 content (full skill body for relevant skills)
--- Includes supporting files and applies ${CLAUDE_SKILL_DIR} substitution
---@param skills AgentSkill[]
---@param arguments? string Optional arguments to substitute via $ARGUMENTS
---@return string
local function build_skill_content(skills, arguments)
  if #skills == 0 then
    return ''
  end

  local parts = {}
  for _, skill in ipairs(skills) do
    local body = skill.content

    -- Apply variable substitutions
    if skill.dir then
      body = substitute_skill_dir(body, skill.dir)
    end
    if arguments then
      body = substitute_arguments(body, arguments)
    end

    -- Append supporting files if any
    local files_section = build_supporting_files_section(skill.files or {})
    table.insert(parts, fmt('## Skill: %s\n\n%s%s', skill.name, body, files_section))
  end

  return '\n\n--- Loaded Agent Skills ---\n\n' .. table.concat(parts, '\n\n---\n\n')
end

local M = {}

M.discover_skills = discover_skills
M.discover_supporting_files = discover_supporting_files
M.parse_frontmatter = parse_frontmatter
M.is_skill_relevant = is_skill_relevant
M.build_index = build_index
M.build_skill_content = build_skill_content
M.substitute_arguments = substitute_arguments
M.substitute_skill_dir = substitute_skill_dir

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
  -- Skills with disable_model_invocation are excluded from auto-loading
  local relevant = {}
  for _, skill in ipairs(skills) do
    if not skill.disable_model_invocation and is_skill_relevant(skill, ctx) then
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

--- Check if a system message with this exact content is already present (dedup guard)
---@param chat table
---@param content string
---@param tag string
---@return boolean
local function already_injected(chat, content, tag)
  return vim.iter(chat.messages):any(function(msg)
    return msg._meta and msg._meta.tag == tag and msg.content == content
  end)
end

--- Auto-inject index only (Level 1) on chat creation.
--- Skill bodies (Level 2) are injected lazily via inject_skills_for_message().
---@param chat table
function M.inject_matching_skills(chat)
  local config = require('codecompanion.config')
  local skills = discover_skills()

  if #skills == 0 then
    return
  end

  local index = build_index(skills)
  if index == '' then
    return
  end

  -- Dedup guard: skip if identical index already present
  if already_injected(chat, index, 'agent_skills') then
    return
  end

  -- Remove any previous index message before re-injecting
  chat.messages = vim
    .iter(chat.messages)
    :filter(function(msg)
      return not (msg._meta and msg._meta.tag == 'agent_skills')
    end)
    :totable()

  -- Inject Level 1 index only — bodies are loaded lazily per message
  chat:add_message(
    { role = config.constants.SYSTEM_ROLE, content = index },
    { visible = false, _meta = { tag = 'agent_skills' } }
  )
end

--- Level 2 lazy body injection: inject skill bodies relevant to a specific user message.
--- Called from on_before_submit with the pending message content.
---@param chat table
---@param message string The user message about to be submitted
function M.inject_skills_for_message(chat, message)
  if not message or message == '' then
    return
  end

  local config = require('codecompanion.config')
  local skills = discover_skills()

  if #skills == 0 then
    return
  end

  -- Find skills relevant to this message (name match only — no glob at submit time)
  local relevant = {}
  for _, skill in ipairs(skills) do
    if not skill.disable_model_invocation and is_skill_relevant(skill, { message = message }) then
      table.insert(relevant, skill)
    end
  end

  if #relevant == 0 then
    return
  end

  local content = build_skill_content(relevant)

  -- Dedup guard: skip if this exact body block is already present
  if already_injected(chat, content, 'agent_skills_body') then
    return
  end

  -- Remove previous body injection (replace with fresh one for this message)
  chat.messages = vim
    .iter(chat.messages)
    :filter(function(msg)
      return not (msg._meta and msg._meta.tag == 'agent_skills_body')
    end)
    :totable()

  chat:add_message(
    { role = config.constants.SYSTEM_ROLE, content = content },
    { visible = false, _meta = { tag = 'agent_skills_body' } }
  )
end

return M
