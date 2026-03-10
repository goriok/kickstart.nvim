---
description: Guidelines and patterns for developing and configuring Neovim plugins in this Lua-based setup.
globs: ["lua/custom/plugins/*.lua", "lua/kickstart/plugins/*.lua"]
---

# Neovim Plugin Development

## Core Patterns

- All plugin configs are self-contained in `lua/custom/plugins/`, one file per plugin
- Use `local` variables exclusively; avoid globals
- Plugin specs return a table compatible with `lazy.nvim`
- Use `vim.api.*` methods where possible over `vim.cmd`

## Config Structure

```lua
return {
  'author/plugin.nvim',
  dependencies = { ... },
  config = function()
    require('plugin').setup { ... }
  end,
  keys = { ... },
}
```

## Keymap Conventions

- Leader-based keymaps: `<leader>` + 2 chars (e.g., `<leader>ac` for AI Chat)
- Use `desc` field for which-key integration: `desc = '[A]I [C]hat'`
- Bracket notation in desc for highlighting: first letter of each word

## LSP Integration

- Use `vim.lsp.buf.*` for LSP actions
- Diagnostics via `vim.diagnostic.*`
- Format on save via conform.nvim, not LSP formatting

## Testing Changes

- After modifying plugin config: `:Lazy sync` or restart Neovim
- Check for errors: `:messages` or `:checkhealth`
