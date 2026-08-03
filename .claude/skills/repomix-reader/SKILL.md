---
name: repomix-reader
description: Guidelines for reading and consuming a repomix XML file as the primary context source. Apply when the user explicitly references a repomix file by name or uses phrases like "leia o repomix", "use o repomix como contexto", "baseado no repomix", "read the repomix", "use repomix as context".
tool: claude-only
---

# Repomix Reader

## When to Activate

Activate **only** when the user explicitly signals intent to use a repomix file as context:

| Signal type | Examples |
|-------------|---------|
| Reference by filename | `repomix-output.xml`, `meu-projeto.xml`, any `*.xml` described as a repomix |
| Explicit read request | "leia o repomix", "read the repomix", "use the repomix" |
| Explicit context signal | "use o repomix como contexto", "baseado no repomix", "based on the repomix" |
| Combined with other tasks | "leia o repomix e entre em plan mode", "read the repomix and plan X" |

Do **not** activate just because a repomix file exists in the workspace.

## Behaviour When Active

1. **Read the repomix file first** — use `read_file` on the provided path before doing anything else
2. **Treat the repomix as the single source of truth** for all file structure, code content and references
3. **Suppress code search tools** — do not call `grep_search`, `file_search`, or `read_file` on individual source files while the repomix covers the scope of the request
4. **If the repomix does not cover something** — explicitly tell the user instead of silently falling back to code search

## Integration with Plan Mode

When the user combines a repomix read with a plan request (e.g. "leia o repomix e faça um plano"):

1. Read the repomix file first
2. Use its contents to populate the **Affected Files** table and steps in the plan
3. Do not use `grep_search` or `file_search` to gather context — the repomix already contains it
4. If information needed for the plan is absent from the repomix, flag it as an **Open Question**

## Rules

- Never activate based on file existence alone — activation requires explicit user intent
- Never use code search tools when the repomix covers the requested scope
- If the repomix file path is ambiguous, ask the user to confirm the exact filename before reading
- Treat the repomix as a snapshot — if the user mentions recent changes not reflected in it, note that the repomix may be stale
- Never generate or overwrite a repomix file under this skill — that is handled by the `repomix` skill

## Examples

**Correct activation:**
> "leia o repomix-output.xml e entre em plan mode para adicionar suporte a Ruby"
→ Read `repomix-output.xml` → build plan from its contents → no `grep_search` calls

**Correct activation:**
> "based on the repomix, what plugins are configured?"
→ Read the repomix → answer from its contents only

**Incorrect activation (do NOT activate):**
> "run repomix and generate the output"
→ This is a generation request — use the `repomix` skill instead

**Incorrect activation (do NOT activate):**
> "what does my init.lua do?"
→ No explicit repomix reference — use normal file reading tools
