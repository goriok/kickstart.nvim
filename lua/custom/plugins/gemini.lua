return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
            schema = {
              model = {
                default = 'gemini-3-flash-preview',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'gemini',
        },
        inline = {
          adapter = 'gemini',
        },
        agent = {
          adapter = 'gemini',
          tools = {
            ['editor'] = {
              callback = 'helpers.tools.editor',
              description = 'Update a buffer',
            },
            ['files'] = {
              callback = 'helpers.tools.files',
              description = 'File operations',
            },
          },
        },
      },
      display = {
        chat = {
          show_token_count = true,
          render_headers = true,
        },
      },
    }
  end,
  keys = {
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = '[A]I [C]hat' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = 'v', desc = '[A]I [I]nline Edit' },
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[A]I [A]ctions' },
  },
}
