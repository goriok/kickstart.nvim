return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'zbirenbaum/copilot.lua',
    'ravitemer/codecompanion-history.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionChatCreated',
      callback = function(ev)
        local chat = require('codecompanion').buf_get_chat(ev.data.bufnr)
        if chat and chat.adapter and chat.adapter.name == 'copilot' then chat.tool_registry:add_group 'agent' end
      end,
    })

    -- When adapter changes to ollama: strip rules (AGENTS.md context), system prompt, and agent group.
    -- When leaving ollama: rules stay cleared (user can reload with /rules), system prompt
    -- is restored automatically by change_adapter → set_system_prompt.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionChatAdapter',
      callback = function(ev)
        local adapter = ev.data and ev.data.adapter
        if not adapter then return end
        local chat = require('codecompanion').buf_get_chat(ev.data.bufnr)
        if not chat then return end
        if adapter.name == 'ollama' then
          chat:remove_tagged_message 'rules'
          chat:remove_tagged_message 'system_prompt_from_config'
          chat.tool_registry:remove_group 'agent'
          -- Remove rules context items (AGENTS.md, CLAUDE.md) from the context panel
          local rules_ids = {}
          for _, item in ipairs(chat.context_items or {}) do
            if item.source == 'rules' then rules_ids[item.id] = true end
          end
          if next(rules_ids) then chat.context:remove_items(rules_ids) end
        end
      end,
    })
    require('codecompanion').setup {
      adapters = {
        acp = {
          claude_code = function()
            return require('codecompanion.adapters').extend('claude_code', {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_OAUTH_TOKEN,
              },
            })
          end,
        },
        http = {
          ollama = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              name = 'ollama',
              env = {
                url = 'http://localhost:11434',
                api_key = 'ollama',
                chat_url = '/v1/chat/completions',
              },
              schema = {
                model = {
                  default = 'qwen2.5-coder:7b',
                },
                temperature = {
                  order = 2,
                  mapping = 'parameters',
                  type = 'number',
                  default = 0.7,
                },
                top_p = {
                  order = 3,
                  mapping = 'parameters',
                  type = 'number',
                  default = 0.9,
                },
              },
              handlers = {
                on_error = function(err)
                  if type(err) == 'table' and err.stderr then return type(err.stderr) == 'table' and table.concat(err.stderr, '\n') or tostring(err.stderr) end
                  return tostring(err)
                end,
              },
            })
          end,
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-haiku-4-5-20251001',
                },
              },
            })
          end,
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
      },
      interactions = {
        chat = {
          adapter = 'copilot',
          opts = {
            stream = true,
            max_tokens = 4096,
            temperature = 0.7,
            system_prompt = function(ctx)
              if ctx.adapter and ctx.adapter.name == 'ollama' then return '' end
              return ctx.default_system_prompt
            end,
          },
          roles = {
            llm = function(adapter)
              local model = adapter.model and adapter.model.name or nil
              if model then return adapter.formatted_name .. ' (' .. model .. ')' end
              return adapter.formatted_name
            end,
          },
        },
        agent = {
          opts = {
            max_tokens = 4096,
          },
        },
        inline = {
          adapter = 'copilot',
        },
      },
      prompt_library = {
        ['Browse Chats'] = {
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
            n = function() vim.cmd 'CodeCompanionHistory' end,
            v = function() vim.cmd 'CodeCompanionHistory' end,
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
            n = function() vim.cmd 'CodeCompanionSummaries' end,
            v = function() vim.cmd 'CodeCompanionSummaries' end,
          },
        },
      },
      mcp = {
        servers = {
          ['context7'] = {
            cmd = { 'npx', '-y', '@upstash/context7-mcp@latest' },
          },
          ['sequential-thinking'] = {
            cmd = { 'npx', '-y', '@modelcontextprotocol/server-sequential-thinking' },
          },
          ['pdf-reader'] = {
            cmd = { 'uvx', 'pdf-reader-mcp' },
          },
          ['git'] = {
            cmd = { 'uvx', 'mcp-server-git' },
          },
          ['repomix'] = {
            cmd = { 'npx', '-y', 'repomix', '--mcp' },
          },
          ['memory'] = {
            cmd = { 'npx', '-y', '@modelcontextprotocol/server-memory' },
            env = {
              MEMORY_FILE_PATH = vim.fn.stdpath 'data' .. '/mcp-memory/memory.json',
            },
          },
        },
        opts = {
          default_servers = {},
        },
      },
      display = {
        chat = {
          show_token_count = true,
          render_headers = true,
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = 'gh',
            save_chat_keymap = 'gW',
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
            picker = 'default',
            summary = {
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
    {
      '<leader>aR',
      function() require('custom.cc_budget').reset() end,
      mode = 'n',
      desc = '[A]I [R]eset turn counter',
    },
  },
}
