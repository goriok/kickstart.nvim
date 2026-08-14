-- blink.cmp source: autocomplete de notação matemática discreta em markdown.
-- Complementa (não substitui) o iabbrev de after/ftplugin/markdown.lua: iabbrev expande
-- sozinho quando você já lembra o gatilho LaTeX; esta source sugere via popup quando
-- você só lembra o prefixo (ex. digitar "\su" e ver \subseteq, \subset).
--
-- blink.cmp calcula bounds de keyword com sua própria regex ([\p{L}0-9_-]), que ignora
-- 'iskeyword' do buffer e corta no '\' — então ctx.get_keyword()/ctx.bounds não servem
-- pra saber onde o gatilho começa. Escaneamos ctx.line manualmente até a última '\'
-- antes do cursor e montamos o textEdit com esse range (nunca insertText, que dispara
-- a lógica de guess de blink pra texto com símbolos).

local SYMBOLS = {
  { trigger = '\\in', symbol = '∈', desc = 'pertence' },
  { trigger = '\\notin', symbol = '∉', desc = 'não pertence' },
  { trigger = '\\ni', symbol = '∋', desc = 'contém como membro (S ∋ x, inverso de x ∈ S)' },
  { trigger = '\\nni', symbol = '∌', desc = 'não contém como membro' },
  { trigger = '\\subseteq', symbol = '⊆', desc = 'contido (ou igual)' },
  { trigger = '\\subset', symbol = '⊂', desc = 'contido estritamente' },
  { trigger = '\\supseteq', symbol = '⊇', desc = 'contém (ou igual)' },
  { trigger = '\\supset', symbol = '⊃', desc = 'contém estritamente' },
  { trigger = '\\nsubseteq', symbol = '⊈', desc = 'não é subconjunto (nem igual)' },
  { trigger = '\\nsupseteq', symbol = '⊉', desc = 'não é superconjunto (nem igual)' },
  { trigger = '\\nsubset', symbol = '⊄', desc = 'não é subconjunto' },
  { trigger = '\\nsupset', symbol = '⊅', desc = 'não é superconjunto' },
  { trigger = '\\subsetneq', symbol = '⊊', desc = 'subconjunto estrito (com ≠)' },
  { trigger = '\\supsetneq', symbol = '⊋', desc = 'superconjunto estrito (com ≠)' },
  { trigger = '\\cup', symbol = '∪', desc = 'união' },
  { trigger = '\\cap', symbol = '∩', desc = 'interseção' },
  { trigger = '\\setminus', symbol = '\\', desc = 'diferença de conjuntos' },
  { trigger = '\\emptyset', symbol = '∅', desc = 'conjunto vazio' },
  { trigger = '\\forall', symbol = '∀', desc = 'para todo' },
  { trigger = '\\exists', symbol = '∃', desc = 'existe' },
  { trigger = '\\to', symbol = '→', desc = 'implica / arco de grafo (u → v)' },
  { trigger = '\\arc', symbol = '↝', desc = 'alcançabilidade — existe caminho de u a v (zero ou mais arcos)' },
  { trigger = '\\edge', symbol = '∼', desc = 'adjacência não-direcionada (u ∼ v)' },
  { trigger = '\\iff', symbol = '↔', desc = 'se e somente se' },
  { trigger = '\\neg', symbol = '¬', desc = 'não' },
  { trigger = '\\land', symbol = '∧', desc = 'e' },
  { trigger = '\\lor', symbol = '∨', desc = 'ou' },
  { trigger = '\\mid', symbol = '|', desc = 'tal que' },
  { trigger = '\\times', symbol = '×', desc = 'produto cartesiano' },
  { trigger = '\\sqsubseteq', symbol = '⊑', desc = 'ordem parcial genérica' },
  { trigger = '\\sqsupseteq', symbol = '⊒', desc = 'ordem parcial genérica (inversa)' },
  { trigger = '\\nsqsubseteq', symbol = '⋢', desc = 'não é ordem parcial genérica (⊑ negado)' },
  { trigger = '\\nsqsupseteq', symbol = '⋣', desc = 'não é ordem parcial genérica inversa (⊒ negado)' },
  -- satisfaz / prova
  { trigger = '\\models', symbol = '⊨', desc = 'satisfaz (semântico)' },
  { trigger = '\\vdash', symbol = '⊢', desc = 'derivável / prova (sintático)' },
  -- comparação / equivalência
  { trigger = '\\equiv', symbol = '≡', desc = 'equivalente' },
  { trigger = '\\neq', symbol = '≠', desc = 'diferente' },
  { trigger = '\\leq', symbol = '≤', desc = 'menor ou igual' },
  { trigger = '\\geq', symbol = '≥', desc = 'maior ou igual' },
  -- conjuntos numéricos
  { trigger = '\\N', symbol = 'ℕ', desc = 'naturais' },
  { trigger = '\\Z', symbol = 'ℤ', desc = 'inteiros' },
  { trigger = '\\R', symbol = 'ℝ', desc = 'reais' },
  { trigger = '\\U', symbol = '𝕌', desc = 'conjunto universo' },
  { trigger = '\\fn', symbol = '𝑓', desc = 'função genérica (itálico matemático) — ex. 𝑓: A → B' },
  { trigger = '\\ell', symbol = 'ℓ', desc = 'função de rotulagem de grafo — ex. ℓ: E → Σ' },
  -- implicação/bicondicional metanível (entre afirmações/passos de prova, distinto de →/↔ dentro de fórmula)
  { trigger = '\\Rightarrow', symbol = '⇒', desc = 'implica (metanível — "logo", entre afirmações)' },
  { trigger = '\\Leftrightarrow', symbol = '⇔', desc = 'se e somente se (metanível)' },
  -- definição
  { trigger = '\\:=', symbol = '≔', desc = 'definido como (:= )' },
  -- cardinalidade infinita / limites
  { trigger = '\\aleph', symbol = 'ℵ', desc = 'cardinalidade infinita' },
  { trigger = '\\bigcap', symbol = '⋂', desc = 'interseção generalizada sobre família de conjuntos' },
  { trigger = '\\bigcup', symbol = '⋃', desc = 'união generalizada sobre família de conjuntos' },
  { trigger = '\\infty', symbol = '∞', desc = 'infinito' },
  -- composição / topo-fundo de ordem parcial
  { trigger = '\\circ', symbol = '∘', desc = 'composição de funções' },
  { trigger = '\\top', symbol = '⊤', desc = 'topo (maior elemento)' },
  { trigger = '\\bot', symbol = '⊥', desc = 'fundo (menor elemento)' },
  -- multiplicação (evita colisão com × de produto cartesiano)
  { trigger = '\\cdot', symbol = '·', desc = 'multiplicação' },
  -- teoria de conjuntos estendida
  { trigger = '\\powerset', symbol = '𝒫', desc = 'conjunto potência (não é LaTeX padrão — \\wp gera ℘, símbolo diferente)' },
  { trigger = '\\uplus', symbol = '⊎', desc = 'união disjunta' },
  { trigger = '\\ominus', symbol = '⊖', desc = 'diferença simétrica' },
  -- letras gregas de uso real em matemática discreta/CS
  { trigger = '\\lambda', symbol = 'λ', desc = 'lambda — cálculo lambda, função anônima' },
  { trigger = '\\epsilon', symbol = 'ε', desc = 'epsilon — quantidade pequena/limite' },
  { trigger = '\\Sigma', symbol = 'Σ', desc = 'somatório' },
  { trigger = '\\Pi', symbol = 'Π', desc = 'produtório' },
  { trigger = '\\alpha', symbol = 'α', desc = 'variável genérica' },
  { trigger = '\\beta', symbol = 'β', desc = 'variável genérica' },
  { trigger = '\\gamma', symbol = 'γ', desc = 'variável genérica' },
  { trigger = '\\delta', symbol = 'δ', desc = 'delta minúsculo — distância/diferença pequena' },
  { trigger = '\\Delta', symbol = 'Δ', desc = 'delta maiúsculo — variação' },
  -- "?" sobre operador — relação a provar/conjecturada (só existem estes 3 precompostos em Unicode)
  { trigger = '\\eqq', symbol = '≟', desc = 'igualdade a provar/conjecturada (? sobre =)' },
  { trigger = '\\ltq', symbol = '⩻', desc = 'menor-que conjecturado (? sobre <)' },
  { trigger = '\\gtq', symbol = '⩼', desc = 'maior-que conjecturado (? sobre >)' },
  -- demais operadores conjecturais: sem forma precomposta em Unicode, convenção "<op> ?"
  { trigger = '\\subseteqq', symbol = '⊆ ?', desc = 'contido (ou igual) conjecturado' },
  { trigger = '\\subsetq', symbol = '⊂ ?', desc = 'contido estritamente conjecturado' },
  { trigger = '\\equivq', symbol = '≡ ?', desc = 'equivalente conjecturado' },
  { trigger = '\\leqq', symbol = '≤ ?', desc = 'menor ou igual conjecturado' },
  { trigger = '\\geqq', symbol = '≥ ?', desc = 'maior ou igual conjecturado' },
  { trigger = '\\sqsubseteqq', symbol = '⊑ ?', desc = 'ordem parcial genérica conjecturada' },
  { trigger = '\\inq', symbol = '∈ ?', desc = 'pertença conjecturada' },
  { trigger = '\\notinq', symbol = '∉ ?', desc = 'não-pertença conjecturada' },
  { trigger = '\\nsubsetq', symbol = '⊄ ?', desc = 'não é subconjunto, conjecturado' },
}

