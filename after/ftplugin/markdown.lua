-- Notação mínima de matemática discreta (ctx-source: usando-matematica-discreta-no-meu-dia-a-dia)
-- Gatilhos em sintaxe LaTeX (padrão reconhecido por qualquer agente/matemático),
-- expandem direto pro símbolo Unicode ao digitar espaço/pontuação — sem $...$, sem toolchain.
-- '\' precisa contar como keyword char pro parser de :iabbrev aceitar lhs tipo "\forall"
-- (senão é E474: nem full-id nem end-id nem non-id — ver :help abbreviations).
vim.opt_local.iskeyword:append('92')

local function iab(lhs, rhs) vim.cmd(string.format('iabbrev <buffer> %s %s', lhs, rhs)) end

iab([[\in]], '∈')
iab([[\notin]], '∉')
iab([[\ni]], '∋')
iab([[\nni]], '∌')
iab([[\subseteq]], '⊆')
iab([[\subset]], '⊂')
iab([[\supseteq]], '⊇')
iab([[\supset]], '⊃')
iab([[\nsubseteq]], '⊈')
iab([[\nsupseteq]], '⊉')
iab([[\nsubset]], '⊄')
iab([[\nsupset]], '⊅')
iab([[\subsetneq]], '⊊')
iab([[\supsetneq]], '⊋')
iab([[\cup]], '∪')
iab([[\cap]], '∩')
iab([[\setminus]], '<Bslash>')
iab([[\emptyset]], '∅')
iab([[\forall]], '∀')
iab([[\exists]], '∃')
iab([[\to]], '→')
-- → também cobre arco de grafo (aresta direta u → v) — uso padrão na literatura,
-- distinto de ⇒/⇔ (implicação/bicondicional metanível), resolvido por contexto.
-- ↝ é alcançabilidade: existe caminho de u a v (zero ou mais arcos), não um arco direto.
iab([[\arc]], '↝')
-- adjacência não-direcionada (u ∼ v: ligados por aresta, sem direção) — Diestel, Graph Theory.
iab([[\edge]], '∼')
iab([[\iff]], '↔')
iab([[\neg]], '¬')
iab([[\land]], '∧')
iab([[\lor]], '∨')
iab([[\mid]], '<Bar>')
iab([[\times]], '×')
iab([[\sqsubseteq]], '⊑')
iab([[\sqsupseteq]], '⊒')
iab([[\nsqsubseteq]], '⋢')
iab([[\nsqsupseteq]], '⋣')
iab([[\models]], '⊨')
iab([[\vdash]], '⊢')
iab([[\equiv]], '≡')
iab([[\neq]], '≠')
iab([[\leq]], '≤')
iab([[\geq]], '≥')
iab([[\N]], 'ℕ')
iab([[\Z]], 'ℤ')
iab([[\R]], 'ℝ')
iab([[\U]], '𝕌')
iab([[\fn]], '𝑓')
iab([[\ell]], 'ℓ')
iab([[\Rightarrow]], '⇒')
iab([[\Leftrightarrow]], '⇔')
iab([[\:=]], '≔')
iab([[\aleph]], 'ℵ')
iab([[\bigcap]], '⋂')
iab([[\bigcup]], '⋃')
iab([[\infty]], '∞')
iab([[\circ]], '∘')
iab([[\top]], '⊤')
iab([[\bot]], '⊥')
iab([[\cdot]], '·')
iab([[\powerset]], '𝒫')
iab([[\uplus]], '⊎')
iab([[\ominus]], '⊖')
iab([[\lambda]], 'λ')
iab([[\epsilon]], 'ε')
iab([[\Sigma]], 'Σ')
iab([[\Pi]], 'Π')
iab([[\alpha]], 'α')
iab([[\beta]], 'β')
iab([[\gamma]], 'γ')
iab([[\delta]], 'δ')
iab([[\Delta]], 'Δ')

-- "?" sobre operador — relação a provar/conjecturada, não estabelecida. Unicode só
-- precompõe estes três (sem combining overlay genérico pra "?" acima de outro glyph);
-- \subseteq, \equiv etc. conjecturais não têm forma Unicode e ficam fora do escopo.
iab([[\eqq]], '≟')
iab([[\ltq]], '⩻')
iab([[\gtq]], '⩼')

-- demais operadores conjecturais: sem forma precomposta em Unicode, convenção "<op> ?".
iab([[\subseteqq]], '⊆ ?')
iab([[\subsetq]], '⊂ ?')
iab([[\equivq]], '≡ ?')
iab([[\leqq]], '≤ ?')
iab([[\geqq]], '≥ ?')
iab([[\sqsubseteqq]], '⊑ ?')
iab([[\inq]], '∈ ?')
iab([[\notinq]], '∉ ?')
iab([[\nsubsetq]], '⊄ ?')

