return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'zbirenbaum/copilot.lua', -- Ensure copilot is loaded
    'ravitemer/codecompanion-history.nvim', -- Chat history extension
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        copilot = function() return require('codecompanion.adapters').extend('copilot', {}) end,
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
            schema = {
              model = {
                default = 'gemini-3-flash-preview',
                choices = {
                  ['gemini-3-flash-preview'] = { opts = { can_reason = true, has_vision = true } },
                  ['gemini-3-pro-preview'] = { opts = { can_reason = true, has_vision = true } },
                },
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        agent = {
          adapter = 'copilot',
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
      prompt_library = {
        ['Browse Chat History'] = {
          strategy = 'chat',
          description = 'Browse and restore saved chat history',
          opts = {
            index = 4,
            is_default = false,
            is_slash_cmd = false,
            short_name = 'history',
            modes = { 'n', 'v' },
          },
          prompts = {
            n = function()
              vim.cmd 'CodeCompanionHistory'
            end,
            v = function()
              vim.cmd 'CodeCompanionHistory'
            end,
          },
        },
        ['Browse Summaries'] = {
          strategy = 'chat',
          description = 'Browse saved chat summaries',
          opts = {
            index = 5,
            is_default = false,
            is_slash_cmd = false,
            short_name = 'summaries',
            modes = { 'n', 'v' },
          },
          prompts = {
            n = function()
              vim.cmd 'CodeCompanionSummaries'
            end,
            v = function()
              vim.cmd 'CodeCompanionSummaries'
            end,
          },
        },
      },
      display = {
        chat = {
          show_token_count = true,
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer
            keymap = 'gh',
            -- Keymap to save the current chat manually
            -- NOTE: avoid 'gsc' because 'gs' (toggle system prompt) fires before 'c'
            save_chat_keymap = 'gW',
            -- Save directory
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
            -- Picker: 'telescope' | 'snacks' | 'fzf_lua' | 'mini_pick' | 'default'
            picker = 'default',
            summary = {
              -- NOTE: avoid 'gcs'/'gbs' — 'gc' and 'gb' are prefixes of existing keymaps
              -- ('gc' = codeblock, 'gba'/'gbd' = buffer sync), causing input delay.
              -- 'gz' is unused by codecompanion, making it a safe prefix.
              create_summary_keymap = 'gzs',
              browse_summaries_keymap = 'gzb',
            },
          },
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
