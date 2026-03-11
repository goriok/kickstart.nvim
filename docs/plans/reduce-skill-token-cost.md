# Plan: Reduce agent skill token cost per chat

> Created: 2026-03-10

## Goal
Reduzir o consumo recorrente de tokens por chat causado por skills auto-injetadas com glob `**/*`, sem perder qualidade de contexto nas interações.

## Affected Files

| Action | File | Reason |
|--------|------|--------|
| modify | `.claude/skills/conventional-commits/SKILL.md` | Adicionar `disable-model-invocation: true` (Opção C) |
| modify | `.claude/skills/repomix-reader/SKILL.md` | Adicionar `disable-model-invocation: true` (Opção C) |
| modify | `.claude/skills/tdd/SKILL.md` | Remover glob `**/*` e/ou comprimir corpo + templates (Opções A + D) |
| modify | `.claude/skills/bug-fix/SKILL.md` | Avaliar remoção do glob `**/*` (Opção A) — depende de decisão |

## Options

### Opção A — Converter `**/*` para globs específicos
Mudar skills que usam `**/*` para padrões mais restritos ou sem glob.

### Opção C — `disable-model-invocation: true` nas skills on-demand
`conventional-commits` e `repomix-reader` viram invisíveis ao modelo.

### Opção D — Comprimir corpos das skills
Reescrever skills verbosas, remover templates embutidos do `tdd`.

### Opção E — TDD com `argument-hint` por linguagem
`/skill tdd lua` carrega só o template Lua, evitando os outros 2.

## Recommended Combination
1. Opção C → `conventional-commits` + `repomix-reader` com `disable-model-invocation: true`
2. Opção A → `tdd` sem glob (manual via `/skill tdd`)
3. Opção D → comprimir `tdd`: remover templates do corpo

Economia estimada: ~2.000–2.500 tokens por chat (~65% do custo recorrente atual).

## Steps
1. Editar frontmatter de `conventional-commits/SKILL.md` — adicionar `disable-model-invocation: true`
2. Editar frontmatter de `repomix-reader/SKILL.md` — adicionar `disable-model-invocation: true`
3. Editar frontmatter de `tdd/SKILL.md` — remover `globs: ["**/*"]`
4. (Opcional) Comprimir corpo do `tdd/SKILL.md` — remover templates inline, manter só referência
5. Decidir sobre `bug-fix` — manter auto-load ou converter para manual

## Open Questions
- `bug-fix` deve continuar auto-carregando ou vira manual?
- Templates do `tdd` (Go/Lua/Python) têm valor quando injetados automaticamente?
- Aceita Opção E (skill com argumento de linguagem) para o `tdd`?

## Status
- [ ] Approved
- [ ] In progress
- [ ] Done
