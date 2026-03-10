---
description: Guidelines for adding and configuring MCP servers in the codecompanion.nvim setup. Apply when adding, editing, or removing MCP servers from the codecompanion config.
globs: ["lua/custom/plugins/codecompanion.lua"]
---

# CodeCompanion MCP Servers

## Where to Add

All MCP servers live inside the `mcp.servers` table in `lua/custom/plugins/codecompanion.lua`:

```lua
mcp = {
  servers = {
    ['<server-name>'] = { ... },
  },
  opts = {
    default_servers = {},  -- auto-started servers; empty = on-demand only
  },
},
```

## Server Entry Structure

```lua
['server-name'] = {
  cmd = { 'npx', '-y', '<npm-package>' },   -- or 'uvx' for Python-based
  env = {                                    -- optional: only when needed
    SOME_VAR = vim.env.SOME_VAR,             -- read from environment
    FILE_PATH = vim.fn.stdpath 'data' .. '/subdir/file.json',  -- dynamic path
  },
},
```

## Command Patterns

| Runtime | Template | Use for |
|---------|----------|---------|
| Node (npx) | `{ 'npx', '-y', '<package>@latest' }` | npm-published MCP servers |
| Python (uvx) | `{ 'uvx', '<package>' }` | Python-based MCP servers |
| Binary | `{ '/absolute/path/to/binary' }` | Local/compiled servers |

## Current Servers (reference)

| Key | Package | Notes |
|-----|---------|-------|
| `context7` | `@upstash/context7-mcp@latest` | Auto-start via `default_servers` if needed |
| `sequential-thinking` | `@modelcontextprotocol/server-sequential-thinking` | On-demand |
| `pdf-reader` | `pdf-reader-mcp` (uvx) | On-demand |
| `git` | `mcp-server-git` (uvx) | On-demand |
| `repomix` | `repomix --mcp` | On-demand |
| `memory` | `@modelcontextprotocol/server-memory` | Uses `MEMORY_FILE_PATH` env var |

## Rules

- Use kebab-case keys for server names (e.g. `'my-server'`)
- Never hardcode absolute paths — use `vim.fn.stdpath('data')` or `vim.env.*`
- API keys must come from `vim.env.VAR_NAME`, never literal strings
- Add to `opts.default_servers` only if the server should auto-start with every chat
- Prefer `@latest` tag for npx packages to avoid stale versions
- After adding a server, update `AGENTS.md` under the **AI Tooling / MCP servers** section and `README.md` if it introduces a new user-facing capability

## Adding a New Server (checklist)

1. Choose the correct runtime (`npx` / `uvx` / binary)
2. Add the entry to `mcp.servers` in `lua/custom/plugins/codecompanion.lua`
3. If env vars are needed, read them from `vim.env.*` or use `vim.fn.stdpath()`
4. Decide: add to `opts.default_servers` (auto) or leave out (on-demand via `/mcp`)
5. Reload config (`:Lazy reload codecompanion.nvim`) and verify with `:CodeCompanionChat` + `/mcp`
6. Update `AGENTS.md` and `README.md`
7. Commit: `feat: add <server-name> MCP server to codecompanion`

## Anti-patterns

- ❌ `cmd = { 'npx', '<package>' }` — missing `-y` causes interactive prompt
- ❌ `api_key = 'sk-...'` — never inline secrets
- ❌ Adding every server to `default_servers` — slows chat startup unnecessarily