-- subscrito de texto arbitrário: \_max<C-j> → ₘₐₓ (indexação tipo A_max, x_total).
-- iabbrev não serve aqui: expande só em fronteira de palavra, e subscrito cola sem
-- espaço no caractere base (A\_i, não "A \_i") — full-id abbreviation nunca dispararia.
-- <Tab> também não serve de gatilho: blink.cmp já usa <Tab> pra navegar/aceitar o popup
-- de completion, então essa tecla teria prioridade em conflito real de digitação.
-- Unicode não tem subscrito pra b,c,d,f,g,q,w,y,z (latino) nem pra 19 das 24 gregas —
-- só β γ ρ φ χ têm (confirmado via UCD); letras sem entrada passam sem conversão.
-- Maiúscula subscrita não existe em NENHUM bloco Unicode (latino ou grego) — maiúsculas
-- caem pra minúscula equivalente (A\_N → Aₙ, perde o caso); sem entrada no mapa, passa reta.
local SUBSCRIPT_MAP = {
  ['0'] = '₀', ['1'] = '₁', ['2'] = '₂', ['3'] = '₃', ['4'] = '₄',
  ['5'] = '₅', ['6'] = '₆', ['7'] = '₇', ['8'] = '₈', ['9'] = '₉',
  a = 'ₐ', e = 'ₑ', h = 'ₕ', i = 'ᵢ', j = 'ⱼ', k = 'ₖ', l = 'ₗ', m = 'ₘ',
  n = 'ₙ', o = 'ₒ', p = 'ₚ', r = 'ᵣ', s = 'ₛ', t = 'ₜ', u = 'ᵤ', v = 'ᵥ', x = 'ₓ',
  ['+'] = '₊', ['-'] = '₋', ['='] = '₌', ['('] = '₍', [')'] = '₎',
  ['β'] = 'ᵦ', ['γ'] = 'ᵧ', ['ρ'] = 'ᵨ', ['φ'] = 'ᵩ', ['χ'] = 'ᵪ',
}
for lower, glyph in pairs(vim.deepcopy(SUBSCRIPT_MAP)) do
  local upper = lower:upper()
  if upper ~= lower then SUBSCRIPT_MAP[upper] = glyph end
end

-- sobrescrito: \^texto<C-j> → ᵗᵉˣᵗᵒ (ex. deg⁺, deg⁻ — grau de saída/entrada de vértice).
-- Cobertura Unicode de sobrescrito ainda é pior que a de subscrito: falta só 'q' no latino
-- (nenhum bloco Unicode define essa forma) — 'r' existe (U+02B6, small capital inverted r)
-- mas foi deixado de fora por não ser visualmente um 'r' reconhecível; maioria das gregas
-- também falta. Letras sem entrada no mapa passam sem conversão, como no subscrito.
local SUPERSCRIPT_MAP = {
  ['0'] = '⁰', ['1'] = '¹', ['2'] = '²', ['3'] = '³', ['4'] = '⁴',
  ['5'] = '⁵', ['6'] = '⁶', ['7'] = '⁷', ['8'] = '⁸', ['9'] = '⁹',
  a = 'ᵃ', b = 'ᵇ', c = 'ᶜ', d = 'ᵈ', e = 'ᵉ', f = 'ᶠ', g = 'ᵍ', h = 'ʰ', i = 'ⁱ', j = 'ʲ',
  k = 'ᵏ', l = 'ˡ', m = 'ᵐ', n = 'ⁿ', o = 'ᵒ', p = 'ᵖ', s = 'ˢ', t = 'ᵗ', u = 'ᵘ', v = 'ᵛ',
  w = 'ʷ', x = 'ˣ', y = 'ʸ', z = 'ᶻ',
  ['+'] = '⁺', ['-'] = '⁻', ['='] = '⁼', ['('] = '⁽', [')'] = '⁾',
}
for lower, glyph in pairs(vim.deepcopy(SUPERSCRIPT_MAP)) do
  local upper = lower:upper()
  if upper ~= lower then SUPERSCRIPT_MAP[upper] = glyph end
end

-- <C-j> unificado: detecta \_ (subscrito) ou \^ (sobrescrito) pelo prefixo antes do cursor.
vim.keymap.set('i', '<C-j>', function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)

  -- %w é ASCII-only; letras gregas (β γ ρ φ χ) entram via classe de bytes UTF-8 (\128-\255).
  -- Long-bracket string ([[ ]]) não processa escape decimal — precisa ser string normal
  -- pro padrão de subscrito (usa \128-\255); o de sobrescrito não precisa de bytes altos.
  local sub_start = before:find('\\_[%w+%-=()\128-\255]*$')
  local sup_start = before:find([[\%^[%w+%-=()]*$]])

  local prefix_start, map, skip
  if sub_start then
    prefix_start, map, skip = sub_start, SUBSCRIPT_MAP, 2
  elseif sup_start then
    prefix_start, map, skip = sup_start, SUPERSCRIPT_MAP, 2
  else
    return
  end

  local word = line:sub(prefix_start + skip, col)
  -- gsub('.', ...) itera por byte, não por caractere — quebraria multi-byte (gregas = 2
  -- bytes UTF-8). vim.fn.split(word, '\zs') separa por caractere Unicode corretamente.
  local chars = vim.fn.split(word, [[\zs]])
  local converted = table.concat(vim.tbl_map(function(ch) return map[ch] or ch end, chars))

  vim.api.nvim_set_current_line(line:sub(1, prefix_start - 1) .. converted .. line:sub(col + 1))
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], prefix_start - 1 + #converted })
end, { buffer = true, desc = 'Converte \\_texto (subscrito) ou \\^texto (sobrescrito) em Unicode' })
