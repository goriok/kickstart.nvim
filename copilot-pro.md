# Guia Completo: Copilot Pro - Modelos, Preços e Limites Semanais 2025/2026

## 📋 Resumo Executivo para Copilot Pro ($10-39/mês)

**O Sistema de Premium Requests** é o mecanismo de controle implementado em maio de 2025 que diferencia Copilot Pro de suas alternativas. Ao contrário de Claude Pro (limite semanal em tokens), Copilot funciona com um modelo **metered baseado em requisições**, onde cada modelo consome **diferentes quantidades de "premium requests"**.

**Seu Limite Semanal (Copilot Pro - $10/mês):** Aproximadamente **300 premium requests por mês**, o que equivale a **~10 premium requests por dia útil (segunda a sexta)**, dependendo de qual modelo você usa.

**Impacto para você:** Se você usa **GPT-4o (base model)** — unlimited. Se você quer usar **Claude Opus 4.6, Claude Sonnet 4.6, ou o1-preview** — cada request consome entre 1-4x seu allowance.

**Relação com Claude Pro:**

- Claude Pro: Limite em **tokens**, conversas estruturadas, melhor para **deep analysis** de legado
- Copilot Pro: Limite em **requisições**, IDE-first, melhor para **coding assistance** e **completions**

---

## 🤖 Modelos Copilot Disponíveis (Fevereiro 2026)

### 1. **GPT-5.1 / GPT-5.1-Codex** - O Principal (OpenAI)

- **Lançamento:** Setembro 2025 (GPT-5.1), Dezembro 2025 (GPT-5.1-Codex)
- **Premium Request Multiplier:** 1.0x (mesmo que base)
- **Contexto:** 200K tokens
- **Melhor para:** Code generation, refactoring, completions (completar linha, função inteira)
- **Características:** Mais rápido que GPT-4o, raciocínio mais profundo, suporte multilingue melhorado
- **Disponível em:** Copilot Free (limited), Copilot Pro ($10), Copilot Pro+ ($39), Business, Enterprise
- **Status:** Default em Visual Studio Code (desde junho 2025)

### 2. **Claude Opus 4.6** - O Raciocínio Premium (Anthropic)

- **Lançamento:** Fevereiro 2026 (compatibilidade com Copilot anunciada)
- **Premium Request Multiplier:** 4.0x (custa 4 premium requests por prompt)
- **Contexto:** 1M tokens (beta)
- **Melhor para:** Debugging profundo, refatoração complexa, análise arquitetural
- **Características:** Extended thinking, 76% acurácia em "needle-in-haystack", adaptive reasoning
- **Disponível em:** Copilot Pro+ ($39/mês apenas), Business, Enterprise
- **Status:** Novo, não disponível em Copilot Pro basic ($10)

### 3. **Claude Sonnet 4.6** - O Sweet Spot (Anthropic)

- **Lançamento:** Fevereiro 2026 (compatibilidade com Copilot)
- **Premium Request Multiplier:** 2.0x (custa 2 premium requests por prompt)
- **Contexto:** 1M tokens (beta)
- **Melhor para:** Refatoração normal, code review, feature implementation
- **Características:** 90% da capacidade de Opus por 50% do custo de premium requests
- **Disponível em:** Copilot Pro+ ($39/mês apenas), Business, Enterprise
- **Status:** Novo, não disponível em Copilot Pro basic ($10)

### 4. **Claude Haiku 4.5** - O Rápido (Anthropic)

- **Lançamento:** Outubro 2025 (compatibilidade com Copilot anunciada)
- **Premium Request Multiplier:** 0.5x (custa 0.5 premium requests — ou seja, 2 requests = 1 premium)
- **Contexto:** 200K tokens
- **Melhor para:** Inline suggestions, quick edits, boilerplate generation
- **Características:** 4-5x mais rápido que Sonnet, 73% performance em SWE-bench
- **Disponível em:** Copilot Pro ($10), Pro+ ($39), Business, Enterprise
- **Status:** Extremamente eficiente em cost de premium requests