-- subscrito de texto arbitrário (\_max<Tab> → ₘₐₓ) não é gatilho fixo — não entra nesta
-- tabela. Mecanismo dedicado em after/ftplugin/markdown.lua (insert-mode mapping).

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:enabled() return vim.bo.filetype == 'markdown' end

function source:get_trigger_characters() return { '\\' } end

function source:get_completions(ctx, callback)
  local line = ctx.line
  local col = ctx.cursor[2] -- 0-indexed, byte offset before cursor

  local trigger_start = nil
  for i = col, 1, -1 do
    local ch = line:sub(i, i)
    if ch == '\\' then
      trigger_start = i
      break
    elseif ch:match('%s') then
      break
    end
  end

  if not trigger_start then
    callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
    return function() end
  end

  local typed = line:sub(trigger_start, col)

  local items = {}
  for _, entry in ipairs(SYMBOLS) do
    if vim.startswith(entry.trigger, typed) then
      table.insert(items, {
        label = entry.trigger .. '  ' .. entry.symbol,
        kind = require('blink.cmp.types').CompletionItemKind.Text,
        filterText = entry.trigger,
        sortText = entry.trigger,
        documentation = { kind = 'plaintext', value = entry.desc },
        textEdit = {
          newText = entry.symbol,
          range = {
            start = { line = ctx.cursor[1] - 1, character = trigger_start - 1 },
            ['end'] = { line = ctx.cursor[1] - 1, character = col },
          },
        },
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      })
    end
  end

  callback({ items = items, is_incomplete_forward = true, is_incomplete_backward = true })
  return function() end
end

return source
