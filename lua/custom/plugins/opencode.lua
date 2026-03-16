return {
  'nickjvandyke/opencode.nvim',
  lazy = false,
  dependencies = {
    'folke/snacks.nvim',
  },
  config = function()
    vim.o.autoread = true
    vim.g.opencode_opts = {
      -- porta opcional; nil = auto-detect ou auto-spawn
      port = nil,
    }

    -- Layout: Oil (esquerda) | Opencode (direita) / Terminal full-width (baixo)
    local function workspace()
      -- 1. Oil na janela atual (esquerda)
      require('oil').open()

      -- 2. Opencode abre o próprio split à direita
      require('opencode').toggle()

      -- 3. Equaliza larguras entre Oil e Opencode
      vim.cmd('wincmd =')

      -- 4. Terminal horizontal fino, largura total
      vim.cmd('split')
      vim.cmd('wincmd J')
      vim.cmd('terminal')
      vim.cmd('resize 7')

      -- 5. Volta o foco para o Opencode
      vim.cmd('wincmd k')
    end

    vim.api.nvim_create_user_command('WorkSpace', workspace, { desc = 'Layout: Oil | Opencode / Terminal' })

    -- Abre automaticamente ao iniciar o Neovim
    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function()
        vim.schedule(workspace)
      end,
    })
  end,
  keys = {
    { '<leader>oo', function() require('opencode').toggle() end,                         desc = '[O]pencode toggle',        mode = { 'n', 't' } },
    { '<C-a>', function() require('opencode').ask('@this: ', { submit = true }) end,     desc = '[O]pencode ask',           mode = { 'n', 'x' } },
    { '<C-x>', function() require('opencode').select() end,                              desc = '[O]pencode select action', mode = { 'n', 'x' } },
    { 'go',    function() return require('opencode').operator() end,                     desc = '[O]pencode add (operator)', expr = true },
    { 'goo',   function() return require('opencode').operator() .. '_' end,              desc = '[O]pencode add line',       expr = true },
  },
}
