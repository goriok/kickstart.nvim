# Agent Skills — Contextos de Uso

Este documento descreve como as **Agent Skills** funcionam nos três contextos de IA disponíveis nesta configuração, onde os arquivos `.claude/skills/` vivem e qual mecanismo os processa em cada caso.

---

## Visão Geral

```
.claude/skills/          ← Skills nativas (Claude Code CLI)
lua/custom/agent_skills.lua  ← Sistema de skills para codecompanion
```

Os dois sistemas compartilham o mesmo diretório `.claude/skills/` e o mesmo formato de `SKILL.md`, mas são processados por mecanismos diferentes dependendo do contexto.

---

## Contexto 1 — `claudecode.nvim` (`<leader>Cc`)

**Plugin:** `coder/claudecode.nvim`  
**Mecanismo:** Claude Code CLI nativo

### Como funciona

O `claudecode.nvim` inicia o binário `claude` como um processo de terminal dentro do Neovim. O CLI roda no `cwd` do projeto e lê o diretório `.claude/skills/` **nativamente**, com sua própria lógica de carregamento de skills.

```
Neovim
  └─ claudecode.nvim
       └─ claude CLI (processo nativo)
            ├─ lê .claude/skills/  ← automático
            └─ Claude API
```

### Características

- As skills são processadas pelo próprio Claude Code, **antes** de qualquer chamada à API
- Suporte completo ao frontmatter nativo do Claude Code (incluindo campos como `allowed-tools`)
- O contexto do editor (arquivos abertos, seleções) é enviado via MCP/WebSocket pelo plugin
- O arquivo `AGENTS.md` na raiz do projeto também é lido automaticamente como contexto global

### O que está disponível

Todas as skills em `.claude/skills/` são carregadas nativamente. Não há nenhuma configuração extra necessária no Neovim.

---

## Contexto 2 — `codecompanion.nvim` com copilot / gemini / ollama (`<leader>ac`)

**Plugin:** `olimorris/codecompanion.nvim`  
**Adapters:** `copilot`, `gemini`, `ollama`  
**Mecanismo:** `lua/custom/agent_skills.lua`

### Como funciona

Esses adapters se conectam diretamente à API dos provedores — nenhum binário `claude` está envolvido. O sistema de skills é emulado pelo módulo Lua `agent_skills.lua`, que injeta o conteúdo dos `SKILL.md` como mensagens de sistema no chat.

```
Neovim
  └─ codecompanion.nvim
       ├─ autocmd CodeCompanionChatCreated
       │    └─ agent_skills.inject_matching_skills(chat)
       │         ├─ Level 1: índice leve → system prompt (sempre)
       │         └─ Level 2: body completo → skills relevantes por glob/nome
       └─ Copilot / Gemini / Ollama API
```

### Características

- A injeção acontece no evento `CodeCompanionChatCreated`
- **Level 1:** um índice leve (~20 tokens por skill) é sempre incluído no system prompt, listando todas as skills disponíveis (exceto as com `disable-model-invocation: true`)
- **Level 2:** o body completo da `SKILL.md` é injetado apenas para skills cujos `globs` batem com buffers abertos, ou cujo nome aparece na mensagem do usuário
- Arquivos de suporte (templates, scripts) dentro do diretório da skill também são injetados automaticamente
- Quando o adapter é trocado para `ollama`, as skills (e o system prompt) são removidos do chat
- Skills podem ser invocadas manualmente com `/skill <nome>` no chat

### Frontmatter respeitado

| Campo | Suportado |
|---|---|
| `name` | ✅ |
| `description` | ✅ |
| `globs` | ✅ |
| `disable-model-invocation` | ✅ |
| `user-invocable` | ✅ |
| `allowed-tools` | ⚠️ lido, mas não enforçado pelo codecompanion |
| `argument-hint` | ✅ (autocomplete no `/skill`) |
| `$ARGUMENTS` / `${CLAUDE_SKILL_DIR}` | ✅ |

---

## Contexto 3 — `codecompanion.nvim` com adapter `claude_code` ACP

