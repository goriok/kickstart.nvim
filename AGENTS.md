# Agents

## Context

The current project is a Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It aims to provide a starting point for users to configure Neovim, with a focus on being modular and understandable.

## Structure

- `init.lua`: The main entry point for the configuration. It sets up the leader key, options, and loads plugins.
- `lua/custom/plugins/`: A directory for user-defined plugins.
  - `aerial.lua`: Configuration for `stevearc/aerial.nvim`, providing code outline and symbol navigation.
  - `codecompanion.lua`: Configuration for the `olimorris/codecompanion.nvim` plugin, which provides AI integration (adapters, strategies, history extension).
  - `copilot.lua`: Configuration for `zbirenbaum/copilot.lua`, providing inline AI suggestions.
  - `init.lua`: A placeholder for adding more custom plugins.
  - `markdown.lua`: Configuration for `render-markdown.nvim` (in-editor rendering) and `markdown-preview.nvim` (browser preview with Mermaid support).
  - `maximizer.lua`: Configuration for `szw/vim-maximizer`.
  - `oil.lua`: Configuration for `stevearc/oil.nvim`.
- `lua/kickstart/`: Core Kickstart configuration files.
  - `health.lua`: Health checks for the configuration.
  - `plugins/`: Configuration for plugins included in Kickstart.
    - `autopairs.lua`: Auto-pairing configuration.
    - `debug.lua`: Debug Adapter Protocol (DAP) configuration.
    - `gitsigns.lua`: Git integration configuration.
    - `indent_line.lua`: Indentation guides configuration.
    - `lint.lua`: Linting configuration using `nvim-lint`.
    - `neo-tree.lua`: File explorer configuration.

## Directives

- **Language**: Lua is the primary language used for configuration.
- **Style**: The configuration follows standard Lua practices for Neovim.
- **Modularity**: Plugins and configurations should be kept modular. `init.lua` orchestrates the setup, while specific plugin configurations reside in `lua/kickstart/plugins/` or `lua/custom/plugins/`.
- **Documentation**: Comments are used extensively to explain the configuration, serving as a guide for the user.
- **Maintenance**: Update `AGENTS.md` if significant changes to the project structure or conventions are made.
- **Documentation**: Update `README.md` if necessary when making significant changes to configuration, plugins or keymaps.

## Tools

The environment includes several tools accessible via Neovim plugins:

- `aerial.nvim`: Code outline and symbol navigation. Displays code structure (functions, classes, methods, etc.) in a tree view for easy navigation and understanding of code organization.
- `codecompanion.nvim`: AI-powered coding assistant (default adapter: Copilot, also available: Gemini and Claude Code). Includes chat history extension (`codecompanion-history.nvim`) with prompt library entries for browsing history and summaries. A spinner is shown in the statusline while requests are in flight (via `vim.uv` timer + `CodeCompanionRequestStarted/Finished` autocmds). MCP servers configured: Context7 (live library docs), Sequential Thinking (structured reasoning), PDF Reader (reads PDF files), and Memory (persistent knowledge graph at `~/.local/share/nvim/mcp-memory/memory.json`). Only Context7 auto-starts by default; others are on-demand — toggle with `/mcp` in chat.
- `copilot.lua`: Inline AI code suggestions (auto-triggered on `InsertEnter`).
- `nvim-dap`: Debugging support.
- `gitsigns.nvim`: Git integration.
- `nvim-lint`: Linting (markdownlint, yamllint, jsonlint, rubocop, eslint).
- `neo-tree.nvim`: File exploration.
- `render-markdown.nvim`: Rich Markdown rendering inside Neovim (also used for CodeCompanion chat buffers).
- `markdown-preview.nvim`: Live Markdown preview in browser with Mermaid diagram support.

## Language Support

LSP, formatting, linting and Treesitter highlighting configured for:

| Language   | LSP                    | Formatter              | Linter                         |
| ---------- | ---------------------- | ---------------------- | ------------------------------ |
| Lua        | `lua-language-server`  | `stylua`               | —                              |
| Python     | `pyright`              | `ruff`                 | —                              |
| Go         | `gopls`                | `goimports`, `gofumpt` | `gopls` (built-in staticcheck) |
| Ruby       | `ruby-lsp`             | `rubocop`              | `rubocop`                      |
| JavaScript | `ts_ls`                | `prettierd`            | `eslint`                       |
| TypeScript | `ts_ls`                | `prettierd`            | `eslint`                       |
| JSX/TSX    | `ts_ls`                | `prettierd`            | `eslint`                       |
| Markdown   | `marksman`             | `prettierd`            | `markdownlint`                 |
| YAML       | `yaml-language-server` | `prettierd`            | `yamllint`                     |
| JSON       | —                      | `prettierd`            | `jsonlint`                     |
| CSS/HTML   | —                      | `prettierd`            | —                              |

Treesitter parsers are also installed for `bash`, `c`, `diff`, `mermaid`, `jsdoc`, `luadoc`, `query`, `vim`, `vimdoc`, and all languages listed above.
Filetype-to-parser mapping handles `typescriptreact` → `tsx` and `javascriptreact` → `javascript` automatically.

## Workflow

1.  **Configuration**: Users modify `init.lua` and files in `lua/custom/plugins/` to tailor Neovim to their needs.
2.  **Plugin Management**: `lazy.nvim` (implied by the structure, though not explicitly seen in the initial file list, it's standard for Kickstart) manages plugins.
3.  **Health Checks**: `:checkhealth kickstart` can be used to verify the configuration.

## Conventions

- Prefer `vim.api` functions where appropriate.
- Use `local` variables to avoid polluting the global namespace.
- Keep plugin configurations self-contained.
