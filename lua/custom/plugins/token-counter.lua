return {
  -- dir = "~/Dev/AI/obey-campaign/projects/nvim-token-counter",
  'lancekrogers/nvim-token-counter',
  dependencies = { 'nvim-lualine/lualine.nvim' },
  event = 'BufReadPost',

  opts = {
    model = 'claude-3',
    icon = '󰊄',
  },

  config = function(_, opts)
    require('nvim-token-counter').setup(opts)

    -- Add to lualine_x section
    local lualine = require 'lualine'
    local tc = require 'nvim-token-counter'
    local config = lualine.get_config()

    table.insert(config.sections.lualine_x, 1, {
      tc.lualine_component(),
      cond = tc.lualine_cond(),
    })

    lualine.setup(config)
  end,
}
