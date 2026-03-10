-- lua/custom/plugins/$PLUGIN_NAME.lua
-- $DESCRIPTION

return {
  '$AUTHOR/$PLUGIN_NAME.nvim',
  dependencies = {},
  event = 'VeryLazy', -- or: 'BufReadPre', 'InsertEnter', etc.
  config = function()
    require('$PLUGIN_NAME').setup {}
  end,
  keys = {
    {
      '<leader>xx',
      function()
        -- action
      end,
      mode = 'n',
      desc = '[X] Description',
    },
  },
}