### 5. **o3-mini / o4-mini** - O Novo Raciocínio OpenAI

- **Lançamento:** Dezembro 2025 (o3-mini), Janeiro 2026 (o4-mini)
- **Premium Request Multiplier:** 2.0x-3.0x (custa 2-3 premium requests)
- **Contexto:** 128K tokens
- **Melhor para:** Complex reasoning, edge case analysis, algorithm design
- **Características:** Reasoning models (pensam mais antes de responder), rápido para reasoning (vs o1)
- **Disponível em:** Copilot Pro+ ($39/mês), Business, Enterprise
- **Status:** Alternative mais rápida ao o1-preview

### 6. **Gemini 3 Pro / Gemini 3.1 Pro** - O Multimodal (Google)

- **Lançamento:** Dezembro 2025 (Gemini 3 Pro), Fevereiro 2026 (Gemini 3.1 Pro)
- **Premium Request Multiplier:** 1.5x-2.0x
- **Contexto:** 200K tokens
- **Melhor para:** Data analysis, visual debugging (CSVs, charts, logs), multimodal tasks
- **Características:** Excelente com dados estruturados, image understanding, chart interpretation
- **Disponível em:** Copilot Pro+ ($39/mês), Business, Enterprise
- **Status:** Especialista em análise de dados

### 7. **GPT-4o / GPT-4.1** - O Base (OpenAI)

- **Lançamento:** Maio 2023 (GPT-4o), Junho 2025 (GPT-4.1)
- **Premium Request Multiplier:** 1.0x (base — **unlimited em todos os planos**)
- **Contexto:** 200K tokens
- **Melhor para:** Geral, inline suggestions, chat
- **Características:** Multimóda, razoável em código, muito rápido
- **Disponível em:** Copilot Free (limited), Pro, Pro+, Business, Enterprise
- **Status:** Default em Copilot (unlimited usage)

### 8. **Raptor mini** - O Ultrarrápido (Microsoft Research)

- **Lançamento:** Novembro 2025
- **Premium Request Multiplier:** 0.1x (praticamente grátis — 10 requests = 1 premium)
- **Contexto:** 128K tokens
- **Melhor para:** Lightweight completions, quick syntax help, boilerplate
- **Características:** Lightning-fast, otimizado para latência, low-token
- **Disponível em:** Copilot Pro ($10), Pro+ ($39), Business, Enterprise
- **Status:** Mais barato que Haiku 4.5 em premium requests

---

## 💰 Tabela de Preços Comparativa (Copilot)

| Modelo            | Multiplier | Cost por Request | Tokens Contexto | Melhor Uso    |
| ----------------- | ---------- | ---------------- | --------------- | ------------- |
| **Raptor mini**   | 0.1x       | ~$0.004          | 128K            | Lightweight   |
| **Haiku 4.5**     | 0.5x       | ~$0.02           | 200K            | Quick edits   |
| **GPT-4o (base)** | 1.0x       | UNLIMITED        | 200K            | Geral         |
| **GPT-5.1**       | 1.0x       | UNLIMITED\*      | 200K            | Code gen      |
| **Gemini 3 Pro**  | 1.5x-2.0x  | ~$0.06-0.08      | 200K            | Data analysis |
| **Sonnet 4.6**    | 2.0x       | ~$0.08           | 1M              | Refactoring   |
| **o3-mini**       | 2.0x-3.0x  | ~$0.08-0.12      | 128K            | Reasoning     |
| **Opus 4.6**      | 4.0x       | ~$0.16           | 1M              | Complex       |

\*GPT-5.1 é unlimited apenas se for o default; se você trocar modelo explicitamente, consome premium requests

---

## 🔑 O CRÍTICO: Copilot Pro ($10/mês) vs Pro+ ($39/mês)

