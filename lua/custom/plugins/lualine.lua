return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Necessário para os ícones bonitos
    'franco-ruggeri/codecompanion-lualine.nvim',
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
          {
            function()
              local api = require('codecompanion').buf_get_chat(vim.fn.bufnr())
              if api then return '🤖 ' .. (api.tokens or '-') end
              return ''
            end,
            cond = function() return vim.bo.filetype == 'codecompanion' end,
          },
          'codecompanion',
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
