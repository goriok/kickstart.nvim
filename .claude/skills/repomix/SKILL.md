---
name: repomix
description: Guidelines for generating a repomix XML output. Apply when the user asks to run repomix, generate a codebase context file, or export the project for AI consumption.
disable-model-invocation: true
---

# Repomix XML Output

## Goal

Generate a compressed, clean XML snapshot of the project using `repomix`, suitable for feeding into AI contexts.

## Workflow

1. **Check for `repomix.config.json`** in the current working directory (project root).
2. **If it does NOT exist** → detect the project language and create a sensible `repomix.config.json` before running.
3. **If it exists** → run repomix immediately with the standard flags.

## Running Repomix

Always run with:

```
repomix --compress --remove-empty-lines
```

Output file: `repomix-output.xml` (default, unless overridden in config).

## Detecting Project Language

Use the presence of key files to infer the primary language/stack:

| Indicator file(s)             | Stack         | Template                          |
|-------------------------------|---------------|-----------------------------------|
| `*.lua`, `init.lua`           | Lua / Neovim  | `templates/lua-neovim.json`       |
| `go.mod`                      | Go            | `templates/go.json`               |
| `package.json`                | JavaScript/TS | `templates/javascript-typescript.json` |
| `Gemfile`                     | Ruby          | `templates/ruby.json`             |
| `pyproject.toml`, `setup.py`  | Python        | `templates/python.json`           |
| (fallback)                    | Generic       | `templates/generic.json`          |

If multiple indicators exist, prefer the one with the most source files.

## Supporting Files

- Config templates per language are in [templates/](templates/) — copy the matching JSON as `repomix.config.json`

## Step-by-Step Procedure

1. Run `ls repomix.config.json 2>/dev/null` (or check via tool) to test existence.
2. If **missing**:
   a. Detect stack from indicator files.
   b. Copy the matching template from `templates/` to `repomix.config.json`.
   c. Inform the user which template was applied.
3. Run: `repomix --compress --remove-empty-lines`
4. Confirm the output file path to the user (default: `repomix-output.xml`).

## Rules

- Never overwrite an existing `repomix.config.json` without explicit user approval.
- Always add `repomix-output.xml` to `.gitignore` if not already present.
- Never include secrets or `.env` files — verify `useGitignore: true` is set.
- Prefer `style: "xml"` — it provides structured context for AI tools.
- Do not commit `repomix-output.xml` to version control.
