return {
  'nickjvandyke/opencode.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  config = function()
    vim.g.opencode_opts = {
      port = nil,
    }
  end,
  keys = {
    { '<leader>oo', function() require('opencode').toggle() end,                         desc = '[O]pencode toggle',        mode = { 'n', 't' } },
    { '<C-a>', function() require('opencode').ask('@this: ', { submit = true }) end,     desc = '[O]pencode ask',           mode = { 'n', 'x' } },
    { '<C-x>', function() require('opencode').select() end,                              desc = '[O]pencode select action', mode = { 'n', 'x' } },
    { 'go',    function() return require('opencode').operator() end,                     desc = '[O]pencode add (operator)', expr = true },
    { 'goo',   function() return require('opencode').operator() .. '_' end,              desc = '[O]pencode add line',       expr = true },
  },
}
