-- lua/custom/plugins/$PLUGIN_NAME.lua
-- $DESCRIPTION

return {
  '$AUTHOR/$PLUGIN_NAME.nvim',
  -- event = 'VeryLazy', -- uncomment and adjust: 'BufReadPre', 'InsertEnter', etc.
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
