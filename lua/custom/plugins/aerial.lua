-- aerial.nvim - Code outline and symbol navigation
-- Shows the structure of your code (functions, classes, methods, etc) in a tree view.
-- Great for navigating large files and understanding code structure at a glance.

return {
  'stevearc/aerial.nvim',
  opts = {
    -- Automatically open aerial when entering a supported buffer
    attach_mode = 'global',

    -- Open aerial in a split window
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },

    -- Window options
    layout = {
      -- max_width can be an integer (number of columns) or a float (percentage of window)
      max_width = { 40, 0.25 },
      width = 30,
      min_width = 10,

      -- key-value pairs of window options for aerial window (e.g. winhl, colorcolumn)
      win_opts = {},

      -- Determine the default direction to open the aerial window. The 'prefer'
      -- options will open the window in the other direction *if* there is a
      -- different buffer in the other window. Use the other options to always
      -- open in the specified direction.
      default_direction = 'prefer_right',

      -- Set this to an integer if you want to always open aerial on the left side
      -- and want a fixed width.
      -- Set this to a float if you want to always open aerial on the left side
      -- and want a width percentage of the screen.
      placement = 'window',

      -- When the symbols change, resize the aerial window (within the min/max constraints)
      -- Set to false if you want a fixed size
      preserve_equality = false,
    },

    -- Icon configuration
    nerd_font = vim.g.have_nerd_font,

    -- Show icons for the symbols
    icons = {},

    -- Display options
    show_guides = true,

    -- Keymaps in the aerial buffer. Use the command name, not the mapping string.
    keymaps = {
      ['?'] = 'actions.show_help',
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.jump',
      ['<2-LeftMouse>'] = 'actions.jump',
      ['-'] = 'actions.close',
      ['o'] = 'actions.jump',
      ['h'] = 'actions.prev',
      ['j'] = 'actions.next',
      ['k'] = 'actions.prev',
      ['l'] = 'actions.next',
      ['{'] = 'actions.prev_up',
      ['}'] = 'actions.next_up',
      ['[['] = 'actions.prev_up',
      [']]'] = 'actions.next_up',
      ['q'] = 'actions.close',
      ['v'] = 'actions.visual',
      ['V'] = 'actions.visual_line',
      ['<C-v>'] = 'actions.visual_block',
    },

    -- Call this function when aerial attaches to a buffer.
    on_attach = function(bufnr)
      -- Jump back to aerial window if we are in a different window
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, nowait = true })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, nowait = true })
    end,

    -- A list of all the characters that will be used to render guides
    guides = {
      mid_item = '├─ ',
      last_item = '└─ ',
      nested_top = '│ ',
      whitespace = '  ',
    },
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },

  config = function(_, opts)
    require('aerial').setup(opts)

    -- Keymaps for opening aerial
    vim.keymap.set('n', '<leader>ts', '<cmd>AerialToggle!<CR>', { desc = '[T]oggle [S]ymbols (Aerial)' })
    vim.keymap.set('n', '<leader>tS', '<cmd>AerialToggleAll<CR>', { desc = '[T]oggle [S]ymbols for all buffers' })

    -- Keymaps for navigation
    vim.keymap.set('n', 'gO', function()
      -- Use telescope if available to search symbols, otherwise use aerial
      pcall(function() require('telescope.builtin').lsp_document_symbols() end)
    end, { desc = '[G]oto [O]utline (Document Symbols)' })

    -- Optional: Highlight the symbol at the cursor
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        if vim.fn.exists ':AerialInfo' == 2 then
          pcall(function() require('aerial').sync_highlight() end)
        end
      end,
    })
  end,
}
