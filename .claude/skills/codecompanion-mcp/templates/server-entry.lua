-- MCP Server Entry Template
-- Add inside mcp.servers table in lua/custom/plugins/codecompanion.lua

-- Node (npx) server:
['$SERVER_NAME'] = {
  cmd = { 'npx', '-y', '$NPM_PACKAGE@latest' },
},

-- Python (uvx) server:
['$SERVER_NAME'] = {
  cmd = { 'uvx', '$PIP_PACKAGE' },
},

-- Server with environment variables:
['$SERVER_NAME'] = {
  cmd = { 'npx', '-y', '$NPM_PACKAGE@latest' },
  env = {
    API_KEY = vim.env.API_KEY_VAR,
    DATA_PATH = vim.fn.stdpath('data') .. '/mcp/$SERVER_NAME/data.json',
  },
},
