return {
  'nvim-focus/focus.nvim',
  version = '*',
  lazy = false,
  opts = {
    ui = {
      number = false,
      relativenumber = false,
      cursorline = true,
      cursorcolumn = false,
      signcolumn = true,
      winhighlight = true,
    },
  },
  config = function(_, opts)
    require('focus').setup(opts)

    -- O plugin linka FocusedWindow -> VertSplit por padrão, o que deixa o
    -- texto (não só o separador) com baixo contraste em alguns temas/UIs
    -- (ex: oil.nvim). Sobrescrevemos com grupos nativos do Neovim, que
    -- todo colorscheme já define com a semântica certa: foco = Normal,
    -- sem foco = NormalNC ("Normal text in non-current windows").
    local function apply_focus_highlights()
      vim.api.nvim_set_hl(0, 'FocusedWindow', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'UnfocusedWindow', { link = 'NormalNC' })
    end

    apply_focus_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('focus-highlights', { clear = true }),
      callback = apply_focus_highlights,
    })

    -- Em buffers de terminal o focus.nvim atrapalha o scroll/seleção visual
    -- do scrollback (toggleterm, :terminal), então desligamos por buffer.
    vim.api.nvim_create_autocmd('TermOpen', {
      group = vim.api.nvim_create_augroup('focus-disable-terminal', { clear = true }),
      callback = function()
        vim.b.focus_disable = true
      end,
    })
  end,
}
