---
name: plan-mode
description: Guidelines for entering plan mode in codecompanion chat or agent sessions. Apply when the user asks to plan, design, architect, or structure a feature before implementation.
disable-model-invocation: true
tool: claude-only
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
4. **Generate a plan file** — save the plan as a `.md` file (see [Plan File](#plan-file) section)
5. End every plan with: `✅ Plan saved to <path>. Reply "execute" or describe any changes.`

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

## Plan File

### Location

Save the plan file to `docs/plans/` relative to the project root:

```
docs/plans/<slug>.md
```

- `<slug>` is a `kebab-case` summary of the goal (max 5 words), e.g. `add-git-blame-inline.md`
- Always create the `docs/plans/` directory if it does not exist
- Never overwrite an existing plan file — append a numeric suffix: `add-git-blame-inline-2.md`

### Plan File Content

Use the template in [template.md](template.md) as the base structure.
The file must mirror the chat response exactly.

- `Status` checkboxes allow the user to track progress after approval
- Add `docs/plans/` to `.gitignore` only if the user explicitly requests it; otherwise commit the file

## Todo List

When the `todowrite` tool is available (e.g. running inside OpenCode), use it to
register every implementation step as a todo item **after** presenting the plan to
the user and receiving approval to execute.

### Behaviour

- Call `todowrite` once — pass all steps as individual items with status `pending`
- As execution proceeds, update each item: `pending` → `in_progress` → `completed`
- Only one item should be `in_progress` at a time
- Do **not** call `todowrite` during plan mode itself — only after the user approves

### When unavailable

If `todowrite` is not available (e.g. running in a plain chat window), skip this
section entirely. The plan file in `docs/plans/` serves as the paper trail instead.

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
> ✅ Plan saved to `docs/plans/add-git-blame-inline.md`. Reply "execute" or describe any changes.
