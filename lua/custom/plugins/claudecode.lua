return {
  'coder/claudecode.nvim',
  -- snacks.nvim não é necessário com provider = "native"
  opts = {
    terminal = {
      provider = 'native',
      split_side = 'right',
      split_width_percentage = 0.45,
    },
    auto_start = true,
    track_selection = true,
    focus_after_send = true,
    diff_opts = {
      layout = 'vertical',
      open_in_new_tab = false,
      keep_terminal_focus = false,
    },
  },
  keys = {
    { '<leader>Cc', '<cmd>ClaudeCode<cr>', desc = '[C]laude [C]ode toggle' },
    { '<leader>Cf', '<cmd>ClaudeCodeFocus<cr>', desc = '[C]laude [C]ode [F]ocus' },
    { '<leader>Cr', '<cmd>ClaudeCode --resume<cr>', desc = '[C]laude [C]ode [R]esume' },
    { '<leader>Cn', '<cmd>ClaudeCode --continue<cr>', desc = '[C]laude [C]ode co[N]tinue' },
    { '<leader>Cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = '[C]laude [C]ode select [M]odel' },
    { '<leader>Cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[C]laude [C]ode [S]end selection' },
    { '<leader>Ca', '<cmd>ClaudeCodeAdd %<cr>', desc = '[C]laude [C]ode [A]dd buffer' },
    { '<leader>Cda', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[C]laude [C]ode [D]iff [A]ccept' },
    { '<leader>Cdd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[C]laude [C]ode [D]iff [D]eny' },
  },
}
