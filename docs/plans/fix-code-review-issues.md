# Plan: Fix All Code Review Issues

> Created: 2026-03-10

## Goal
Fix all 10 code review issues across the Neovim config: bugs, dead code, conflicts, redundancy and quality issues.

## Affected Files
| Action | File | Reason |
|--------|------|--------|
| modify | `init.lua` | Remove duplicate entries in `ensure_installed`; remove inline gitsigns signs config |
| modify | `lua/kickstart/plugins/gitsigns.lua` | Fix `<leader>hu` → `undo_stage_hunk` |
| modify | `lua/custom/agent_skills.lua` | Fix `matches_globs` — `globpath` always truthy |
| modify | `lua/custom/cc_budget.lua` | Add `M.setup()` call at bottom of file (self-bootstrapping) |
| modify | `lua/custom/plugins/aerial.lua` | Remove broken `sync_highlight` autocmd; remove redundant `gO` global keymap |
| modify | `lua/custom/plugins/lualine.lua` | Remove fragile `api.tokens` inline component; rely solely on `codecompanion-lualine` |
| modify | `lua/custom/plugins/codecompanion.lua` | Replace PT-BR "Estratégia N" comments with functional English comments |
| modify | `lua/custom/plugins/toggleterm.lua` | Create terminals lazily inside keymap functions with `dir = vim.fn.getcwd()` |

## Steps

### Phase 1 — Bugs (critical)
1. `gitsigns.lua`: change `gitsigns.stage_hunk` → `gitsigns.undo_stage_hunk` for `<leader>hu`
2. `agent_skills.lua`: rewrite `matches_globs` — remove outer `globpath` truthy check; match filepath directly against `glob2regpat` without the redundant fs check
3. `cc_budget.lua`: add `M.setup()` call at the end of the file so autocmds are always registered on require (self-bootstrapping, no external call needed)

### Phase 2 — Conflicts & Overhead
4. `aerial.lua`: delete the `CursorMoved` autocmd that calls `sync_highlight`
5. `aerial.lua`: delete the global `gO` keymap (already handled buffer-locally by `telescope-lsp-attach` in `init.lua`)

### Phase 3 — Redundancy & Fragility
6. `init.lua`: deduplicate `ensure_installed` list — remove the manually listed items that already come from the servers loop (`ruby-lsp`, `typescript-language-server`, `pyright`, `gopls`, `marksman`, `yaml-language-server`) and the duplicate `prettierd`
7. `init.lua`: remove the inline gitsigns signs config from the lazy spec (it's fully covered by `kickstart/plugins/gitsigns.lua`)
8. `lualine.lua`: remove the inline function component that reads `api.tokens`; keep only the `'codecompanion'` component from the dedicated plugin

### Phase 4 — Quality
9. `codecompanion.lua`: replace "Estratégia 5" / "Estratégia 6" comments with English equivalents describing intent
10. `toggleterm.lua`: move `Terminal:new()` calls inside keymap callbacks, passing `dir = vim.fn.getcwd()` so each toggle respects the active cwd

## Open Questions
- For item 3 (`cc_budget` self-bootstrap): **Option A** (self-bootstrap at bottom of `cc_budget.lua`) was chosen — simpler, no external call needed.

## Status
- [x] Approved
- [x] Phase 1 — Bugs (critical)
- [x] Phase 2 — Conflicts & Overhead
- [x] Phase 3 — Redundancy & Fragility
- [x] Phase 4 — Quality
- [x] Done