**Plugin:** `olimorris/codecompanion.nvim`  
**Adapter:** `claude_code` (ACP)  
**Mecanismo:** Ambos — CLI nativo + `agent_skills.lua`

### Como funciona

O adapter `claude_code` ACP é um wrapper que delega para o binário `claude` via protocolo ACP (Agent Communication Protocol). O binário `claude` roda localmente e lê `.claude/skills/` por conta própria, mas o codecompanion **também** injeta o system prompt via `agent_skills.lua`, pois o evento `CodeCompanionChatCreated` não distingue o adapter.

```
Neovim
  └─ codecompanion.nvim
       ├─ autocmd CodeCompanionChatCreated
       │    └─ agent_skills.inject_matching_skills(chat)  ← injetado
       └─ claude_code ACP adapter
            └─ claude CLI (processo local)
                 ├─ lê .claude/skills/  ← também lido nativamente
                 └─ Claude API
```

### Implicação: dupla injeção

Com este adapter, as skills podem ser processadas **duas vezes**:

1. **Pelo CLI nativo** — lê `.claude/skills/` como no Contexto 1
2. **Pelo `agent_skills.lua`** — injeta o mesmo conteúdo no system prompt via codecompanion

Na prática, isso significa que o modelo recebe o contexto das skills duplicado, o que aumenta o uso de tokens sem benefício adicional.

### Mitigação sugerida

Para evitar a dupla injeção, a guarda já existe parcialmente na config:

```lua
-- codecompanion.lua — CodeCompanionChatCreated
if chat.adapter and chat.adapter.name ~= 'ollama' then
  require('custom.agent_skills').inject_matching_skills(chat)
end
```

Basta adicionar `claude_code` à condição de exclusão:

```lua
local skip_adapters = { ollama = true, claude_code = true }
if chat.adapter and not skip_adapters[chat.adapter.name] then
  require('custom.agent_skills').inject_matching_skills(chat)
end
```

---

## Tabela Comparativa

| | claudecode.nvim | codecompanion + copilot/gemini/ollama | codecompanion + claude_code ACP |
|---|:---:|:---:|:---:|
| Skills lidas por | Claude Code CLI | `agent_skills.lua` | Ambos ⚠️ |
| Diretório fonte | `.claude/skills/` | `.claude/skills/` | `.claude/skills/` |
| Frontmatter nativo Claude | ✅ | ✅ (emulado) | ✅ |
| Injeção no system prompt | CLI nativo | `CodeCompanionChatCreated` | CLI + autocmd |
| `/skill` slash command | ❌ | ✅ | ✅ |
| Risco de duplicação | ❌ | ❌ | ⚠️ sim |
| `AGENTS.md` lido | ✅ | ✅ (via `/rules`) | ✅ |

---

## Localização dos arquivos

```
~/.config/nvim/
├── .claude/
│   └── skills/
│       ├── bug-fix/SKILL.md
│       ├── conventional-commits/SKILL.md
│       ├── tdd/SKILL.md
│       └── ...
├── lua/custom/
│   ├── agent_skills.lua        ← engine para Contextos 2 e 3
│   └── plugins/
│       ├── claudecode.lua      ← Contexto 1
│       └── codecompanion.lua   ← Contextos 2 e 3
└── docs/
    ├── AGENT_SKILLS_CONTEXTS.md  ← este documento
    └── SKILL_FRONTMATTER.md      ← referência do frontmatter
```

---

## Ver também

- [`docs/SKILL_FRONTMATTER.md`](SKILL_FRONTMATTER.md) — campos do frontmatter e como o parser funciona
- [`lua/custom/agent_skills.lua`](../lua/custom/agent_skills.lua) — implementação do sistema de skills
- [`lua/custom/plugins/codecompanion.lua`](../lua/custom/plugins/codecompanion.lua) — configuração dos adapters e autocmds
- [`lua/custom/plugins/claudecode.lua`](../lua/custom/plugins/claudecode.lua) — configuração do claudecode.nvim
