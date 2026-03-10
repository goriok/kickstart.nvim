---
description: Guidelines for entering plan mode in codecompanion chat or agent sessions. Apply when the user asks to plan, design, architect, or structure a feature before implementation.
globs: ["**/*"]
---

# Plan Mode

## When to Activate

Enter plan mode automatically when the user's message contains intent signals such as:

- "plan", "planning", "plan this", "let's plan"
- "design", "architect", "architecture"
- "how would you approach", "how should I structure"
- "before we start", "think through"
- "propose a solution", "outline the steps"

Do **not** enter plan mode for simple factual questions, quick fixes, or single-line changes.

## Plan Mode Behaviour

1. **Do not write or edit any files** during plan mode — only analyse and propose
2. **Do not run commands** that mutate state
3. State explicitly at the top: `📋 **Plan Mode** — no files will be changed until you approve.`
4. End every plan with: `✅ Ready to implement. Reply "go" or describe any changes to the plan.`

## Required Plan Structure

Always produce a plan in this order:

### 1. Goal
One sentence summarising what will be built or changed.

### 2. Affected Files
A table listing every file that will be created, modified, or deleted:

| Action   | File path                          | Reason                        |
|----------|------------------------------------|-------------------------------|
| create   | `lua/custom/plugins/foo.lua`       | new plugin config             |
| modify   | `lua/custom/plugins/bar.lua`       | add keymap for new feature    |
| delete   | `lua/kickstart/plugins/old.lua`    | replaced by custom version    |

### 3. Pseudocode / Steps
Numbered list of implementation steps. For non-trivial logic, include pseudocode:

```
1. Add plugin spec to lazy.nvim (plugin name, dependencies)
2. Define opts table:
   - option_a = true
   - option_b = { key = "value" }
3. Register keymap: <leader>X → :PluginCommand<CR>
4. Update README.md — keymaps section
```

### 4. Open Questions (optional)
List any ambiguities or decisions the user should resolve before implementation begins.

## Rules

- Never skip the Affected Files table — it prevents accidental changes
- Keep pseudocode language-agnostic and concise; avoid real Lua code in plan phase
- If the plan spans more than 5 files, split it into phases (Phase 1, Phase 2…)
- Respect project guardrails from `AGENTS.md`: never plan to remove a plugin without checking dependencies

## Example

User: "plan adding a git blame inline plugin"

Response:

> 📋 **Plan Mode** — no files will be changed until you approve.
>
> ### Goal
> Add `gitsigns.nvim` inline blame display, showing author + date on the current line.
>
> ### Affected Files
> | Action | File | Reason |
> |--------|------|--------|
> | modify | `lua/custom/plugins/gitsigns.lua` | enable `current_line_blame` option |
> | modify | `README.md` | document new keymap `<leader>gb` |
>
> ### Steps
> ```
> 1. Open lua/custom/plugins/gitsigns.lua
> 2. In opts, set current_line_blame = true
> 3. Add keymap <leader>gb → toggle_current_line_blame
> 4. Update README keymaps table
> ```
>
> ✅ Ready to implement. Reply "go" or describe any changes to the plan.
