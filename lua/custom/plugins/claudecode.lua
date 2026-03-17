-- lua/custom/plugins/claudecode.lua
-- Neovim IDE integration for Claude Code CLI via WebSocket MCP protocol

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    auto_start = true,
    log_level = 'info',
    terminal_cmd = '~/.local/bin/claude',
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.55,
      provider = 'snacks',
      auto_close = true,
    },
  },
  keys = {
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = '[C]laude [C]ode toggle' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = '[C]laude [F]ocus' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = '[C]laude [R]esume' },
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = '[C]laude add [B]uffer' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[C]laude [S]end selection' },
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[C]laude [A]ccept diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[C]laude [D]eny diff' },
  },
}
