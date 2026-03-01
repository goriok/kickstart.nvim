# Custom Neovim Kickstart Configuration

This is a personalized Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It serves as a modular and understandable starting point, enhanced with specific tools for AI assistance, file management, and window handling.

## Features

- **Package Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Colorscheme**: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (Night variant)
- **LSP**: Native LSP with [blink.cmp](https://github.com/saghen/blink.cmp) for autocompletion.
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) for auto-formatting.
- **Treesitter**: Syntax highlighting and parsing.
- **Telescope**: Fuzzy finding.
- **Symbol Navigation**: [aerial.nvim](https://github.com/stevearc/aerial.nvim) for code outline and structure.

## Customizations

### AI Integration

- **Plugin**: [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
- **Default Adapter**: GitHub Copilot
- **Available Adapters**: GitHub Copilot, Google Gemini
- **Extensions**: Chat history (`codecompanion-history.nvim`) — open with `gh`, save with `gW` inside chat buffer.
- **MCP Servers** (Model Context Protocol): External tool servers that extend the AI's capabilities via JSON-RPC over stdio. Toggle with `/mcp` in a chat buffer.
  - **Context7** (`@upstash/context7-mcp`): Live, up-to-date library/framework documentation. No API key.
  - **Sequential Thinking** (`@modelcontextprotocol/server-sequential-thinking`): Structured step-by-step reasoning with revision/branching. No API key.
  - **PDF Reader** (`pdf-reader-mcp`): Extracts text and metadata from PDF files. No API key.
- **Prompt Library**: Switchable AI profiles loaded from external files (`~/.local/share/nvim/prompts/`). Available via `<leader>aa`:
  - **Sofi** (`sofi`) — Philosophy mentor (Práxis Filosófica)
  - **Study** (`iam-study`) — OAuth2, OIDC, Federation tutor
  - **Architect** (`iam-arch`) — IAM architecture & design advisor
  - `Browse Chat History` (`history`) and `Browse Summaries` (`summaries`)
- **Statusline Spinner**: A braille spinner animates in the statusline while a request is in flight; `fidget.nvim` shows toast notifications on start/done.
- **Keymaps**:
  - `<leader>ac`: Toggle AI Chat
  - `<leader>ai`: AI Inline Edit (Visual mode)
  - `<leader>aa`: AI Actions
  - `<leader>as`: Open Sofi (Philosophy Mentor) chat
  - `gzs` _(chat buffer)_: Create chat summary
  - `gzb` _(chat buffer)_: Browse saved summaries
- **Custom Commands**:
  - `:CCTitle <new title>`: Rename the current chat (updates UI, history, and buffer name)

### Inline AI Suggestions

- **Plugin**: [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
- **Description**: Inline code suggestions powered by GitHub Copilot, auto-triggered on insert mode.
- **Keymaps**:
  - `<C-l>`: Accept suggestion
  - `<M-]>` / `<M-[>`: Next / Previous suggestion
  - `<C-]>`: Dismiss suggestion

### Code Outline & Symbol Navigation

- **Plugin**: [aerial.nvim](https://github.com/stevearc/aerial.nvim)
- **Description**: Displays code structure (functions, classes, methods, variables) in a tree view for navigation and understanding code organization.
- **Keymaps**:
  - `<leader>ts`: Toggle symbols sidebar
  - `<leader>tS`: Toggle symbols for all buffers
  - Inside aerial: `Enter` to jump, `q` to close, `j/k` to navigate, `{/}` to jump between symbols

### File Management

- **Plugin**: [oil.nvim](https://github.com/stevearc/oil.nvim)
- **Description**: Edit your filesystem like a normal buffer.
- **Keymaps**:
  - `-`: Open parent directory
  - `<C-x>`: Open in horizontal split
  - `<C-v>`: Open in vertical split
  - `<C-t>`: Open in new tab

### Window Management

- **Plugin**: [vim-maximizer](https://github.com/szw/vim-maximizer)
- **Keymaps**:
  - `<leader>ww`: Toggle maximize current window

### Markdown

- **Plugins**:
  - [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) — Rich rendering inside Neovim (also renders CodeCompanion chat buffers).
  - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) — Live preview in browser with Mermaid diagram support.
- **Keymaps**:
  - `<leader>mr`: Toggle Markdown render (in-editor)
  - `<leader>mp`: Toggle Markdown preview (browser)

## Core Keymaps

| Key           | Description                             |
| ------------- | --------------------------------------- |
| `<Space>`     | Leader Key                              |
| `<Esc>`       | Clear search highlights                 |
| `<C-h/j/k/l>` | Navigate between windows                |
| `<leader>sh`  | Search Help                             |
| `<leader>sk`  | Search Keymaps                          |
| `<leader>sf`  | Search Files                            |
| `<leader>sg`  | Live Grep                               |
| `<leader>f`   | Format buffer                           |
| `<leader>ts`  | Toggle code outline (symbols sidebar)   |
| `<leader>tS`  | Toggle code outline for all buffers     |
| `<leader>as`  | Open Sofi (Philosophy Mentor)           |
| `<leader>q`   | Open diagnostic Quickfix list           |
| `<C-l>`       | Accept Copilot suggestion (Insert mode) |
| `<leader>mr`  | Toggle Markdown render (in-editor)      |
| `<leader>mp`  | Toggle Markdown preview (browser)       |

## Language Support

Out of the box support (LSP, Formatting, Highlighting) for:

- **Lua**: `lua_ls`, `stylua`
- **Python**: `pyright`, `ruff`
- **Go**: `gopls` (with built-in staticcheck), `goimports`, `gofumpt`
- **Ruby**: `ruby-lsp`, `rubocop`
- **JavaScript/TypeScript**: `ts_ls`, `eslint-lsp`, `prettierd`
- **CSS/HTML**: `prettierd`
- **Markdown**: `marksman`, `prettierd`, `markdownlint`
- **YAML/JSON**: `yaml-language-server`, `prettierd`

## Installation

### Prerequisites

- Neovim >= 0.10.0
- Git
- Make, GCC (for Telescope fzf-native)
- Ripgrep, fd (for Telescope)
- Nerd Font (recommended)
- Node.js >= 18 (for JS/TS LSP and formatters — recommended via [nvm](https://github.com/nvm-sh/nvm))
- Ruby >= 3.0 (for Ruby LSP — recommended via [rbenv](https://github.com/rbenv/rbenv))

### Setup

1. Backup your existing configuration:

   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. Clone this repository:

   ```sh
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim:
   ```sh
   nvim
   ```
   `lazy.nvim` will automatically install all plugins.

## Structure

- `init.lua`: Main configuration file.
- `lua/custom/plugins/`: User-added plugins (CodeCompanion, Copilot, Markdown, Oil, Maximizer, Aerial, etc.).
- `lua/kickstart/plugins/`: Core Kickstart plugins (Debug, Lint, Gitsigns, etc.).
