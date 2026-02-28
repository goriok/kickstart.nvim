return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', desc = '[T]oggle [T]erminal (horizontal)' },
    { '<leader>tf', desc = '[T]oggle [T]erminal (float)' },
    { '<leader>tv', desc = '[T]oggle [T]erminal (vertical)' },
  },
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = false, -- Gerenciamos os keymaps manualmente
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 0,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    local Terminal = require('toggleterm.terminal').Terminal

    -- Terminal horizontal (padrão)
    local horizontal = Terminal:new { direction = 'horizontal' }
    -- Terminal flutuante
    local float = Terminal:new { direction = 'float' }
    -- Terminal vertical
    local vertical = Terminal:new { direction = 'vertical' }

    vim.keymap.set('n', '<leader>tt', function()
      horizontal:toggle()
    end, { desc = '[T]oggle [T]erminal (horizontal)' })

    vim.keymap.set('n', '<leader>tf', function()
      float:toggle()
    end, { desc = '[T]oggle [T]erminal (float)' })

    vim.keymap.set('n', '<leader>tv', function()
      vertical:toggle()
    end, { desc = '[T]oggle [T]erminal (vertical)' })

    -- Navegação entre janelas dentro do terminal
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = 'Move focus left (terminal)' })
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = 'Move focus down (terminal)' })
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = 'Move focus up (terminal)' })
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = 'Move focus right (terminal)' })
  end,
}
