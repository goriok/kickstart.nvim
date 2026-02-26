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
- **Adapter**: Google Gemini
- **Keymaps**:
  - `<leader>ac`: Toggle AI Chat
  - `<leader>ai`: AI Inline Edit (Visual mode)
  - `<leader>aa`: AI Actions

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
- **Plugin**: [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- Improves Markdown viewing experience directly in Neovim.

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

## Language Support

Out of the box support (LSP, Formatting, Highlighting) for:
- **Lua**: `lua_ls`, `stylua`
- **Python**: `pyright`, `ruff`
- **Go**: `gopls`, `goimports`, `gofumpt`
- **Markdown**: `marksman`, `prettierd`, `markdownlint`
- **YAML/JSON**: `yaml-language-server`, `prettierd`

## Installation

### Prerequisites
- Neovim >= 0.10.0
- Git
- Make, GCC (for Telescope fzf-native)
- Ripgrep, fd (for Telescope)
- Nerd Font (recommended)

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
- `lua/custom/plugins/`: User-added plugins (CodeCompanion, Oil, Maximizer, etc.).
- `lua/kickstart/plugins/`: Core Kickstart plugins (Debug, Lint, Gitsigns, etc.).