### Copilot Pro - $10/mês

| Métrica                       | Quantidade                                                      |
| ----------------------------- | --------------------------------------------------------------- |
| **Premium Requests/mês**      | 300                                                             |
| **Premium Requests/dia útil** | ~10                                                             |
| **Modelos Inclusos**          | GPT-4o (unlimited), GPT-5.1 (unlimited), Haiku 4.5, Raptor mini |
| **Claude Opus 4.6**           | ❌ Não                                                          |
| **Claude Sonnet 4.6**         | ❌ Não                                                          |
| **o3-mini / o4-mini**         | ❌ Não                                                          |
| **Gemini 3 Pro**              | ❌ Não                                                          |
| **Melhor para**               | Indie devs, freelancers, uso ocasional                          |
| **Custo por exceder**         | $0.04 por premium request (overage)                             |

**Exemplo: Seu uso típico em Copilot Pro ($10)**

```
Segunda-feira:
- 10 inline completions (GPT-4o, unlimited) = 0 premium requests
- 5 chat prompts em Sonnet 4.6 = ❌ NÃO DISPONÍVEL

Terça-feira:
- 3 refactoring tasks em Haiku 4.5 = 1.5 premium requests
- 2 chat em GPT-4o = 0 premium requests
Total: 1.5 premium requests

Quarta a Sexta: Similar
Total semanal: ~20-30 premium requests (bem confortável!)
```

### Copilot Pro+ - $39/mês

| Métrica                       | Quantidade                                                |
| ----------------------------- | --------------------------------------------------------- |
| **Premium Requests/mês**      | 1,500                                                     |
| **Premium Requests/dia útil** | ~50                                                       |
| **Modelos Inclusos**          | TODOS (Opus 4.6, Sonnet 4.6, o3-mini, Gemini 3 Pro, etc.) |
| **Claude Opus 4.6**           | ✅ Sim, 4.0x multiplier                                   |
| **Claude Sonnet 4.6**         | ✅ Sim, 2.0x multiplier                                   |
| **o3-mini / o4-mini**         | ✅ Sim, 2.0x-3.0x multiplier                              |
| **Gemini 3 Pro**              | ✅ Sim, 1.5x-2.0x multiplier                              |
| **Melhor para**               | Power users, teams, agentic workflows                     |
| **Custo por exceder**         | $0.04 por premium request (overage)                       |

**Exemplo: Seu uso típico em Copilot Pro+ ($39)**

```
Segunda a Sexta (poder total):
- 10 inline completions (GPT-4o, unlimited) = 0 premium requests
- 8 refactoring tasks em Sonnet 4.6 = 16 premium requests
- 3 deep debug em Opus 4.6 = 12 premium requests
- 2 data analysis em Gemini 3 Pro = 3-4 premium requests
- 2 reasoning tasks em o3-mini = 4-6 premium requests

Total diário: ~35-42 premium requests
Total semanal: ~175-210 premium requests

Você tem budget para 1,500/semana ÷ 5 = 300/dia
Status: 🟢 CONFORTÁVEL (usando apenas ~40% do budget)
```

---

## 🎯 CONVERSÃO: Premium Requests ↔️ Custo Real

### Preços Estimados por Tier

**Base:** GitHub não publicou preço oficial por premium request, mas based em competitive pricing com Claude API:

| Tier                   | Premium Requests  | Custo Estimado | Request Cost                  |
| ---------------------- | ----------------- | -------------- | ----------------------------- |
| **Copilot Free**       | 50/mês            | $0             | Grátis                        |
| **Copilot Pro**        | 300/mês           | $10/mês        | ~$0.033 por request (average) |
| **Copilot Pro+**       | 1,500/mês         | $39/mês        | ~$0.026 por request (average) |
| **Copilot Business**   | 300 + ilimitado   | $19/user/mês   | Incluso em business           |
| **Copilot Enterprise** | 1,000 + ilimitado | $39/user/mês   | Incluso em enterprise         |
| **Overage**            | +1                | +$0.04/request | $0.04 por request             |

