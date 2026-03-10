---
description: Guidelines for generating a repomix XML output. Apply when the user asks to run repomix, generate a codebase context file, or export the project for AI consumption.
globs: ["**/*"]
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

| Indicator file(s)             | Stack         |
|-------------------------------|---------------|
| `*.lua`, `init.lua`           | Lua / Neovim  |
| `go.mod`                      | Go            |
| `package.json`                | JavaScript/TS |
| `Gemfile`                     | Ruby          |
| `pyproject.toml`, `setup.py`  | Python        |
| `Cargo.toml`                  | Rust          |
| `pom.xml`, `build.gradle`     | Java          |

If multiple indicators exist, prefer the one with the most source files.

## Default `repomix.config.json` Templates

### Lua / Neovim

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      "lazy-lock.json",
      ".git/**"
    ]
  }
}
```

### Go

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      "vendor/**",
      "*.sum",
      ".git/**"
    ]
  }
}
```

### JavaScript / TypeScript

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      "node_modules/**",
      "dist/**",
      "build/**",
      ".git/**"
    ]
  }
}
```

### Ruby

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      "vendor/bundle/**",
      "tmp/**",
      "log/**",
      ".git/**"
    ]
  }
}
```

### Python

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      "__pycache__/**",
      "*.pyc",
      ".venv/**",
      "dist/**",
      ".git/**"
    ]
  }
}
```

### Generic (fallback)

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "compress": true,
    "removeEmptyLines": true
  },
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "repomix-output.xml",
      ".git/**"
    ]
  }
}
```

## Step-by-Step Procedure

1. Run `ls repomix.config.json 2>/dev/null` (or check via tool) to test existence.
2. If **missing**:
   a. Detect stack from indicator files.
   b. Write the matching template above to `repomix.config.json`.
   c. Inform the user which template was applied.
3. Run: `repomix --compress --remove-empty-lines`
4. Confirm the output file path to the user (default: `repomix-output.xml`).

## Rules

- Never overwrite an existing `repomix.config.json` without explicit user approval.
- Always add `repomix-output.xml` to `.gitignore` if not already present.
- Never include secrets or `.env` files — verify `useGitignore: true` is set.
- Prefer `style: "xml"` — it provides structured context for AI tools.
- Do not commit `repomix-output.xml` to version control.
