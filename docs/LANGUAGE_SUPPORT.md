# Language Support

LSP, formatting, linting and Treesitter highlighting configured for:

| Language   | LSP                    | Formatter              | Linter                         |
| ---------- | ---------------------- | ---------------------- | ------------------------------ |
| Lua        | `lua-language-server`  | `stylua`               | —                              |
| Python     | `pyright`              | `ruff`                 | —                              |
| Go         | `gopls`                | `goimports`, `gofumpt` | `gopls` (built-in staticcheck) |
| Ruby       | `ruby-lsp`             | `rubocop`              | `rubocop`                      |
| JavaScript | `ts_ls`                | `prettierd`            | `eslint`                       |
| TypeScript | `ts_ls`                | `prettierd`            | `eslint`                       |
| JSX/TSX    | `ts_ls`                | `prettierd`            | `eslint`                       |
| Markdown   | `marksman`             | `prettierd`            | `markdownlint`                 |
| YAML       | `yaml-language-server` | `prettierd`            | `yamllint`                     |
| JSON       | —                      | `prettierd`            | `jsonlint`                     |
| CSS/HTML   | —                      | `prettierd`            | —                              |

Treesitter parsers also installed for: `bash`, `c`, `diff`, `mermaid`, `jsdoc`, `luadoc`, `query`, `vim`, `vimdoc`, and all languages above.
Filetype-to-parser mapping: `typescriptreact` → `tsx`, `javascriptreact` → `javascript`.
