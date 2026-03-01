return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'zbirenbaum/copilot.lua', -- Ensure copilot is loaded
    'ravitemer/codecompanion-history.nvim', -- Chat history extension
  },
  config = function()
    --- Read a system prompt from ~/.local/share/nvim/prompts/<name>.md
    --- Keeps prompts outside the repo (private, not pushed to GitHub)
    ---@param name string filename without extension
    ---@param fallback string fallback if file not found
    ---@return string
    local function load_prompt(name, fallback)
      local path = vim.fn.stdpath 'data' .. '/prompts/' .. name .. '.md'
      local f = io.open(path, 'r')
      if not f then
        vim.notify('Prompt not found: ' .. path, vim.log.levels.WARN)
        return fallback
      end
      local content = f:read '*a'
      f:close()
      return content
    end

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
          adapter = 'claude_code',
          roles = {
            ---Show the adapter name + model in the chat header
            ---e.g. "Copilot (gpt-4o)" or "Gemini (gemini-3-flash-preview)"
            ---@param adapter CodeCompanion.Adapter
            ---@return string
            llm = function(adapter)
              local model = adapter.model and adapter.model.name or nil
              if model then return adapter.formatted_name .. ' (' .. model .. ')' end
              return adapter.formatted_name
            end,
          },
        },
        inline = {
          adapter = 'copilot',
        },
        agent = {
          adapter = 'claude_code',
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
        -- Sofi: Mentora de Práxis Filosófica
        -- System prompt lives outside the repo at: ~/.local/share/nvim/prompts/sofi.md
        -- Uses Gemini adapter (switch models with `ga` in chat)
        ['Sofi'] = {
          strategy = 'chat',
          description = 'Mentora de Práxis Filosófica e Historiadora das Ideias',
          opts = {
            index = 6,
            is_default = false,
            is_slash_cmd = false,
            short_name = 'sofi',
            modes = { 'n', 'v' },
            ignore_system_prompt = true,
          },
          prompts = {
            {
              role = 'system',
              content = function() return load_prompt('sofi', 'Você é Sofi, mentora de práxis filosófica.') end,
            },
            {
              role = 'user',
              content = '',
            },
          },
        },
        -- Identity Study: OAuth2, OIDC, Federation tutor
        -- System prompt at: ~/.local/share/nvim/prompts/identity-study.md
        ['Study'] = {
          strategy = 'chat',
          description = 'IAM Study Companion — OAuth2, OIDC, Federation',
          opts = {
            index = 7,
            is_default = false,
            is_slash_cmd = false,
            short_name = 'iam-study',
            modes = { 'n', 'v' },
          },
          prompts = {
            {
              role = 'system',
              content = function() return load_prompt('identity-study', 'You are an Identity & Access Management study companion.') end,
            },
            {
              role = 'user',
              content = '',
            },
          },
        },
        -- Identity Architect: Architecture & design analysis for IAM systems
        -- System prompt at: ~/.local/share/nvim/prompts/identity-architect.md
        ['Architect'] = {
          strategy = 'chat',
          description = 'IAM Architecture & Software Design Advisor',
          opts = {
            index = 8,
            is_default = false,
            is_slash_cmd = false,
            short_name = 'iam-arch',
            modes = { 'n', 'v' },
          },
          prompts = {
            {
              role = 'system',
              content = function() return load_prompt('identity-architect', 'You are a Senior Identity Architect.') end,
            },
            {
              role = 'user',
              content = '',
            },
          },
        },
      },
      -- MCP (Model Context Protocol) Servers
      -- MCP lets LLMs call external tool servers via JSON-RPC over stdio.
      -- These add capabilities that built-in tools don't have.
      -- Use /mcp in a chat buffer to toggle servers on/off.
      mcp = {
        servers = {
          -- Live, up-to-date documentation for libraries/frameworks.
          -- Instead of relying on stale training data, the AI fetches
          -- current docs from the source. No API key needed.
          -- https://github.com/upstash/context7
          ['context7'] = {
            cmd = { 'npx', '-y', '@upstash/context7-mcp@latest' },
          },
          -- Structured step-by-step reasoning with revision and branching.
          -- Forces the AI to break complex problems into explicit steps
          -- instead of jumping to conclusions. No API key needed.
          -- https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
          ['sequential-thinking'] = {
            cmd = { 'npx', '-y', '@modelcontextprotocol/server-sequential-thinking' },
          },
          -- PDF reader — extracts text and metadata from PDF files.
          -- Lets the AI read books, papers, and documents directly.
          -- https://github.com/github/pdf-reader-mcp
          ['pdf-reader'] = {
            cmd = { 'uvx', 'pdf-reader-mcp' },
          },
          -- Git operations (status, diff, log, commit, branch, etc.) on local repos.
          -- No GitHub/GitLab — pure Git. Pass the repo path as the first argument,
          -- or omit it to default to the current working directory.
          -- https://github.com/modelcontextprotocol/servers/tree/main/src/git
          ['git'] = {
            cmd = { 'uvx', 'mcp-server-git' },
          },
          -- Persistent memory as a knowledge graph.
          -- The AI can store entities, relations and observations
          -- that survive across conversations. Data lives in a local JSON file.
          -- Works with any adapter (Copilot, Gemini, etc.) — it's an external
          -- MCP server, not the Anthropic-specific built-in memory tool.
          -- https://github.com/modelcontextprotocol/servers/tree/main/src/memory
          ['memory'] = {
            cmd = { 'npx', '-y', '@modelcontextprotocol/server-memory' },
            env = {
              MEMORY_FILE_PATH = vim.fn.stdpath 'data' .. '/mcp-memory/memory.json',
            },
          },
        },
        opts = {
          -- Servers listed here auto-start when CodeCompanion loads.
          -- Remove a name to make it on-demand only (toggle with /mcp in chat).
          default_servers = { 'context7', 'git', 'memory', 'sequential-thinking' },
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
  init = function()
    vim.api.nvim_create_user_command('CCTitle', function(opts)
      local title = opts.args
      if not title or title == '' then
        vim.notify('Usage: :CCTitle <new title>', vim.log.levels.WARN)
        return
      end
      local chat = require('codecompanion').buf_get_chat()
      if not chat then
        vim.notify('No active CodeCompanion chat buffer', vim.log.levels.WARN)
        return
      end
      chat:set_title(title)
      vim.notify('Chat title set to: ' .. title, vim.log.levels.INFO)
    end, { nargs = '+', desc = 'Set the title of the current CodeCompanion chat' })
  end,
  keys = {
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = '[A]I [C]hat' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = 'v', desc = '[A]I [I]nline Edit' },
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[A]I [A]ctions' },
    { '<leader>as', '<cmd>CodeCompanion /sofi<cr>', mode = { 'n', 'v' }, desc = '[A]I [S]ofi' },
    { '<leader>ag', '<cmd>CodeCompanion /commit<cr>', mode = 'n', desc = '[A]I [G]it Commit Message' },
  },
}
