# Custom Neovim Kickstart Configuration

This is a personalized Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It serves as a modular and understandable starting point, enhanced with specific tools for AI assistance, file management, and window handling.

## Features

- **Package Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Colorscheme**: [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) — plus catppuccin, dracula, everforest, kanagawa, nightfox, nord and tokyonight installed lazy for on-demand switching (`:colorscheme <name>`)
- **LSP**: Native LSP with [blink.cmp](https://github.com/saghen/blink.cmp) for autocompletion.
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) for auto-formatting.
- **Treesitter**: Syntax highlighting and parsing.
- **Telescope**: Fuzzy finding.
- **Symbol Navigation**: [aerial.nvim](https://github.com/stevearc/aerial.nvim) for code outline and structure.

## Customizations

### Claude Code IDE Integration

- **Plugin**: [claudecode.nvim](https://github.com/coder/claudecode.nvim)
- **Description**: Native Neovim IDE extension for Claude Code CLI. Implements the same WebSocket MCP protocol as the official VS Code extension — Claude sees your buffers, selections, and can propose diffs in real-time.
- **Requirements**: `claude` CLI installed (`~/.local/bin/claude`)
- **Keymaps**:
  - `<leader>cc`: Toggle Claude Code terminal
  - `<leader>cf`: Focus Claude terminal
  - `<leader>cr`: Resume last Claude session
  - `<leader>cb`: Add current buffer to Claude context
  - `<leader>cs` _(visual)_: Send selection to Claude
  - `<leader>ca`: Accept proposed diff
  - `<leader>cd`: Deny proposed diff
- **Commands**:
  - `:ClaudeCodeStatus` — check WebSocket server status
  - `:ClaudeCodeSelectModel` — select Claude model

### Opencode Chat

- **Plugin**: [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim)
- **Description**: Secondary in-editor AI chat, talking to a local `opencode` server (separate from the Claude Code terminal integration above).
- **Keymaps**:
  - `<leader>oo`: Toggle Opencode
  - `<C-a>` _(normal/visual)_: Ask about the current context
  - `<C-x>` _(normal/visual)_: Select action
  - `go` / `goo`: Add to context (operator / current line)

### Discrete Math Notation (Markdown)

- **Files**: `after/ftplugin/markdown.lua` (iabbrev), `lua/math_symbols/init.lua` (blink.cmp source)
- **Description**: LaTeX-style triggers expand to Unicode math symbols while typing in markdown buffers — `\forall` → `∀`, `\subseteq` → `⊆`, etc. `iabbrev` expands on word boundary (space/punctuation); the blink.cmp source additionally suggests matches via popup while typing a partial trigger.
- **Subscripts**: `\_` followed by letters/digits converts to Unicode subscript on demand — e.g. `A\_max` + trigger key → `Aₘₐₓ`. Covers Latin (`a e h i j k l m n o p r s t u v x`) and Greek (`β γ ρ φ χ`) lowercase letters — the only ones with a real Unicode subscript codepoint. Uppercase letters fold to their lowercase glyph (Unicode has no uppercase subscript in any block) — e.g. `A\_N` → `Aₙ`. Letters with no Unicode subscript at all (Latin `b c d f g q w y z`; Greek everything else) pass through unconverted.
- **Keymaps**:
  - `<C-j>` _(insert mode, markdown buffer)_: Convert `\_word` immediately before the cursor into Unicode subscript

### Code Outline & Symbol Navigation

- **Plugin**: [aerial.nvim](https://github.com/stevearc/aerial.nvim)
- **Description**: Displays code structure (functions, classes, methods, variables) in a tree view for navigation and understanding code organization.
- **Keymaps**:
  - `<leader>ts`: Toggle symbols sidebar
  - `<leader>tS`: Toggle symbols for all buffers
  - Inside aerial: `Enter` to jump, `q` to close, `j/k` to navigate, `{/}` to jump between symbols

### File Bookmarking

- **Plugin**: [grapple.nvim](https://github.com/cbochs/grapple.nvim)
- **Description**: Tag files for instant recall, scoped per git project.
- **Keymaps**:
  - `<leader>ha`: Tag current file (optional name prompt)
  - `<leader>hh`: Toggle tags menu
  - `<leader>1` / `<leader>2` / `<leader>3` / `<leader>4`: Jump to tagged file 1-4
  - `<leader>hn` / `<leader>hp`: Cycle next/previous tagged file

### File Management

- **Plugin**: [oil.nvim](https://github.com/stevearc/oil.nvim)
- **Description**: Edit your filesystem like a normal buffer.
- **Keymaps**:
  - `-`: Open parent directory
  - `<leader>-`: Open Oil in a new vertical split
  - `<leader>\`: Open Oil in a new horizontal split
  - `<C-x>`: Open in horizontal split
  - `<C-v>`: Open in vertical split
  - `<C-t>`: Open in new tab

### Window Focus Signaling

- **Plugins**: [focus.nvim](https://github.com/nvim-focus/focus.nvim), [vimade](https://github.com/TaDaa/vimade), [colorful-winsep.nvim](https://github.com/nvim-zh/colorful-winsep.nvim)
- **Description**: Three plugins combine to make the active split unmistakable — `colorful-winsep.nvim` draws a bright red animated border on the active window's edge, `vimade` dims the background and syntax-highlighted text of every inactive window (fadelevel 0.4), and `focus.nvim` keeps the signcolumn signal. `WinSeparator` is also linked to the theme's `DiagnosticError` red so splits stay visible even without vimade's dimming. The three preserve each other's highlight groups (`SignColumn`, `WinSeparator`, `ColorfulWinSep*`) via `vimade`'s blocklist so they don't compete.

### Session Management

- **Plugin**: [persistence.nvim](https://github.com/folke/persistence.nvim)
- **Description**: Automatically saves the current session (open buffers, splits, window sizes, working directory) on exit and restores it when you reopen Neovim in the same directory.
- **Behavior**: Session is saved automatically on `VimLeavePre` and can be restored manually or via keymap.
- **Keymaps**:
  - `<leader>qs`: Restore session for the current directory
  - `<leader>ql`: Restore last session (regardless of directory)
  - `<leader>qd`: Quit without saving the session

### Window Management

- **Plugin**: [vim-maximizer](https://github.com/szw/vim-maximizer)
- **Keymaps**:
  - `<leader>ww`: Toggle maximize current window

### Terminal

- **Plugin**: [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- **Description**: Multiple managed terminals (horizontal, float, vertical).
- **Keymaps**:
  - `<leader>tt`: Toggle terminal (horizontal)
  - `<leader>tf`: Toggle terminal (float)
  - `<leader>tv`: Toggle terminal (vertical)
  - `<C-h/j/k/l>` _(terminal mode)_: Move focus between windows

### Editing (mini.nvim)

- **Plugin**: [mini.nvim](https://github.com/nvim-mini/mini.nvim)
- **Description**: Collection of small, independent editing modules — text objects (`mini.ai`), surround manipulation (`mini.surround`), comments (`mini.comment`), cursor-word highlight (`mini.cursorword`), indent scope guides (`mini.indentscope`). Full module reference: `docs/MINI_PLUGINS.md`.

### Statusline

- **Plugin**: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Description**: Statusline (mode, branch, diff, diagnostics, filename, encoding, progress, location); theme adapts automatically to the active colorscheme. Also hosts the [nvim-token-counter](https://github.com/lancekrogers/nvim-token-counter) component, which shows an estimated Claude token count for the buffer.

### TODO Comments

- **Plugin**: [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- **Description**: Highlights and searches `TODO`/`FIX`/`HACK`/`WARN`/`PERF`/`NOTE`/`TEST` comments, with sign-column icons.
- **Keymaps**:
  - `]t` / `[t`: Jump to next/previous TODO comment
  - `<leader>st`: Search all TODO comments (Telescope)
  - `<leader>sT`: Search TODO/FIX/FIXME only
  - `<leader>xt` / `<leader>xT`: Send TODOs to quickfix / location list

### Markdown

- **Plugins**:
  - [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) — Rich rendering inside Neovim.
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
| `<leader>q`   | Open diagnostic Quickfix list           |
| `<leader>mr`  | Toggle Markdown render (in-editor)      |
| `<leader>mp`  | Toggle Markdown preview (browser)       |
| `<leader>cc`  | Toggle Claude Code terminal             |
| `<leader>cf`  | Focus Claude Code terminal              |
| `<leader>cr`  | Resume last Claude session              |
| `<leader>cb`  | Add current buffer to Claude context    |
| `<leader>cs`  | Send selection to Claude (visual mode)  |
| `<leader>ca`  | Accept Claude diff                      |
| `<leader>cd`  | Deny Claude diff                        |
| `<leader>oo`  | Toggle Opencode chat                    |
| `<leader>ha`  | Grapple: tag current file               |
| `<leader>hh`  | Grapple: toggle tags menu               |
| `<leader>tt`  | Toggle terminal (horizontal)            |
| `<leader>qs`  | Restore session for current directory   |
| `<leader>ql`  | Restore last session                    |
| `<leader>qd`  | Quit without saving session             |

## Language Support

Out of the box support (LSP, Formatting, Highlighting) for:

- **Lua**: `lua_ls`, `stylua`
- **Python**: `pyright`, `ruff`
- **Go**: `gopls` (with built-in staticcheck), `goimports`, `gofumpt`
- **Ruby**: `ruby-lsp`, `rubocop`
- **JavaScript/TypeScript**: `ts_ls`, `eslint-lsp`, `prettierd`
- **Kotlin**: `kotlin-language-server`, `ktlint` (setup notes: `docs/neovim-kotlin-setup.md`)
- **CSS/HTML**: `prettierd`
- **Markdown**: `marksman`, `prettierd`, `markdownlint` (MD013 line-length disabled — prose is written one logical line per paragraph, no hard-wrap)
- **YAML/JSON**: `yaml-language-server` (auto Kubernetes schema for `*.yaml`, plus SchemaStore catalog), `prettierd`

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
- `lua/custom/plugins/`: User-added plugins (Claude Code, Opencode, Markdown, Oil, Maximizer, Aerial, etc.).
- `lua/kickstart/plugins/`: Core Kickstart plugins (Debug, Lint, Gitsigns, etc.).
