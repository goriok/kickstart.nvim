return {
  "folke/persistence.nvim",
  event = "BufReadPre",
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
