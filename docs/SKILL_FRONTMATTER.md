# Agent Skills — Frontmatter

## O que é o Frontmatter

O **frontmatter** é um bloco de metadados YAML colocado no **início** de um arquivo `SKILL.md`, delimitado por `---`. Ele instrui o sistema de Agent Skills (`lua/custom/agent_skills.lua`) sobre como carregar, filtrar e expor cada skill para o modelo de IA.

```markdown
---
name: minha-skill
description: O que esta skill faz e quando ela deve ser aplicada.
globs: ["src/**/*.ts", "*.test.ts"]
disable-model-invocation: false
user-invocable: true
allowed-tools: Read, Grep
argument-hint: [nome-do-componente]
---

# Conteúdo da Skill...
```

O parser (`parse_frontmatter`) extrai esses campos e tudo abaixo do segundo `---` vira o **body** — o conteúdo real injetado no prompt.

---

## Campos disponíveis

| Campo | Tipo | Padrão | Descrição |
|---|---|---|---|
| `name` | string | nome do diretório | Identificador da skill. Usado no índice do system prompt e no título `## Skill: <name>`. |
| `description` | string | `''` | Resumo exibido no índice Level 1 (system prompt). Deve ser curto (~1 linha). Se omitido, usa a primeira linha não-vazia do body. |
| `globs` | string[] | `[]` | Padrões de glob. A skill é injetada automaticamente quando algum buffer aberto bate com esses padrões. |
| `disable-model-invocation` | boolean | `false` | Se `true`, a skill é **ocultada do índice** — o modelo não sabe que ela existe. Só o usuário pode invocá-la. |
| `user-invocable` | boolean | `true` | Se `false`, a skill não pode ser chamada diretamente pelo usuário (reservado para uso interno do modelo). |
| `allowed-tools` | string (CSV) | `[]` | Lista de ferramentas (separadas por vírgula) que a skill pode usar sem confirmação. Ex: `Read, Grep, Glob`. |
| `argument-hint` | string | `nil` | Dica de autocomplete para argumentos. Ex: `[issue-number]`. Aparece na UI ao invocar a skill. |

---

## Como o sistema usa o frontmatter

O fluxo em `agent_skills.lua` é dividido em três níveis:

```
Level 1 → build_index()        → system prompt leve (~20 tokens por skill)
Level 2 → build_skill_content() → body completo das skills relevantes
Level 3 → ferramentas do modelo  → leitura de arquivos do projeto (read_file, grep_search…)
```

### Level 1 — Índice no system prompt

`build_index()` percorre todas as skills descobertas e monta uma lista leve:

```
You have access to Agent Skills in `.claude/skills/`.
All available skills:
- **bug-fix**: Guidelines for diagnosing and fixing bugs...
- **tdd**: Guidelines for Test Driven Development...
```

Skills com `disable-model-invocation: true` são **excluídas** desse índice.

### Level 2 — Body injetado contextualmente

`build_skill_content()` injeta o conteúdo completo da skill quando ela é considerada relevante (`is_skill_relevant`). A relevância é determinada por:

1. **Globs** — algum buffer aberto bate com `globs` da skill
2. **Nome na mensagem** — o nome da skill aparece na mensagem do usuário

### Substituição de variáveis no body

Dentro do body, você pode usar placeholders que são resolvidos em runtime:

| Placeholder | Resolve para |
|---|---|
| `$ARGUMENTS` | Todos os argumentos passados ao invocar a skill |
| `$ARGUMENTS[N]` | N-ésimo argumento (0-based) |
| `$N` | Atalho para `$ARGUMENTS[N]` |
| `${CLAUDE_SKILL_DIR}` | Caminho absoluto para o diretório da skill |

---

## Exemplos práticos

### Skill simples (sem frontmatter especial)

```markdown
---
name: conventional-commits
description: Rules for writing git commit messages using Conventional Commits (without scope).
---

# Conventional Commits (No Scope)
...
```

A skill aparece no índice e é injetada quando o usuário menciona "conventional commits" ou faz commit.

---

### Skill com globs (ativada por tipo de arquivo)

```markdown
---
name: react-component
description: Generate React components following project conventions.
globs: ["src/components/**/*.tsx", "*.test.tsx"]
argument-hint: [component-name]
---
```

Será injetada automaticamente sempre que um buffer `.tsx` dentro de `src/components/` estiver aberto.

---

### Skill oculta do modelo

```markdown
---
name: deploy-prod
description: Steps to deploy to production.
disable-model-invocation: true
---
```

O modelo **não vê** essa skill no índice. Ela só é ativada se o usuário a invocar explicitamente.

---

### Skill com ferramentas restritas

```markdown
---
name: code-review
allowed-tools: Read, Grep
---
```

Ao aplicar essa skill, apenas `Read` e `Grep` são utilizados sem confirmação adicional.

---

## Localização dos arquivos

```
<cwd>/
└── .claude/
    └── skills/
        ├── bug-fix/
        │   └── SKILL.md          ← frontmatter + body
        ├── tdd/
        │   └── SKILL.md
        └── minha-skill/
            ├── SKILL.md          ← entrypoint obrigatório
            ├── template.md       ← arquivo de suporte (opcional)
            └── scripts/
                └── validate.sh   ← script que o agente pode executar
```

Arquivos de suporte (tudo exceto `SKILL.md` e arquivos ocultos) são automaticamente descobertos por `discover_supporting_files()` e injetados no body como um bloco `## Supporting Files`.

---

## Checklist para criar uma nova skill

- [ ] Criar o diretório `.claude/skills/<nome-kebab-case>/`
- [ ] Criar `SKILL.md` com bloco `---` de frontmatter no topo
- [ ] Preencher `name` e `description` (mínimo obrigatório)
- [ ] Definir `globs` se a skill deve ser ativada automaticamente por tipo de arquivo
- [ ] Definir `disable-model-invocation: true` se a skill é sensível ou exclusiva do usuário
- [ ] Testar com `:lua require('custom.agent_skills').discover_skills()` no Neovim

---

## Referência rápida

```markdown
---
name: <kebab-case>
description: <uma linha explicando quando e como aplicar>
globs: ["<padrão-glob>"]
disable-model-invocation: false
user-invocable: true
allowed-tools: Read, Grep, Glob
argument-hint: [<dica>]
---
```
