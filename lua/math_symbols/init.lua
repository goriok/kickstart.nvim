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
  { trigger = '\\subseteq', symbol = '⊆', desc = 'contido (ou igual)' },
  { trigger = '\\subset', symbol = '⊂', desc = 'contido estritamente' },
  { trigger = '\\cup', symbol = '∪', desc = 'união' },
  { trigger = '\\cap', symbol = '∩', desc = 'interseção' },
  { trigger = '\\setminus', symbol = '\\', desc = 'diferença de conjuntos' },
  { trigger = '\\emptyset', symbol = '∅', desc = 'conjunto vazio' },
  { trigger = '\\forall', symbol = '∀', desc = 'para todo' },
  { trigger = '\\exists', symbol = '∃', desc = 'existe' },
  { trigger = '\\to', symbol = '→', desc = 'implica' },
  { trigger = '\\iff', symbol = '↔', desc = 'se e somente se' },
  { trigger = '\\neg', symbol = '¬', desc = 'não' },
  { trigger = '\\land', symbol = '∧', desc = 'e' },
  { trigger = '\\lor', symbol = '∨', desc = 'ou' },
  { trigger = '\\mid', symbol = '|', desc = 'tal que' },
  { trigger = '\\times', symbol = '×', desc = 'produto cartesiano' },
  { trigger = '\\sqsubseteq', symbol = '⊑', desc = 'ordem parcial genérica' },
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
}

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
