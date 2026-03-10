---
name: explain-concept
description: Explains a programming or Neovim/Lua concept with code examples — preferring real examples from the current project — and generates a Markdown documentation file. Apply when the user asks to "explain", "what is", "how does X work", "document X", or "criar doc sobre".
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
globs: ["**/*"]
---

# Explain Concept

## When to Activate

Activate when the user:
- Asks to explain a concept, pattern or API (e.g. "explain lazy.nvim specs", "o que é autocmd?")
- Asks "how does X work?" or "what is X?"
- Requests documentation about a concept ("criar doc sobre", "document X", "gera um md explicando")
- Combines a concept with a real-world anchor ("explain how keymaps work in this config")

## Workflow

```
1. Understand the concept        →  identify the core idea to explain
2. grep_search / file_search     →  find real occurrences in the project (prefer project code over invented examples)
3. read_file                     →  read the relevant file sections for context
4. Compose the explanation       →  use the output template below
5. create_file                   →  write docs/<concept-name>.md (or path chosen by user)
6. Confirm                       →  report file path and offer follow-up
```

Always prefer **real code from the project** as examples. Only fall back to minimal synthetic examples when the concept is not present in the codebase.

## Output Template

Use [templates/concept-doc.md](templates/concept-doc.md) as the structure for the generated `.md` file.

## Rules

- Explanation must have: **What**, **Why**, **How** sections
- Every section must contain at least one code example
- Code blocks must use the correct language ID (`lua`, `vim`, `bash`, etc.)
- When pulling code from the project, include the **source file path** as a comment or caption above the block
- Keep the explanation concise — favour bullet points over long prose
- Use H2 (`##`) and H3 (`###`) headers only — never H1 inside the doc body (H1 is reserved for the doc title)
- Docs are saved to `docs/` by default unless the user specifies another path
- File name uses `kebab-case` matching the concept (e.g. `docs/lazy-loading.md`)

## Code Example Guidelines

| Priority | Source | When to use |
|----------|--------|-------------|
| 1 | Real file from project | Concept is present in `lua/`, `lua/custom/plugins/`, `lua/kickstart/` |
| 2 | Minimal adapted example | Real code is too complex/noisy to illustrate the concept clearly |
| 3 | Synthetic example | Concept is not present in the project at all |

Always annotate the source:
- Real project code → `-- source: lua/custom/plugins/foo.lua`
- Adapted/synthetic → `-- example (synthetic)`

## Doc File Conventions

- Save to `docs/<kebab-case-concept>.md` unless user specifies otherwise
- Start with a YAML-style comment block:
  ```
  <!-- concept: <name> | created: <date> | source: explain-concept skill -->
  ```
- Title (`# `) matches the concept name in Title Case
- Sections: **Overview**, **Why it matters**, **How it works**, **Examples**, **Common Patterns**, **References** (optional)
- References section links to Neovim docs, plugin README, or relevant source files

## Anti-patterns

- ❌ Explaining without any code examples
- ❌ Using invented examples when real project code is available
- ❌ Saving the doc outside `docs/` without user confirmation
- ❌ Using H1 for internal sections — H1 is title only
- ❌ Writing long paragraphs instead of bullets + code
- ❌ Skipping the source annotation on code blocks
