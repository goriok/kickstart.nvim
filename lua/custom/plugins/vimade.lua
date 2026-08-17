return {
  'TaDaa/vimade',
  event = 'VeryLazy',
  opts = {
    recipe = { 'default', { animate = true } },
    fadelevel = 0.4,
    -- 'windows': dim toda janela inativa (não só buffers duplicados
    -- nem só sob demanda) — é o comportamento que queremos.
    ncmode = 'windows',
    -- `default` é uma regra própria do plugin (bloqueia terminal, Pmenu,
    -- etc) — usamos uma chave nova para não sobrescrevê-la. Preserva os
    -- sinais de foco do focus.nvim (signcolumn) e do colorful-winsep.nvim
    -- (borda), senão o vimade escureceria por cima e os plugins ficariam
    -- competindo visualmente.
    blocklist = {
      preserve_focus_signals = {
        highlights = {
          'SignColumn',
          'WinSeparator',
          'ColorfulWinSep',
          'ColorfulWinSep_1',
        },
      },
    },
  },
}
