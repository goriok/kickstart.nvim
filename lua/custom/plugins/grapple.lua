return {
  'cbochs/grapple.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    scope = 'git', -- tags are scoped per git project
  },
  keys = {
    -- Add/toggle current file (with optional tag name prompt)
    {
      '<leader>ha',
      function()
        -- Tag with a description/name prompt
        vim.ui.input({ prompt = 'Tag name (optional): ' }, function(name)
          if name == nil then
            return -- cancelled
          end
          if name == '' then
            require('grapple').tag()
          else
            require('grapple').tag { name = name }
          end
        end)
      end,
      desc = '[H]arpoon/Grapple [A]dd file (with optional name)',
    },

    -- Toggle menu
    { '<leader>hh', '<cmd>Grapple toggle_tags<cr>', desc = '[H]arpoon/Grapple menu' },

    -- Jump to slots 1–4
    { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Grapple file 1' },
    { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Grapple file 2' },
    { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Grapple file 3' },
    { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Grapple file 4' },

    -- Cycle through tagged files
    { '<leader>hn', '<cmd>Grapple cycle_tags next<cr>', desc = '[H]arpoon/Grapple [N]ext file' },
    { '<leader>hp', '<cmd>Grapple cycle_tags prev<cr>', desc = '[H]arpoon/Grapple [P]rev file' },
  },
}
