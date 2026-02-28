-- todo-comments.nvim: highlight and search TODO/NOTE/FIXME/HACK/BUG comments
-- https://github.com/folke/todo-comments.nvim
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = true, -- show icons in the sign column
    sign_priority = 8,
    keywords = {
      FIX  = { icon = ' ', color = 'error',   alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = '󰥔 ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = '󰎞 ', color = 'hint',    alt = { 'INFO', 'NOTES' } },
      TEST = { icon = '⏲ ', color = 'test',    alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
    -- stylua: ignore
    highlight = {
      multiline         = true,   -- enable multine todo comments
      multiline_pattern = '^.',   -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10,     -- extra lines that will be re-evaluated when changing a line
      before  = '',               -- "fg" or "bg" or empty
      keyword = 'wide',           -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
      after   = 'fg',             -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,       -- uses treesitter to match keywords in comments only
      max_line_len  = 400,
    },
  },
  keys = {
    { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next [T]odo comment' },
    { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Prev [T]odo comment' },
    { '<leader>st', '<cmd>TodoTelescope<cr>',                            desc = '[S]earch [T]odo comments' },
    { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',   desc = '[S]earch [T]odo/Fix/Fixme' },
    { '<leader>xt', '<cmd>TodoQuickFix<cr>',                             desc = 'Todo (QuickFi[x])' },
    { '<leader>xT', '<cmd>TodoLocList<cr>',                              desc = 'Todo (Loc[L]ist)' },
  },
}
