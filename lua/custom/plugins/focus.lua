return {
  'nvim-focus/focus.nvim',
  version = '*',
  lazy = false,
  opts = {
    ui = {
      number = false,
      relativenumber = false,
      -- Dim de janela inativa (fundo + texto colorido) é feito pelo
      -- vimade agora — desligado aqui pra não haver dois plugins
      -- competindo pelo mesmo sinal visual de foco.
      cursorline = false,
      cursorcolumn = false,
      signcolumn = true,
      winhighlight = false,
    },
  },
}
