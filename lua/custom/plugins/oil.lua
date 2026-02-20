return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      columns = {
        'icon',
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      sync_with_cwd = true,

      -- Mapeamentos customizados para a janela do Oil
      keymaps = {
        -- Desativamos os atalhos padrões do Oil para evitar conflitos
        ['<C-h>'] = false,
        ['<C-s>'] = false,

        -- Adicionamos os atalhos no padrão Telescope
        ['<C-x>'] = 'actions.select_split', -- Split horizontal
        ['<C-v>'] = 'actions.select_vsplit', -- Split vertical

        -- Dica Bônus: O Telescope usa <C-t> para abrir em uma nova Aba (Tab).
        -- Vamos deixar o Oil igual também!
        ['<C-t>'] = 'actions.select_tab',
      },
    }

    -- Atalho para abrir o Oil
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Abrir diretório pai (Oil)' })
  end,
}
