return {
  'nvim-zh/colorful-winsep.nvim',
  event = { 'WinLeave' },
  opts = {
    colors = { '#db4b4b' }, -- mesmo vermelho-claro do tema (DiagnosticError)
    excluded_ft = { 'packer', 'TelescopePrompt', 'mason', 'toggleterm' },
  },
}
