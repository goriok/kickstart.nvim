return {
  -- Render Markdown inside Neovim with nice formatting
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'codecompanion' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        -- Make headings stand out with icons
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Add a border above headings
        border = true,
      },
      code = {
        -- Render code blocks with a distinct background
        style = 'full',
        -- Show the language name on code blocks
        sign = true,
      },
      checkbox = {
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
      },
      bullet = {
        icons = { '●', '○', '◆', '◇' },
      },
    },
    keys = {
      {
        '<leader>mr',
        function()
          local rm = require 'render-markdown'
          rm.toggle()
        end,
        ft = 'markdown',
        desc = '[M]arkdown [R]ender toggle',
      },
    },
  },

  -- Live preview in the browser with hot-reload
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      -- Open preview in the default browser
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme = 'dark'
      -- Mermaid diagrams are supported natively by markdown-preview
      -- Ensure the preview renders fenced code blocks with mermaid
      vim.g.mkdp_preview_options = {
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
      }
    end,
    keys = {
      {
        '<leader>mp',
        '<cmd>MarkdownPreviewToggle<CR>',
        ft = 'markdown',
        desc = '[M]arkdown [P]review in browser',
      },
    },
  },
}
