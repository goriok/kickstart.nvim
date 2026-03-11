<!-- concept: skill-glob-matching | created: 2026-03-10 | source: explain-concept skill -->

# Skill Glob Matching

> Como o sistema decide automaticamente quais skills carregar com base nos arquivos abertos.

---

## Overview

O que é **glob matching de skills**?

- É o mecanismo de **auto-seleção de Level 2** — decide se o corpo completo de uma skill deve ser injetado no chat
- Funciona comparando o campo `globs` do frontmatter da skill com os **caminhos dos buffers abertos**
- Se não houver match, apenas o **Level 1 (index)** é injetado (~20 tokens por skill)
- É o equivalente ao comportamento nativo do Claude Code CLI com `globs` no frontmatter

---

## Why It Matters

- Sem glob matching, **todas** as skills seriam injetadas completas em todo chat → custo de tokens explosivo
- Com glob matching, o corpo completo só entra quando é **contextualmente relevante**
- Permite ter muitas skills sem penalizar chats que não precisam delas

---

### How It Works

O sistema usa **dois eventos** para injeção em fases distintas:

1. **`CodeCompanionChatCreated`** → `inject_matching_skills()` — injeta apenas o **Level 1 (index)**; não injeta corpos
2. **`SubmitBefore`** → `inject_skills_for_message()` — injeta os **corpos (Level 2)** das skills relevantes para a mensagem prestes a ser enviada

Dentro de `inject_matching_skills()`:
- Coleta os caminhos dos buffers do chat + buffer atual
- Para cada skill, verifica `disable_model_invocation` e chama `is_skill_relevant()`
- Injeta apenas o índice; corpos são carregados lazily no passo 2

### Fluxo de decisão (dois estágios)

```
[ChatCreated]
inject_matching_skills(chat)
  │
  └─ build_index(skills) → injeta Level 1 (index only)
       └─ skills com disable_model_invocation=true são excluídas do index

[SubmitBefore]
inject_skills_for_message(chat, message)
  │
  ├─ para cada skill:
  │    ├─ disable_model_invocation? → skip
  │    └─ is_skill_relevant(skill, { message = message })?
  │         └─ SIM → adiciona em relevant[]
  │
  └─ build_skill_content(relevant) → injeta Level 2 (bodies)
       └─ dedup: skip se conteúdo idêntico já presente
```

### Key API — `matches_globs`

```lua
-- source: lua/custom/agent_skills.lua
local function matches_globs(filepath, globs)
  if #globs == 0 then
    return false
  end
  for _, glob in ipairs(globs) do
    if vim.fn.globpath('.', glob, false, true) then
      local pattern = vim.fn.glob2regpat(glob)
      if vim.fn.match(filepath, pattern) >= 0 then
        return true
      end
    end
  end
  return false
end
```

### Key API — `is_skill_relevant`

```lua
-- source: lua/custom/agent_skills.lua
local function is_skill_relevant(skill, ctx)
  -- 1. Glob match contra buffers abertos
  if #skill.globs > 0 and ctx.buffers then
    for _, buf_path in ipairs(ctx.buffers) do
      if matches_globs(buf_path, skill.globs) then
        return true
      end
    end
  end

  -- 2. Nome da skill mencionado na mensagem do usuário
  if ctx.message then
    local lower_msg = ctx.message:lower()
    local lower_name = skill.name:lower():gsub('%-', ' ')
    if lower_msg:find(lower_name, 1, true) or lower_msg:find(skill.name:lower(), 1, true) then
      return true
    end
  end

  return false
end
```

---

## Examples

### Example 1 — Skill que carrega apenas em arquivos Go

```yaml
# source: frontmatter de uma SKILL.md
---
name: go-patterns
description: Go idioms and best practices
globs: ["**/*.go", "go.mod"]
---
```

**O que faz:** A skill só é injetada (Level 2) quando o buffer atual ou um arquivo no chat é `*.go` ou `go.mod`.

---

### Example 2 — Skill sem globs (nunca auto-carrega)

```yaml
---
name: plan-mode
description: Architectural planning before implementation
# sem campo globs
---
```

**O que faz:** Nunca é auto-carregada por glob. Aparece apenas no index (Level 1). O usuário precisa usar `/skill plan-mode` para injetar o corpo.

---

### Example 3 — Segundo critério: nome na mensagem

```lua
-- source: lua/custom/agent_skills.lua (is_skill_relevant)
if ctx.message then
  local lower_msg = ctx.message:lower()
  local lower_name = skill.name:lower():gsub('%-', ' ')
  -- "conventional commits" matcheia a skill "conventional-commits"
  if lower_msg:find(lower_name, 1, true) then
    return true
  end
end
```

**O que faz:** Se o usuário digitar "use conventional commits", a skill `conventional-commits` é promovida a Level 2 mesmo sem glob match.

---

## Common Patterns

| Pattern | Descrição |
|---------|-----------|
| `["**/*.go"]` | Qualquer arquivo Go em qualquer subdiretório |
| `["*.lua", "lua/**"]` | Arquivos Lua na raiz ou dentro de `lua/` |
| `["*.tsx", "src/components/**"]` | Componentes React em projeto TypeScript |
| Sem `globs` | Skill manual — só via `/skill` |
| `disable-model-invocation: true` | Skill oculta do index; só o usuário pode invocar |

---

## Gotchas & Tips

- ⚠️ `matches_globs` usa `vim.fn.glob2regpat` + `vim.fn.match` — é matching de **padrão Vim**, não POSIX glob puro. Padrões como `**` são suportados, mas comportamentos edge podem diferir de `.gitignore`
- ⚠️ Se `globs` está vazio, a skill **nunca** é auto-carregada (retorna `false` imediatamente) — isso é intencional para skills manuais
- ⚠️ O segundo critério (nome na mensagem) só se aplica quando `inject_skills()` é chamado com `ctx.message` — o fluxo de `inject_matching_skills()` (autocmd) **não passa mensagem**, então esse critério fica inativo na abertura do chat
- 💡 Para uma skill que deve carregar em qualquer projeto Lua/Neovim: `globs: ["**/*.lua"]`
- 💡 Skills com `disable-model-invocation: true` são excluídas do index — o modelo nem sabe que existem (note: no YAML use hífen `disable-model-invocation`; internamente o Lua acessa `skill.disable_model_invocation`)

---

## References

- [Neovim docs: glob2regpat](https://neovim.io/doc/user/builtin.html#glob2regpat())
- [Neovim docs: globpath](https://neovim.io/doc/user/builtin.html#globpath())
- Source files nesta config: `lua/custom/agent_skills.lua`, `lua/custom/slash_commands/skill.lua`
- Frontmatter completo: `docs/SKILL_FRONTMATTER.md`