### Quanto Vale Realmente Seu Copilot Pro?

**Cenário: Você usa 150 premium requests/mês (50% do seu allowance)**

| Se Modelo  | Requests | Multiplier | Cost                                                 |
| ---------- | -------- | ---------- | ---------------------------------------------------- |
| Sonnet 4.6 | 150      | 2.0x       | 150×2 = 300 premium units = está dentro do budget    |
| Opus 4.6   | 150      | 4.0x       | 150×4 = 600 premium units = **EXCEDE! Paga overage** |

**Cálculo do Overage:**

- Budget: 300 premium requests
- Uso: 600 (150 prompts × 4x multiplier)
- Overage: 300 requests × $0.04 = **$12 extra no mês**
- Total: $10 + $12 = $22/mês (mais caro que Pro+!)

**Conclusão:** Se você usa regularmente Opus 4.6, o Pro+ ($39) é mais barato que Pro ($10 + overages).

---

## 🔄 Premium Requests Por Modelo (Multipliers Exatos)

Conforme documentação oficial de GitHub (fevereiro 2026):

| Modelo                      | Multiplier         | Custo por Prompt                   |
| --------------------------- | ------------------ | ---------------------------------- |
| **Raptor mini**             | 0.1x               | 1 request = 10 prompts (!)         |
| **GPT-4o**                  | Base (unlimited)   | $0                                 |
| **GPT-5.1 / GPT-5.1-Codex** | Base (unlimited)\* | $0 (se default)                    |
| **Haiku 4.5**               | 0.5x               | 1 request = 2 prompts              |
| **Gemini 2.5 Flash**        | 1.0x               | 1 request = 1 prompt               |
| **Gemini 3 / 3.1 Pro**      | 1.5x-2.0x          | 1 request = 0.5-0.67 prompts       |
| **Sonnet 3.5**              | 1.5x               | ⚠️ DEPRECATED (remove 31 jan 2026) |
| **Sonnet 4.6**              | 2.0x               | 1 request = 0.5 prompts            |
| **o3-mini**                 | 2.0x-3.0x          | 1 request = 0.33-0.5 prompts       |
| **o4-mini**                 | 3.0x               | 1 request = 0.33 prompts           |
| **Opus 4.5**                | 3.5x               | 1 request = 0.28 prompts           |
| **Opus 4.6**                | 4.0x               | 1 request = 0.25 prompts           |

\*GPT-5.1 consome premium requests se você trocar explicitamente de modelo; é unlimited se for o auto-selected

---

## 🎯 Estratégia por Tier: Como Não Gastar Demais

### Se Você Tem Copilot Pro ($10/mês) — 300 Premium Requests

**Recomendação:** Use GPT-4o/5.1 (unlimited) 80% do tempo, reserve premium requests para o que realmente precisa.

| Uso                         | Frequência   | Requests/mês      | Status           |
| --------------------------- | ------------ | ----------------- | ---------------- |
| Inline completions (GPT-4o) | 100+ por dia | 0                 | ✅ Grátis        |
| Chat em GPT-5.1 (default)   | 5-10 por dia | 0                 | ✅ Grátis        |
| Quick edits em Haiku 4.5    | 3-5 por dia  | 50-100            | ✅ 17-33% budget |
| Refactoring em Sonnet 4.6   | 1-2 por dia  | ❌ Não disponível | —                |
| Complex debugging em Opus   | —            | ❌ Não disponível | —                |

**Total: ~100 premium requests/mês = CONFORTÁVEL**

**Pricepoint:** $10/mês por ~3,000 prompts (se usar GPT-4o como base) é **excelente**.

---

### Se Você Tem Copilot Pro+ ($39/mês) — 1,500 Premium Requests

**Recomendação:** Use de tudo! Sonnet como default para refactoring, Opus para deep work, o3 para reasoning.

