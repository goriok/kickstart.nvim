-- MCP Server Entry Template
-- Add inside mcp.servers table in lua/custom/plugins/codecompanion.lua
-- Each block below is a standalone snippet — pick the one that fits.

-- snippet: Node (npx) server
--[[
['$SERVER_NAME'] = {
  cmd = { 'npx', '-y', '$NPM_PACKAGE@latest' },
},
]]

-- snippet: Python (uvx) server
--[[
['$SERVER_NAME'] = {
  cmd = { 'uvx', '$PIP_PACKAGE' },
},
]]

-- snippet: Server with environment variables
--[[
['$SERVER_NAME'] = {
  cmd = { 'npx', '-y', '$NPM_PACKAGE@latest' },
  env = {
    API_KEY = vim.env.API_KEY_VAR,
    DATA_PATH = vim.fn.stdpath('data') .. '/mcp/$SERVER_NAME/data.json',
  },
},
]]
