# Agents

## Context

The current project is a Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It aims to provide a starting point for users to configure Neovim, with a focus on being modular and understandable.

## Structure

- `init.lua`: The main entry point for the configuration. It sets up the leader key, options, and loads plugins.
- `lua/custom/plugins/`: A directory for user-defined plugins.
  - `codecompanion.lua`: Configuration for the `olimorris/codecompanion.nvim` plugin, which provides AI integration.
  - `init.lua`: A placeholder for adding more custom plugins.
  - `maximizer.lua`: Configuration for `szw/vim-maximizer`.
  - `oil.lua`: Configuration for `stevearc/oil.nvim`.
- `lua/kickstart/`: Core Kickstart configuration files.
  - `health.lua`: Health checks for the configuration.
  - `plugins/`: Configuration for plugins included in Kickstart.
    - `autopairs.lua`: Auto-pairing configuration.
    - `debug.lua`: Debug Adapter Protocol (DAP) configuration.
    - `gitsigns.lua`: Git integration configuration.
    - `indent_line.lua`: Indentation guides configuration.
    - `lint.lua`: Linting configuration using `nvim-lint`.
    - `neo-tree.lua`: File explorer configuration.

## Directives

- **Language**: Lua is the primary language used for configuration.
- **Style**: The configuration follows standard Lua practices for Neovim.
- **Modularity**: Plugins and configurations should be kept modular. `init.lua` orchestrates the setup, while specific plugin configurations reside in `lua/kickstart/plugins/` or `lua/custom/plugins/`.
- **Documentation**: Comments are used extensively to explain the configuration, serving as a guide for the user.
- **Maintenance**: Update `AGENTS.md` if significant changes to the project structure or conventions are made.
- **Documentation**: Update `README.md` if necessary when making significant changes to configuration, plugins or keymaps.

## Tools

The environment includes several tools accessible via Neovim plugins:

- `codecompanion.nvim`: AI-powered coding assistant.
- `nvim-dap`: Debugging support.
- `gitsigns.nvim`: Git integration.
- `nvim-lint`: Linting.
- `neo-tree.nvim`: File exploration.

## Workflow

1.  **Configuration**: Users modify `init.lua` and files in `lua/custom/plugins/` to tailor Neovim to their needs.
2.  **Plugin Management**: `lazy.nvim` (implied by the structure, though not explicitly seen in the initial file list, it's standard for Kickstart) manages plugins.
3.  **Health Checks**: `:checkhealth kickstart` can be used to verify the configuration.

## Conventions

- Prefer `vim.api` functions where appropriate.
- Use `local` variables to avoid polluting the global namespace.
- Keep plugin configurations self-contained.