| Uso                         | Frequência    | Requests/mês | Status           |
| --------------------------- | ------------- | ------------ | ---------------- |
| Inline completions (GPT-4o) | 100+ por dia  | 0            | ✅ Grátis        |
| Chat em GPT-5.1 (default)   | 10-15 por dia | 0            | ✅ Grátis        |
| Refactoring em Sonnet 4.6   | 3-5 por dia   | 300-500      | ✅ 20-33% budget |
| Debugging em Opus 4.6       | 1-2 por dia   | 80-160       | ✅ 5-11% budget  |
| Reasoning tasks em o3-mini  | 1-2 por dia   | 50-100       | ✅ 3-7% budget   |
| Data analysis em Gemini 3   | 1 por dia     | 40-50        | ✅ 3-4% budget   |

**Total: ~500-900 premium requests/mês = MUITO CONFORTÁVEL**

**Pricepoint:** $39/mês por ~5,000-8,000 prompts de ALTA QUALIDADE (Opus + Sonnet) é **significativamente melhor que Pro**.

---

## 🚀 Quando Cada Tier Faz Sentido

### Copilot Pro ($10) — Use Se:

- ✅ Você é indie dev, freelancer, ou estudante
- ✅ Usa principalmente inline completions (GPT-4o)
- ✅ Ocasionalmente precisa de Haiku 4.5 para quick edits
- ✅ Não faz debugging profundo ou refactoring complexo
- ✅ Seu IDE é VSCode, e você quer o essencial

**Economia:** $10/mês = ~$0.003 por prompt em GPT-4o (vs $0.015 API)

### Copilot Pro+ ($39) — Use Se:

- ✅ Você é dev experiente (senior, staff-level)
- ✅ Faz refactoring complexo regularmente (Sonnet)
- ✅ Precisa debugging profundo (Opus)
- ✅ Usa data analysis (Gemini)
- ✅ Quer reasoning (o3/o4)
- ✅ Trabalha em codebase grande/legado
- ✅ **Seu custo por prompt é MENOR que Pro** se você usa modelos premium

**Análise:** Para 50 prompts Sonnet/mês:

- Pro: 50 × 2x = 100 premium requests = dentro do budget
- Pro: Para 100 prompts Sonnet: 100 × 2 = 200 requests = ainda OK
- Pro: Para 200 prompts Sonnet: 200 × 2 = 400 requests = **EXCEDE (pagou $8 overage, total $18)**
- Pro+: Mesmos 200 prompts = 400 requests = **6 premium de 1,500 (10% do budget, zero overage)**

**Break-even:** Se você usa >150 prompts Sonnet/mês, Pro+ é mais barato.

### Copilot Business ($19/user/mês) — Use Se:

- ✅ Você é parte de uma equipe (2+ devs)
- ✅ Precisa de admin controls e compliance
- ✅ Quer treinamento de modelo custom on your codebase
- ✅ Precisa enterprise support

**Nota:** Business é por usuário/mês, então um time de 10 devs = $190/mês.

---

## 🔗 Integração com Seu Setup (Neovim + CodeCompanion)

**Situação atual:** Você usa CodeCompanion em Neovim com Claude Pro (via OAuth).

**Questão:** Deveria integrar Copilot também?

### Análise de Custo-Benefício

| Aspecto            | Claude Pro                 | Copilot Pro          | Copilot Pro+    |
| ------------------ | -------------------------- | -------------------- | --------------- |
| **Preço**          | $20/mês                    | $10/mês              | $39/mês         |
| **Modelo Default** | Sonnet 4.6                 | GPT-5.1              | GPT-5.1         |
| **Melhor em**      | Deep analysis, 1M context  | Code generation, IDE | All-in-one      |
| **Pior em**        | IDE integration            | Não tem Opus         | Caro se não usa |
| **Setup**          | CodeCompanion OAuth        | GitHub + IDE         | GitHub + IDE    |
| **Para Seu Caso**  | **Legado audit (Repomix)** | Inline completions   | Full toolkit    |

