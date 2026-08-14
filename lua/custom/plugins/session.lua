return {
  "folke/persistence.nvim",
  -- Carregamento imediato: "BufReadPre" nunca dispara ao abrir `nvim` sem
  -- arquivo, então o plugin (e seu autocmd de auto-save no exit) nunca
  -- carregava nesse caso. Precisamos que o save-on-exit esteja sempre armado.
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence-auto-restore", { clear = true }),
      nested = true,
      callback = function()
        -- Só restaura se o nvim foi aberto sem argumentos (sem arquivo/diretório passado)
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end,
    })
  end,
  opts = {
    -- Sessions saved to ~/.local/state/nvim/sessions/ (one file per cwd)
    dir = vim.fn.stdpath("state") .. "/sessions/",
    -- What to persist: buffers, cwd, tabs, window sizes/positions
    options = { "buffers", "curdir", "tabpages", "winsize", "winpos" },
    -- Automatically save session on exit (default: true)
    need = 1, -- minimum number of buffers to trigger auto-save
  },
  keys = {
    {
      "<leader>qs",
      function() require("persistence").load() end,
      desc = "[Q]uickload [S]ession for current dir",
    },
    {
      "<leader>ql",
      function() require("persistence").load({ last = true }) end,
      desc = "[Q]uickload [L]ast session",
    },
    {
      "<leader>qd",
      function() require("persistence").stop() end,
      desc = "[Q]uit without saving session",
    },
  },
}
