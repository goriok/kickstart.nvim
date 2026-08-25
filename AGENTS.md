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

No in-editor AI chat/IDE plugin — Claude Code is used externally, outside Neovim. `codecompanion.nvim` and its adapter/prompt-library infrastructure were removed (`91ebb31`); `claudecode.nvim` and `opencode.nvim` were removed afterward for the same reason.

## Claude Code Skills

`.claude/skills/` holds this repo's skills; `lua/custom/skills_sync.lua` symlinks each into `~/.claude/skills/` on `VimEnter` so they're available outside this repo too.

## Discrete Math Notation

Two components implement a shared LaTeX-trigger → Unicode notation for discrete math (set theory, graph theory, logic) in markdown, used for essays and conjecture drafting:

- `after/ftplugin/markdown.lua` — `iabbrev` per symbol (`\forall` → `∀`, expands on space/punctuation); plus `\_text<C-j>` (subscript) and `\^text<C-j>` (superscript), a unified keymap that converts letter-by-letter via Unicode combining/spacing-modifier maps.
- `lua/math_symbols/init.lua` — `blink.cmp` source mirroring the same symbol table, for popup-driven completion when you remember the prefix but not the full trigger.

**Both tables must stay in sync** — every symbol added to one belongs in the other.

**Conjectural relations ("? over an operator")**: Unicode only precomposes three such forms — `≟` (`\eqq`), `⩻` (`\ltq`), `⩼` (`\gtq`). No combining "question mark above" character exists, so it cannot be stacked over arbitrary operators (⊆, ≡, ≤, …) the way `≠` stacks a combining slash. For those, the convention is `<op> ?` as plain text (e.g. `\subseteqq` → `⊆ ?`), not a single Unicode glyph. Superscript `?` was considered and rejected — the superscript Unicode block has no question-mark form at all.

There are two distinct uses of a trailing `?`, not to be confused:
- **`<op> ?`** marks one specific relation as unproven *within* a larger derivation (e.g. a step in a proof) — the `?` binds to that operator only.
- **`<sentence> ?`** (a bare `?` at the end of the whole line, not attached to any operator) marks the entire proposition as an open question — e.g. `(Scope, ⊑)?` asking whether `⊑` is actually a partial order, or `∀prop ∈ Identity₁ ∃s ∈ Scope: s ∈ scopes(prop) ?` asking whether the whole statement holds. No dedicated symbol or trigger for this — plain `?` typed normally at end of line.

Symbol coverage follows real Unicode precomposed forms only — never invent/simulate a glyph that doesn't exist (check via `unicodedata` before adding).

## Language Support

LSP, formatters, linters and Treesitter configured for Lua, Python, Go, Ruby, JS/TS, Kotlin, Markdown, YAML, JSON, CSS/HTML.
See `docs/LANGUAGE_SUPPORT.md` for the full table.

Markdown linting (`markdownlint`) runs with `MD013` (line-length) disabled globally — see `.markdownlint.jsonc` and `lint.lua`. Prose in this repo (and in the user's global CLAUDE.md convention) is written as one logical line per paragraph, no hard-wrap, so line-length is not a real lint issue here.

## Colorscheme

Active: `gruvbox.nvim` (`init.lua`). Additional themes (catppuccin, dracula, everforest, kanagawa, nightfox, nord, tokyonight) are installed `lazy = true` for on-demand switching — do not remove them when changing the active colorscheme unless asked. `WinSeparator` is hardcoded to the theme's `DiagnosticError` red on `ColorScheme` — if you change colorscheme, verify this highlight still applies (or gruvbox's autocmd needs to be replicated for the new theme).

## Window Focus Signaling

Three plugins jointly signal the active split — `focus.nvim` (signcolumn), `vimade` (dims inactive windows' background and syntax highlighting, fadelevel 0.4), `colorful-winsep.nvim` (bright red animated border on active window edge). `vimade`'s blocklist preserves `SignColumn`, `WinSeparator`, `ColorfulWinSep*` so the three don't visually compete — if you touch any of the three plugin configs, keep that blocklist in sync or the signals will fight each other again (see `f9a2f23`).

## Guardrails

- Never remove a plugin without verifying it is not a dependency of another plugin in `lua/custom/plugins/`
- Never modify `lazy-lock.json` directly — use `:Lazy sync` or `:Lazy update <plugin>`
- Never push to remote without explicit user approval
- Do not hardcode paths; use `vim.fn.stdpath('data')` / `vim.fn.stdpath('config')` for portability