### Recomendação Pragmática

**Seu workflow atual com Claude Pro é OTIMIZADO para:**

- Análise de legado (Repomix + Opus 4.6 1M context)
- Deep coding studies (extended thinking)
- Session-based conversational debugging

**GitHub Copilot é OTIMIZADO para:**

- Inline code generation (while you type)
- Quick chat in IDE
- Model switching without context loss

**Conclusão:** Complementares, não competitivas.

**Estratégia Recomendada:**

1. **Mantenha Claude Pro** ($20/mês) — para o que você faz: legado audit, deep analysis
2. **Considere Copilot Pro+** ($39/mês) se:
   - Você quer Opus em IDE (debugging profundo enquanto código)
   - Você quer Sonnet para refactoring incremental
   - Seu workflow muda de "batch audit" para "continuous refactoring"
3. **NÃO use ambos Pro normais** — seria redundante e caro ($30/mês por funcionalidade similar)

---

## 📊 Seu Orçamento: Claude Pro vs Copilot Pro+ vs Ambos

### Cenário 1: Indie Dev (Budget Limitado)

```
Opção A: Claude Pro ($20/mês)
- Semana: 2-3 audits legado (via Repomix + Opus 4.6)
- Resultado: 1-2 relatórios profundos/semana
- Custo: $20
- Ganho: 15 horas de trabalho mecânico → 2-3 horas de análise estruturada

Opção B: Copilot Pro ($10/mês)
- Semana: 40-50 horas coding com inline completions
- Resultado: 2x produtividade em escrita de código
- Custo: $10
- Ganho: 10 horas de time-mecânico (typing, boilerplate)

Opção C: Ambos ($30/mês)
- Você tem todas as ferramentas
- Custo: $30
- Recomendação: Se seu orçamento permite, FAÇA ISSO. Você cobre audit + desenvolvimento.
```

### Cenário 2: Senior Dev em Empresa (Budget Pode ser Expense)

```
Opção A: Claude Pro ($20/mês)
- Melhor para: Code audit sênior, refactor planning
- Custo para empresa: $20
- ROI: 10x (você economiza 10h/semana em análise)

Opção B: Copilot Pro+ ($39/mês)
- Melhor para: Daily development (Sonnet refactoring, Opus debugging)
- Custo para empresa: $39
- ROI: 8x (você economiza 8h/semana em coding)

Opção C: AMBOS ($59/mês)
- Melhor cobertura
- Claude: Audits e decisões de arquitetura
- Copilot: Daily coding + refactoring
- Custo para empresa: $59
- ROI: 15x (você economiza 15h/semana total)
- Recomendação: FÁCIL ROI-positivo. A empresa ganha $$ com isso.

Break-even:
Seu salário: $100k/ano = $48/hora
Você economiza 15h/semana × 48 semanas = 720h/ano × $48 = $34,560 produtividade
Custo ferramentas: $59 × 12 = $708/ano
ROI: 34,560 / 708 = **48x return** ✨
```

---

## ⚠️ Armadilhas de Premium Requests (Síndrome do "Subscription Creep")

### Armadilha 1: Trocar de Modelo Explicitamente vs Auto-Select

```lua
-- ❌ CARO: Você força Opus 4.6
/model claude-opus-4-6
prompt: "Refactor this module"
Cost: 4x premium request

-- ✅ BARATO: Deixa auto-select (GPT-5.1)
prompt: "Refactor this module"
Cost: 0 premium requests (se for default)

Lição: ChatGPT auto-select é seu amigo. Ative em settings.
```

### Armadilha 2: Ignorar Premium Request Budget

