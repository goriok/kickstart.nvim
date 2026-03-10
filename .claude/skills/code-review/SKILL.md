---
description: Guidelines for performing code reviews on changed files. Apply when the user asks to "review", "code review", "revisar", "check my changes", or "what did I change".
globs: ["**/*"]
---

# Code Review

## When to Activate

Activate when the user:
- Asks to "review", "code review", "revisar o código", "check my changes"
- Asks "what did I change?" or "is this ready to commit/PR?"
- Requests feedback on staged or unstaged changes
- Asks to validate changes against project conventions

## Review Workflow

```
1. get_changed_files          →  obtain diff (staged + unstaged by default)
2. read_file                  →  read full context of each changed file
3. grep_search                →  check dependencies / callers if needed
4. Analyse by category        →  see Review Categories below
5. Report findings            →  use severity format below
6. Propose fixes inline       →  use insert_edit_into_file for blockers
7. get_diagnostics            →  run on every changed code file (skip `.md`, `.json`, `.yaml` and other non-code files)
```

If the user specifies scope (`staged` / `unstaged`), filter accordingly.
Always read the **full file**, not just the diff — context matters.

## Review Categories

Evaluate changes across these dimensions in order:

| # | Category | What to check |
|---|----------|---------------|
| 1 | **Correctness** | Logic errors, off-by-one, nil/null handling, wrong return values |
| 2 | **Guardrails** | Violations of `AGENTS.md` rules (see below) |
| 3 | **Security** | Hardcoded secrets, unsafe evals, exposed paths |
| 4 | **Style & Conventions** | Naming, indentation, `local` usage, self-contained configs |
| 5 | **Performance** | Unnecessary loops, blocking calls in hot paths |
| 6 | **Maintainability** | Magic numbers, missing comments on non-obvious logic |
| 7 | **Tests** | New behaviour without tests, broken existing tests |

## Severity Format

Report every finding with a severity label:

```
🔴 BLOCKER   — must fix before commit/merge (bug, guardrail violation, security)
🟡 WARNING   — should fix; degrades quality or breaks conventions
🟢 SUGGESTION — nice to have; optional improvement
ℹ️  INFO      — neutral observation, no action required
```

Group findings by file. After all findings, add a **Summary** line:

```
Summary: X blocker(s), Y warning(s), Z suggestion(s) — [ready to commit | needs fixes]
```

## Project Guardrails (from AGENTS.md)

Always verify these automatically:

- [ ] No plugin removed without checking it is not a dependency in `lua/custom/plugins/`
- [ ] `lazy-lock.json` not modified directly
- [ ] No hardcoded paths — must use `vim.fn.stdpath('data')` / `vim.fn.stdpath('config')`
- [ ] No push to remote triggered by the agent
- [ ] Commit message follows Conventional Commits format (no scope in parentheses)

## Lua / Neovim Specific Checks

- All variables declared with `local`
- Plugin configs are self-contained (no side effects on global state)
- Keymaps use `vim.keymap.set`, not the deprecated `vim.api.nvim_set_keymap` (unless necessary)
- LSP `on_attach` callbacks do not duplicate global keymaps
- No `print()` debug statements left in production code
- Autocommands are grouped inside a named `augroup` to prevent duplication

## Inline Fix Rules

- Propose fixes only for 🔴 BLOCKER and 🟡 WARNING findings
- Use `insert_edit_into_file` to apply fixes when the user confirms
- Never silently rewrite large blocks — show the diff and ask first for changes that affect logic, interfaces or public APIs
- Preserve the author's intent; do not refactor unrelated code

## Output Format

```
## Code Review — <branch or "working tree">

### `path/to/file.lua`
🔴 BLOCKER — <line or context>: <description>
   Fix: <one-line suggestion or inline edit>

🟡 WARNING — <line or context>: <description>

🟢 SUGGESTION — <description>

---

### `path/to/other.lua`
ℹ️  INFO — no issues found

---

**Summary**: 1 blocker, 1 warning, 1 suggestion — needs fixes
```

## Anti-patterns

- ❌ Reviewing only the diff without reading the full file context
- ❌ Proposing stylistic rewrites as blockers
- ❌ Skipping the guardrail checklist
- ❌ Applying fixes without user confirmation for WARNING or above on large changes
- ❌ Leaving the review without a Summary line
