-- Mini plugins: collection of small, independent, highly customizable Lua modules
-- See: https://github.com/nvim-mini/mini.nvim
--
-- Currently enabled:
--  • mini.ai - Better text objects (around/inside)
--  • mini.surround - Manipulate surroundings (brackets, quotes, etc.)
--  • mini.comment - Comment/uncomment lines with gc
--  • mini.cursorword - Auto-highlight word under cursor
--  • mini.indentscope - Visualize indentation level

return {
  'nvim-mini/mini.nvim',
  event = 'VimEnter',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Comment/uncomment with gc (operator)
    --
    -- - gcc  - Comment/uncomment current line
    -- - gc   - Comment/uncomment with motion (gcp = paragraph, gcl = line)
    -- - v + gc - Comment/uncomment visual selection
    require('mini.comment').setup()

    -- Auto-highlight word under cursor (like vim-illuminate but built-in)
    require('mini.cursorword').setup {
      delay = 100, -- Delay before highlighting (ms)
    }

    -- Visualize indentation level with a guide line
    require('mini.indentscope').setup {
      symbol = '│',
      draw = { delay = 100 }, -- Delay for animation
      options = { try_as_border = true },
    }

    -- Optional: Uncomment to use mini.statusline instead of lualine
    -- local statusline = require 'mini.statusline'
    -- statusline.setup { use_icons = vim.g.have_nerd_font }
    -- statusline.section_location = function() return '%2l:%-2v' end
  end,
}