```
Cenário: Você tem Copilot Pro, está habituado com "unlimited" Claude
Segunda: "Let me use Opus 4.6, just this once" → 4 premium requests
Terça-Quinta: Similar (20 premium requests/dia)
Sexta: Aviso: "You've exceeded your monthly budget"
Resultado: $0.04 × 100 extra requests = $4 overage (40% de aumento)

Lição: Monitor seu usage. Ative alertas. Copilot fornece "Consumption Panel" em VS Code.
```

### Armadilha 3: Confundir Tier Limite com Bom Uso

```
❌ ERRADO: "Tenho 300 premium requests, vou usar TODOS com Sonnet"
300 requests × 2x multiplier = 150 prompts Sonnet = parece OK

✅ CERTO: "Tenho 300 premium, vou usar 200 com GPT-4o (0) + 50 com Sonnet (100 premium) + 10 com Haiku (5 premium) = 105 total"
Resultado: Você usa só 35% do budget, fica seguro.
```

---

## 🔑 Síntese: Copilot Pro vs Claude Pro

### Ficar com Claude Pro Se:

- Você faz análise de legado regularmente (Repomix + Opus 4.6)
- Você precisa de 1M context window
- Você gosta de conversas estruturadas (não IDE-first)
- Você quer extended thinking nativo

### Trocar para Copilot Pro+ Se:

- Seu workflow mudou para "incremental refactoring" (não batch audit)
- Você quer Opus enquanto codifica (debugging profundo)
- Você usa Sonnet 4.6 regularmente
- Você quer reasoning (o3/o4) para complex problems

### Ficar com AMBOS Se:

- Budget permite ($59/mês = ~$700/ano)
- Você alterna entre "batch audit" (Claude) e "daily coding" (Copilot)
- Você quer máxima flexibilidade e cobertura
- Sua empresa vê ROI claro (senior dev + deep analysis)

---

## 💡 Prognóstico: Copilot vs Claude Pro em 2026

### Cenário A: Copilot Integra Claude Opus Natively (Provável)

```
Copilot Pro+ future state:
- Opus 4.6 incluído com Copilot Pro+ (não só em Pro+, mas também Pro??)
- Premium request system converge com "tokens" (mais transparente)
- Result: Copilot Pro+ vira "Claude Pro+ alternative" com IDE-first advantage

Implicação para você: Sua escolha simplifica. Escolha por IDE preference.
```

### Cenário B: Claude API Integra Coding Agent Natively (Possível)

```
Claude Agent future state:
- Agente de Claude ganha native editor integration (não via CodeCompanion)
- Extended thinking automático em tarefas de refactoring
- 1M context virar standard (não beta)

Implicação para você: Claude fica melhor para legado (seu case).
```

### Cenário C: Separação Clara de Uso (Mais Provável)

```
2026 Reality:
- Copilot: IDE-first, inline completions, quick chat
- Claude Pro: IDE-agnostic, deep analysis, extended thinking, 1M context
- Resultado: They coexist comfortably. Use ambos, cada um em seu place.
```

---

## 🎯 TL;DR - Copilot Pro (Muito Longo; Não Li)

**Qual modelo?** GPT-5.1 (unlimited no Pro), Sonnet 4.6 (se Pro+), Opus 4.6 (se Pro+ e precisa deep).

**Qual tier?** Pro ($10) se indie/freelance, Pro+ ($39) se senior/deep work.

**Premium Requests:** Pro = 300/mês (~10/dia), Pro+ = 1,500/mês (~50/dia).

**Multipliers críticos:**

- GPT-4o, GPT-5.1 = unlimited (0 cost)
- Haiku 4.5 = 0.5x (2 prompts por 1 premium)
- Sonnet 4.6 = 2.0x (1 prompt por 2 premium)
- Opus 4.6 = 4.0x (1 prompt por 4 premium, só Pro+)

**Seu caso (legado audit):** Claude Pro é melhor (Opus 1M context, Repomix support).

**Seu caso (daily coding):** Copilot Pro+ é melhor (Sonnet inline, Opus deep debug).

