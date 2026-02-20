return {
  'szw/vim-maximizer',
  keys = {
    -- Define o atalho <leader>wm (Window Maximize)
    { '<leader>ww', '<cmd>MaximizerToggle<CR>', desc = '[W]indow [M]aximize Toggle' },
  },
  init = function()
    -- Opcional: define se o plugin deve ignorar janelas flutuantes ou fixas
    vim.g.maximizer_set_default_mapping = 0
  end,
}
