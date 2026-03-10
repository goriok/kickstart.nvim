---
description: How to create, structure and maintain agent skills in this workspace. Apply when the user asks to create, edit, or organise a SKILL.md file.
globs: [".claude/skills/**/SKILL.md"]
---

# Creating Agent Skills

## What is a Skill

A skill is a `SKILL.md` file inside `.claude/skills/<skill-name>/` that teaches AI agents (Claude Code, Copilot, CodeCompanion) how to behave in a specific context. Skills are automatically loaded when the active file matches the declared globs.

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
- Each folder contains exactly one `SKILL.md`
- Folder name should reflect the skill's domain (e.g. `conventional-commits`, `neovim-plugin-dev`)

## SKILL.md Template

Every skill file must start with a YAML frontmatter block followed by Markdown content:

```markdown
---
description: <One-line summary of when this skill applies. Be specific — agents use this to decide relevance.>
globs: ["<glob-pattern-1>", "<glob-pattern-2>"]
---

# <Skill Title>

## <Section>

- Rule or guideline
- Another rule

## Examples

<Concrete examples that show correct usage>
```

## Frontmatter Rules

### `description` (required)

- One sentence, max ~150 chars
- Explain **when** the skill should activate, not just **what** it is
- Good: `"Rules for writing git commit messages using Conventional Commits."`
- Bad: `"Commit stuff"`

### `globs` (required)

- JSON array of glob patterns that determine when the skill is auto-loaded
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

## Checklist Before Committing

1. Frontmatter has both `description` and `globs`
2. `description` clearly states when the skill applies
3. `globs` patterns are tested (match intended files, don't over-match)
4. Content is actionable — an agent can follow it without extra context
5. Examples cover the common cases
6. No hardcoded paths — use `vim.fn.stdpath()` references if needed
7. Commit with: `docs: add <skill-name> agent skill`
