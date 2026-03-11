# Plan: CodeCompanion lazy skill loading — approximating Claude Code

> Created: 2026-03-10

## Goal
Fazer o CodeCompanion adotar carregamento lazy de skills (corpo sob demanda), espelhando o comportamento nativo do Claude Code, sem alterar nenhum `SKILL.md` nem afetar o Claude Code CLI.

## Affected Files

| Action | File | Reason |
|--------|------|--------|
| modify | `lua/custom/agent_skills.lua` | Estratégias 3, 5, 6 — TTL, inject por mensagem, dedup |
| modify | `lua/custom/plugins/codecompanion.lua` | Estratégias 1, 2, 5 — hooking no SubmitBefore |
| create | `lua/custom/tools/load_skill.lua` | Estratégia 2 — Skill tool nativo |
| modify | `.claude/skills/*/SKILL.md` | Estratégia 4 — separar resumo do corpo |

## Strategies

### Estratégia 1 — Lazy body via SubmitBefore hook
Interceptar o submit antes de cada envio; injetar corpo só das skills relevantes para aquela mensagem; remover após resposta.

### Estratégia 2 — Skill tool nativo no CodeCompanion
Registrar skills como tools no tool_registry. Modelo chama `load_skill("name")` quando precisa — corpo injetado como tool result.

### Estratégia 3 — TTL nas mensagens de skill
Marcar mensagens com `ttl = N turnos`. Antes de cada submit, remover mensagens expiradas.

### Estratégia 4 — Separar index do corpo nos SKILL.md
SKILL.md = resumo curto. Corpo completo em `full.md` (supporting file). Modelo usa `read_file` quando precisa.

### Estratégia 5 — Remover `**/*` + inject por mensagem no SubmitBefore
Remover glob das skills comportamentais. Passar mensagem do usuário para `inject_skills()` no SubmitBefore.

### Estratégia 6 — Dedup de injeção idêntica
Guard em `inject_matching_skills`: não injetar se conteúdo idêntico já está em `chat.messages`.

## Recommended Phases

### Fase 1 — Quick wins (~65% economia, baixa complexidade)
1. Estratégia 5: remover `globs: ["**/*"]` de `tdd`, `conventional-commits`, `repomix-reader`
2. ~~Estratégia 5: passar mensagem do usuário para `inject_skills()` no `SubmitBefore`~~ ✅ **Implementado** (`inject_skills_for_message` + hook `SubmitBefore` em `codecompanion.lua`)
3. ~~Estratégia 6: guard de dedup em `inject_matching_skills`~~ ✅ **Implementado** (`already_injected` em `agent_skills.lua`)

### Fase 2 — Lazy load real (média complexidade)
4. Estratégia 1 ou 2: lazy load por turno ou via Skill tool nativo

## Open Questions
- Priorizar Fase 1 (quick wins) ou ir direto para Estratégia 2 (tool nativo)?
- ~~O autocmd `SubmitBefore` está disponível na versão atual do codecompanion?~~ ✅ Confirmado — hook activo e funcional.
- Aceita remover `globs: ["**/*"]` das skills comportamentais?

## Status
- [ ] Approved
- [x] In progress (Fase 1 parcialmente concluída — Estratégias 5 e 6 implementadas)
- [ ] Done
