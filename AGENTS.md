# Agents

Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Modular, Lua-based setup managed by `lazy.nvim`.

## Stack

- **Language**: Lua
- **Plugin manager**: `lazy.nvim`
- **Custom plugins**: `lua/custom/plugins/` — one file per plugin
- **Kickstart plugins**: `lua/kickstart/plugins/`

## Conventions

- Use `local` variables; keep plugin configs self-contained
- Commit style: [Conventional Commits](https://www.conventionalcommits.org/) — `feat:`, `fix:`, `chore:`, `docs:` (no scope in parentheses)
- Update `AGENTS.md` on structural changes; update `README.md` on config/plugin/keymap changes

## AI Tooling

`codecompanion.nvim` uses the `claude_code` ACP adapter. MCP servers: Context7 (auto-start), Sequential Thinking, PDF Reader, Memory (on-demand via `/mcp` in chat).

## Discrete Math Notation

Two components implement a shared LaTeX-trigger → Unicode notation for discrete math (set theory, graph theory, logic) in markdown, used for essays and conjecture drafting:

- `after/ftplugin/markdown.lua` — `iabbrev` per symbol (`\forall` → `∀`, expands on space/punctuation); plus `\_text<C-j>` (subscript) and `\^text<C-j>` (superscript), a unified keymap that converts letter-by-letter via Unicode combining/spacing-modifier maps.
- `lua/math_symbols/init.lua` — `blink.cmp` source mirroring the same symbol table, for popup-driven completion when you remember the prefix but not the full trigger.

**Both tables must stay in sync** — every symbol added to one belongs in the other.

**Conjectural relations ("? over an operator")**: Unicode only precomposes three such forms — `≟` (`\eqq`), `⩻` (`\ltq`), `⩼` (`\gtq`). No combining "question mark above" character exists, so it cannot be stacked over arbitrary operators (⊆, ≡, ≤, …) the way `≠` stacks a combining slash. For those, the convention is `<op> ?` as plain text (e.g. `\subseteqq` → `⊆ ?`), not a single Unicode glyph. Superscript `?` was considered and rejected — the superscript Unicode block has no question-mark form at all.

Symbol coverage follows real Unicode precomposed forms only — never invent/simulate a glyph that doesn't exist (check via `unicodedata` before adding).

## Language Support

LSP, formatters, linters and Treesitter configured for Lua, Python, Go, Ruby, JS/TS, Markdown, YAML, JSON, CSS/HTML.
See `docs/LANGUAGE_SUPPORT.md` for the full table.

## Guardrails

- Never remove a plugin without verifying it is not a dependency of another plugin in `lua/custom/plugins/`
- Never modify `lazy-lock.json` directly — use `:Lazy sync` or `:Lazy update <plugin>`
- Never push to remote without explicit user approval
- Do not hardcode paths; use `vim.fn.stdpath('data')` / `vim.fn.stdpath('config')` for portability
