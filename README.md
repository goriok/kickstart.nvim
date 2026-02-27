# Custom Neovim Kickstart Configuration

This is a personalized Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It serves as a modular and understandable starting point, enhanced with specific tools for AI assistance, file management, and window handling.

## Features

- **Package Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Colorscheme**: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (Night variant)
- **LSP**: Native LSP with [blink.cmp](https://github.com/saghen/blink.cmp) for autocompletion.
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) for auto-formatting.
- **Treesitter**: Syntax highlighting and parsing.
- **Telescope**: Fuzzy finding.

## Customizations

### AI Integration
- **Plugin**: [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
- **Default Adapter**: GitHub Copilot
- **Available Adapters**: GitHub Copilot, Google Gemini
- **Extensions**: Chat history (`codecompanion-history.nvim`) — open with `gh`, save with `gW` inside chat buffer.
- **Prompt Library**: `Browse Chat History` (`history`) and `Browse Summaries` (`summaries`) entries available via `<leader>aa`.
- **Statusline Spinner**: A braille spinner animates in the statusline while a request is in flight; `fidget.nvim` shows toast notifications on start/done.
- **Keymaps**:
  - `<leader>ac`: Toggle AI Chat
  - `<leader>ai`: AI Inline Edit (Visual mode)
  - `<leader>aa`: AI Actions
  - `gzs` *(chat buffer)*: Create chat summary
  - `gzb` *(chat buffer)*: Browse saved summaries

### Inline AI Suggestions
- **Plugin**: [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
- **Description**: Inline code suggestions powered by GitHub Copilot, auto-triggered on insert mode.
- **Keymaps**:
  - `<C-l>`: Accept suggestion
  - `<M-]>` / `<M-[>`: Next / Previous suggestion
  - `<C-]>`: Dismiss suggestion

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

| Key | Description |
| --- | --- |
| `<Space>` | Leader Key |
| `<Esc>` | Clear search highlights |
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>sh` | Search Help |
| `<leader>sk` | Search Keymaps |
| `<leader>sf` | Search Files |
| `<leader>sg` | Live Grep |
| `<leader>f` | Format buffer |
| `<leader>q` | Open diagnostic Quickfix list |
| `<C-l>` | Accept Copilot suggestion (Insert mode) |
| `<leader>mr` | Toggle Markdown render (in-editor) |
| `<leader>mp` | Toggle Markdown preview (browser) |

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
- `lua/custom/plugins/`: User-added plugins (CodeCompanion, Copilot, Markdown, Oil, Maximizer, etc.).
- `lua/kickstart/plugins/`: Core Kickstart plugins (Debug, Lint, Gitsigns, etc.).

