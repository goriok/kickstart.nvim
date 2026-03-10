---
description: Rules for writing git commit messages using Conventional Commits (without scope). Apply when creating commits, suggesting commit messages, or reviewing commit history.
globs: ["**/*"]
---

# Conventional Commits (No Scope)

## Format

```
<type>: <description>
```

- **No parenthesised scope** — always `type: description`, never `type(scope): description`
- Description starts with **lowercase** letter
- Description is a short imperative sentence (≤ 72 chars for the full first line)
- No period at the end

## Allowed Types

| Type       | When to use                                         |
|------------|-----------------------------------------------------|
| `feat`     | New feature or capability                           |
| `fix`      | Bug fix                                             |
| `chore`    | Maintenance, deps, tooling (no production code)     |
| `docs`     | Documentation only                                  |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `style`    | Formatting, whitespace, missing semicolons          |
| `perf`     | Performance improvement                             |
| `test`     | Adding or updating tests                            |
| `ci`       | CI/CD configuration                                 |
| `build`    | Build system or external dependency changes         |
| `revert`   | Reverts a previous commit                           |

## Examples

```
feat: add telescope live-grep keymap
fix: correct LSP attach autocmd for Go files
chore: update lazy-lock.json
docs: document MCP server setup in README
refactor: extract shared LSP on_attach function
style: fix trailing whitespace in init.lua
perf: lazy-load treesitter parsers
test: add spec for custom statusline module
ci: add luacheck to GitHub Actions
build: bump minimum Neovim version to 0.11
revert: undo telescope config change
```

## Multi-line Body (optional)

```
feat: add clipboard integration for SSH sessions

Use OSC52 escape sequence to enable clipboard copy
when running Neovim over SSH without X11 forwarding.
```

- Blank line between subject and body
- Body wraps at 72 characters
- Use body to explain **what** and **why**, not how

## Breaking Changes

Append `!` before the colon:

```
feat!: migrate keymaps to vim.keymap.set API
```

Or add a `BREAKING CHANGE:` footer in the body.

## Rules

1. **One commit per logical change** — don't mix unrelated changes
2. **Never use a scope in parentheses** — write `feat:` not `feat(telescope):`
3. **Never push to remote** without explicit user approval
4. **Stage only relevant files** before committing
5. When in doubt, prefer `chore` for non-user-facing changes