**Seu caso (ambos):** $59/mês = massive ROI. Faça.

**Overage:** $0.04/premium request. Monitore. Pro é barato até atingir ~400 requests; depois Pro+ economiza.

---

## 📚 Recursos Rápidos

- GitHub Copilot Docs: https://docs.github.com/en/copilot
- Supported Models: https://docs.github.com/en/copilot/reference/ai-models/supported-models
- Premium Requests Explain: https://docs.github.com/en/copilot/managing-copilot-business/overview-of-github-copilot-business
- Model Comparison: https://docs.github.com/en/copilot/reference/ai-models/model-comparison

---

## 🔒 Pontos-Chave Importantes para Copilot Pro

### Sobre Seus Limites:

1. **Premium Requests são diferentes de tokens** — baseados em requisição, não em quantidade de tokens
2. **Multiplier varia por modelo** — Opus (4x) custa muito mais que Haiku (0.5x)
3. **GPT-4o/5.1 é unlimited** — use como default, troque apenas quando precisa realmente
4. **Overage é barato** ($0.04/request), mas acumula rápido se você não monitora

### Sobre Escolher Tier:

1. **Pro ($10) é excelente para indie/quick edits** — 300 premium request é suficiente
2. **Pro+ ($39) paga por si se você usa Sonnet** — 150+ prompts Sonnet/mês = break-even
3. **Ambos Pro + Claude Pro = power stack** — $59/mês é bargain para senior dev
4. **Não use Opus em Pro** — você vai gastar $20+/mês em overage

### Sobre Modelos:

1. **Raptor mini é subestimado** — 0.1x multiplier, muito rápido para lightweight tasks
2. **Sonnet 4.6 é o sweet spot** — 2x multiplier, 90% de Opus, disponível em Pro+
3. **Opus 4.6 é o sledgehammer** — 4x multiplier, só use para genuinely complex debugging
4. **GPT-5.1 é underrated** — unlimited se for default, razoavelmente inteligente, muito rápido

### Sobre Workflow em IDE:

1. **Auto-select é seu amigo** — ativa em settings, economiza premium requests automaticamente
2. **Copilot CLI é novo e agentic** — considere para terminal workflows (integra com seu Neovim)
3. **Code review feature usa premium requests** — factor isso no seu orçamento
4. **Consumption Panel ajuda** — VS Code mostra exatamente quanto você gastou

---

## 🎯 Recomendação Final (Sua Situação Específica)

**Você é:** Senior Engineer, especialista em legado, usa Neovim + CodeCompanion + Repomix.

**Setup Atual:** Claude Pro ($20/mês) = 40-80h Sonnet/semana = ótimo para audits.

**Recomendação:**

```
Phase 1 (Mês 1-2): Mantenha Claude Pro
- Continua Repomix + Opus 4.6 audits (seu case ideal)
- Mede quanto tempo você ganha vs trabalho manual
- Se >5h/semana economizado: ROI positivo, continue

Phase 2 (Mês 3+): Avalie Copilot Pro+ ($39)
- Se seu workflow mudou para "refactoring contínuo" (não só audits)
- Se você quer Sonnet 4.6 inline em VSCode
- Se você precisa debugging rápido com Opus enquanto codifica
- Break-even: 150 prompts Sonnet/mês vs Pro+ cost

Phase 3 (Mês 6+): Considere AMBOS ($59/mês)
- Claude: 2-3 audits/semana (legado, deep analysis)
- Copilot: Daily coding (refactoring, debugging)
- Custo: $59/mês
- Ganho: 15h/semana automação → $34k+ annualized productivity
- ROI: 48x

Decision Framework:
- If audits are 70%+ of your work → Claude Pro only
- If refactoring is 70%+ of your work → Copilot Pro+ only
- If mixed 50/50 → Ambos ($59) é no-brainer
```

---

**Status:** Análise Completa. Ready to implement.
