return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Necessário para os ícones bonitos
  },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto', -- Adapta-se automaticamente ao seu tema de cores atual (ex: Tokyonight, Catppuccin)
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true, -- Mantém uma única barra de status na base do ecrã, mesmo com várias janelas abertas
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          -- É exatamente aqui que vamos colocar a função do contador de tokens!
          -- Por enquanto, deixamos as informações padrão:
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
}
