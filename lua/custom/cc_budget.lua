-- lua/custom/cc_budget.lua
-- Circuit breaker + turn tracking for CodeCompanion.
-- Warns at WARN_AT turns, fires a hard notification at MAX_TURNS.
-- Tracks active adapter/model per buffer for budget-aware statusline.
-- Exposes M.statusline() for mini.statusline integration.
-- Call M.setup() once during startup (see mini.nvim config in init.lua).

local M = {}

M.MAX_TURNS = 10
M.WARN_AT = 7

-- state[bufnr] = { turns = n, warned = bool, adapter = string|nil, model = string|nil }
local state = {}
-- most recently focused codecompanion buffer (used as fallback by statusline)
local last_cc_buf = nil

--- Resolve the codecompanion buffer from an autocmd event.
--- Priority: ev.data.bufnr → last known CC buf → any visible CC win → current buf.
local function resolve_buf(ev)
  if ev and ev.data and type(ev.data.bufnr) == 'number' then return ev.data.bufnr end
  if last_cc_buf and vim.api.nvim_buf_is_valid(last_cc_buf) then return last_cc_buf end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.bo[b].filetype == 'codecompanion' then return b end
  end
  return vim.api.nvim_get_current_buf()
end

function M.setup()
  local g = vim.api.nvim_create_augroup('CCBudget', { clear = true })

  -- Track the most recently active CC buffer for statusline fallback.
  vim.api.nvim_create_autocmd('BufEnter', {
    group = g,
    callback = function(ev)
      if vim.bo[ev.buf].filetype == 'codecompanion' then last_cc_buf = ev.buf end
    end,
  })

  -- Reset counter when a new chat is created.
  vim.api.nvim_create_autocmd('User', {
    group = g,
    pattern = 'CodeCompanionChatCreated',
    callback = function(ev)
      local b = resolve_buf(ev)
      state[b] = { turns = 0, warned = false }
      last_cc_buf = b
      vim.cmd.redrawstatus()
    end,
  })

  -- Increment counter on each request; track adapter/model; fire warnings.
  vim.api.nvim_create_autocmd('User', {
    group = g,
    pattern = 'CodeCompanionRequestStarted',
    callback = function(ev)
      local b = resolve_buf(ev)
      if not state[b] then state[b] = { turns = 0, warned = false } end
      state[b].turns = state[b].turns + 1
      local n = state[b].turns

      local adapter = ev.data and ev.data.adapter
      if adapter then
        state[b].adapter = adapter.name
        state[b].model = adapter.model
      end

      if n == M.MAX_TURNS then
        vim.notify(
          ('⛔ Circuit breaker: turn %d/%d\nContext rot risk — open a fresh chat (<leader>ac)'):format(n, M.MAX_TURNS),
          vim.log.levels.ERROR,
          { title = 'CC Budget' }
        )
      elseif n >= M.WARN_AT and not state[b].warned then
        state[b].warned = true
        vim.notify(
          ('⚠  Turn %d/%d — %d left. Summarize context or start fresh soon.'):format(n, M.MAX_TURNS, M.MAX_TURNS - n),
          vim.log.levels.WARN,
          { title = 'CC Budget' }
        )
      end

      vim.cmd.redrawstatus()
    end,
  })

  -- Clean up state for deleted buffers.
  vim.api.nvim_create_autocmd('BufDelete', {
    group = g,
    callback = function(ev)
      state[ev.buf] = nil
      if last_cc_buf == ev.buf then last_cc_buf = nil end
    end,
  })
end

--- Shorten a model id for statusline display.
--- "gpt-4.1" → "gpt-4.1", "claude-sonnet-4.5" → "sonnet-4.5"
---@param model string
---@return string
local function short_model(model)
  if not model or model == '' then return '' end
  -- strip common vendor prefixes
  return (model:gsub('^claude%-', ''):gsub('^gpt%-', 'gpt'))
end

--- Statusline component. Returns '' when there is no tracked CC session.
--- Format: icon T:n/max adapter(model)
--- Icons: 💬 normal · ⚠  approaching limit · ⛔ at limit
function M.statusline()
  local b = last_cc_buf
  if not b or not vim.api.nvim_buf_is_valid(b) then return '' end
  local s = state[b]
  if not s or s.turns == 0 then return '' end
  local n = s.turns
  local icon = n >= M.MAX_TURNS and '⛔' or n >= M.WARN_AT and '⚠ ' or '💬'
  local suffix = ''
  if s.adapter and s.model and s.model ~= '' then
    suffix = ' ' .. s.adapter .. '(' .. short_model(s.model) .. ')'
  elseif s.adapter then
    suffix = ' ' .. s.adapter
  end
  return ('%sT:%d/%d%s'):format(icon, n, M.MAX_TURNS, suffix)
end

--- Returns the raw turn count for a buffer (or last active CC buf).
---@param bufnr? integer
---@return integer turns, integer max_turns
function M.get_turns(bufnr)
  local b = bufnr or last_cc_buf
  if not b then return 0, M.MAX_TURNS end
  local s = state[b]
  return s and s.turns or 0, M.MAX_TURNS
end

--- Reset the counter for the given buffer (or the last active CC buffer).
---@param bufnr? integer
function M.reset(bufnr)
  local b = bufnr or last_cc_buf
  if not b then
    vim.notify('No active CodeCompanion chat found', vim.log.levels.WARN)
    return
  end
  local prev = state[b]
  state[b] = { turns = 0, warned = false, adapter = prev and prev.adapter, model = prev and prev.model }
  vim.notify('CC Budget: counter reset for buf ' .. b, vim.log.levels.INFO, { title = 'CC Budget' })
  vim.cmd.redrawstatus()
end

return M
