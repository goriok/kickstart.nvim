---
name: creating-skills
description: How to create, structure and maintain agent skills in this workspace. Apply when the user asks to create, edit, or organise a SKILL.md file.
user-invocable: false
globs: [".claude/skills/**/SKILL.md"]
---

# Creating Agent Skills

## What is a Skill

A skill is a `SKILL.md` file inside `.claude/skills/<skill-name>/` that teaches AI agents (Claude Code, Copilot, CodeCompanion) how to behave in a specific context. Skills follow the [Agent Skills](https://agentskills.io/) open standard.

## Directory Layout

```
.claude/skills/
├── conventional-commits/
│   └── SKILL.md
├── neovim-plugin-dev/
│   └── SKILL.md
└── creating-skills/
    └── SKILL.md
```

- **One folder per skill**, named with `kebab-case`
- Each folder contains exactly one `SKILL.md` (required entrypoint)
- Optional supporting files: templates, examples, scripts
- Folder name should reflect the skill's domain (e.g. `conventional-commits`, `neovim-plugin-dev`)

### Supporting Files (optional)

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── template.md        # Template for the agent to fill in
├── examples/
│   └── sample.md      # Example output showing expected format
└── scripts/
│   └── validate.sh    # Script the agent can execute
```

Reference supporting files from `SKILL.md` so the agent knows what they contain and when to load them.

## SKILL.md Template

Every skill file must start with a YAML frontmatter block followed by Markdown content:

```markdown
---
name: my-skill
description: <One-line summary of when this skill applies. Be specific.>
globs: ["<glob-pattern-1>", "<glob-pattern-2>"]
---

# <Skill Title>

## <Section>

- Rule or guideline
- Another rule

## Examples

<Concrete examples that show correct usage>
```

## Frontmatter Reference

All fields are optional. Only `description` is strongly recommended.

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name for the skill. If omitted, uses the directory name. Lowercase letters, numbers, and hyphens only (max 64 chars). |
| `description` | Recommended | What the skill does and when to use it. Agents use this to decide relevance. |
| `globs` | No | JSON array of glob patterns that determine when the skill is auto-loaded based on open files. Use `["**/*"]` for global skills. |
| `disable-model-invocation` | No | `true` = only the user can invoke this skill (e.g. deploy, review, plan). Default: `false`. |
| `user-invocable` | No | `false` = only the agent can invoke this skill (background knowledge). Default: `true`. |
| `allowed-tools` | No | Tools the agent can use without confirmation when this skill is active (e.g. `Read, Grep, Glob`). |
| `argument-hint` | No | Hint shown during autocomplete (e.g. `[issue-number]`, `[filename] [format]`). |

### When to use each invocation control

| Frontmatter | User invokes | Agent invokes | Use case |
|-------------|-------------|--------------|----------|
| (default) | ✅ | ✅ | General knowledge (conventions, patterns) |
| `disable-model-invocation: true` | ✅ | ❌ | Actions with side effects (deploy, review, plan) |
| `user-invocable: false` | ❌ | ✅ | Background knowledge (legacy system context) |

### `description`

- One sentence, max ~150 chars
- Explain **when** the skill should activate, not just **what** it is
- Good: `"Rules for writing git commit messages using Conventional Commits."`
- Bad: `"Commit stuff"`

### `globs`

- JSON array of glob patterns for auto-loading by file context
- Use `["**/*"]` for skills that apply globally (e.g. commit conventions)
- Use specific patterns to scope the skill (e.g. `["lua/custom/plugins/*.lua"]`)
- Multiple patterns are OR-matched — any match triggers the skill

| Scope | Example glob |
|-------|-------------|
| Global (always active) | `["**/*"]` |
| Lua plugin configs | `["lua/custom/plugins/*.lua"]` |
| Markdown docs | `["**/*.md"]` |
| CI pipelines | `[".github/workflows/*.yml"]` |
| Skills themselves | `[".claude/skills/**/SKILL.md"]` |

## Content Guidelines

### Structure

1. **Title** (`# Heading`) — matches the skill domain
2. **Core rules/patterns** — short, scannable bullet points or tables
3. **Examples** — concrete, copy-pasteable snippets showing correct usage
4. **Anti-patterns** (optional) — show what to avoid with brief explanation

### Writing Style

- Be **prescriptive**, not descriptive — tell the agent what to do
- Use **imperative mood**: "Use X", "Never do Y", "Prefer Z"
- Keep rules **atomic** — one idea per bullet
- Use tables for enumerations (e.g. allowed types, keymap conventions)
- Use fenced code blocks with language IDs for examples
- Keep total length under ~120 lines — agents work better with focused context

### What NOT to Include

- Long prose explanations — keep it terse
- Implementation details that change frequently
- Duplicated info already in `AGENTS.md` — reference it instead
- Secrets, tokens, or environment-specific paths

## Arguments (optional)

Skills can receive arguments via `$ARGUMENTS` placeholder:

```markdown
---
name: fix-issue
description: Fix a GitHub issue by number
disable-model-invocation: true
argument-hint: [issue-number]
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

Access individual arguments: `$ARGUMENTS[0]` or shorthand `$0`, `$1`, `$2`.
> **Note:** indexed access (`$0`, `$1`) may not be supported by all runtimes — confirm support before relying on it. `$ARGUMENTS` (full string) is universally supported.

## Additional Resources

- For a blank skill template, see [templates/skill-template.md](templates/skill-template.md)
- For a fully worked example with all features, see [examples/full-skill.md](examples/full-skill.md)

## Checklist Before Committing

1. Frontmatter has `description` (and `name` if different from folder)
2. `description` clearly states when the skill applies
3. `globs` patterns match intended files without over-matching
4. Invocation control set correctly (`disable-model-invocation` / `user-invocable`)
5. Content is actionable — an agent can follow it without extra context
6. Examples cover the common cases
7. No hardcoded paths — use `vim.fn.stdpath()` references if needed
8. Commit with: `feat: add <skill-name> agent skill`
