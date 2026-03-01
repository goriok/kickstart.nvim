# Agents

Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Modular, Lua-based setup managed by `lazy.nvim`.

## Stack

- **Language**: Lua
- **Plugin manager**: `lazy.nvim`
- **Custom plugins**: `lua/custom/plugins/` — one file per plugin
- **Kickstart plugins**: `lua/kickstart/plugins/`

## Conventions

- Use `local` variables; keep plugin configs self-contained
- Update `AGENTS.md` on structural changes; update `README.md` on config/plugin/keymap changes

## AI Tooling

`codecompanion.nvim` uses the `claude_code` ACP adapter. MCP servers: Context7 (auto-start), Sequential Thinking, PDF Reader, Memory (on-demand via `/mcp` in chat).

## Language Support

LSP, formatters, linters and Treesitter configured for Lua, Python, Go, Ruby, JS/TS, Markdown, YAML, JSON, CSS/HTML.
See `docs/LANGUAGE_SUPPORT.md` for the full table.
