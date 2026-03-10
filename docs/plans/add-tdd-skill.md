# Plan: Add TDD Agent Skill

> Created: 2026-03-10

## Goal
Create an agent skill that teaches the AI to follow the Red → Green → Refactor TDD cycle when implementing features or fixing bugs.

## Affected Files
| Action | File | Reason |
|--------|------|--------|
| create | `.claude/skills/tdd/SKILL.md` | New TDD skill |
| modify | `AGENTS.md` | Document the new skill (if applicable) |

## Steps
1. Create `.claude/skills/tdd/SKILL.md` with:
   - Frontmatter: description focused on TDD intent, globs: `["**/*"]`
   - "When to Activate" — user intent signals
   - "The TDD Cycle" — Red → Green → Refactor rules
   - "Workflow" — tool usage per step
   - "Rules" — atomic rules table
   - "Test File Conventions" — where to create tests per language
   - "Examples" — concrete TDD cycle example
   - "Anti-patterns" — what to avoid
2. Validate it follows the creating-skills template
3. Keep under ~120 lines

## Open Questions
- Cover all stack languages with per-language test conventions, or keep generic?
- Integrate with bug-fix skill (write failing test before fixing), or keep independent?

## Status
- [x] Approved
- [x] In progress
- [x] Done
