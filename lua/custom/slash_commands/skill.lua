--- /skill slash command for CodeCompanion
--- Lists available skills and injects the selected one (with optional arguments)
--- into the chat as a system message.
---
--- Usage in chat buffer:
---   /skill                    → picker to browse all user-invocable skills
---   /skill plan-mode          → inject plan-mode skill directly
---   /skill plan-mode add git  → inject plan-mode with $ARGUMENTS = "add git"

local config = require('codecompanion.config')
local utils = require('codecompanion.utils')
local agent_skills = require('custom.agent_skills')

local fmt = string.format

---@class CodeCompanion.SlashCommand.Skill: CodeCompanion.SlashCommand
local SlashCommand = {}

---@param args CodeCompanion.SlashCommandArgs
function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
  }, { __index = SlashCommand })

  return self
end

--- Inject a skill into the chat
---@param skill table AgentSkill
---@param arguments? string
local function inject_skill(chat, skill, arguments)
  -- Build the full content with supporting files and argument substitution
  local content = agent_skills.build_skill_content({ skill }, arguments)

  -- Remove any previous skill injection with same name
  chat.messages = vim
    .iter(chat.messages)
    :filter(function(msg)
      return not (msg._meta and msg._meta.tag == 'agent_skill_invoked' and msg._meta.skill_name == skill.name)
    end)
    :totable()

  -- Inject as system message
  chat:add_message(
    { role = config.constants.SYSTEM_ROLE, content = content },
    { visible = false, _meta = { tag = 'agent_skill_invoked', skill_name = skill.name } }
  )

  -- Also add a visible user message to signal the skill was loaded
  local notice = fmt('🔧 Skill **%s** loaded.', skill.name)
  if arguments and arguments ~= '' then
    notice = notice .. fmt(' Arguments: `%s`', arguments)
  end
  if #skill.files > 0 then
    local file_names = vim.tbl_map(function(f)
      return '`' .. f.name .. '`'
    end, skill.files)
    notice = notice .. '\nSupporting files: ' .. table.concat(file_names, ', ')
  end
  chat:add_buf_message({ content = notice })

  utils.notify(fmt('Loaded skill: %s', skill.name))
end

---Execute the slash command
---@param SlashCommands CodeCompanion.SlashCommands
---@return nil
function SlashCommand:execute(SlashCommands)
  local skills = agent_skills.discover_skills()

  -- Filter to user-invocable skills only
  local invocable = vim.tbl_filter(function(s)
    return s.user_invocable ~= false
  end, skills)

  if #invocable == 0 then
    return utils.notify('No skills found in .claude/skills/', vim.log.levels.WARN)
  end

  -- Build display items for picker
  local items = {}
  for _, skill in ipairs(invocable) do
    local label = skill.name
    if skill.argument_hint then
      label = label .. ' ' .. skill.argument_hint
    end

    local flags = {}
    if skill.disable_model_invocation then
      table.insert(flags, 'user-only')
    end
    if #skill.allowed_tools > 0 then
      table.insert(flags, 'tools: ' .. table.concat(skill.allowed_tools, ', '))
    end
    if #skill.files > 0 then
      table.insert(flags, fmt('%d file(s)', #skill.files))
    end

    local desc = skill.description
    if #flags > 0 then
      desc = desc .. ' [' .. table.concat(flags, ' | ') .. ']'
    end

    table.insert(items, {
      label = label,
      description = desc,
      skill = skill,
    })
  end

  vim.ui.select(items, {
    prompt = 'Select a skill:',
    kind = 'codecompanion.nvim',
    format_item = function(item)
      return fmt('%s — %s', item.label, item.description)
    end,
  }, function(selected)
    if not selected then
      return
    end

    local skill = selected.skill

    -- If skill accepts arguments, prompt for them
    if skill.argument_hint then
      vim.ui.input({
        prompt = fmt('Arguments %s: ', skill.argument_hint),
      }, function(input)
        inject_skill(self.Chat, skill, input)
      end)
    else
      inject_skill(self.Chat, skill, nil)
    end
  end)
end

return SlashCommand
