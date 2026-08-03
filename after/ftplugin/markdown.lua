-- Notação mínima de matemática discreta (ctx-source: usando-matematica-discreta-no-meu-dia-a-dia)
-- Gatilhos em sintaxe LaTeX (padrão reconhecido por qualquer agente/matemático),
-- expandem direto pro símbolo Unicode ao digitar espaço/pontuação — sem $...$, sem toolchain.
-- '\' precisa contar como keyword char pro parser de :iabbrev aceitar lhs tipo "\forall"
-- (senão é E474: nem full-id nem end-id nem non-id — ver :help abbreviations).
vim.opt_local.iskeyword:append('92')

local function iab(lhs, rhs) vim.cmd(string.format('iabbrev <buffer> %s %s', lhs, rhs)) end

iab([[\in]], '∈')
iab([[\notin]], '∉')
iab([[\subseteq]], '⊆')
iab([[\subset]], '⊂')
iab([[\cup]], '∪')
iab([[\cap]], '∩')
iab([[\setminus]], '<Bslash>')
iab([[\emptyset]], '∅')
iab([[\forall]], '∀')
iab([[\exists]], '∃')
iab([[\to]], '→')
iab([[\iff]], '↔')
iab([[\neg]], '¬')
iab([[\land]], '∧')
iab([[\lor]], '∨')
iab([[\mid]], '<Bar>')
iab([[\times]], '×')
iab([[\sqsubseteq]], '⊑')
