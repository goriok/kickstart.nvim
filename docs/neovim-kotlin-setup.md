# Configurar Neovim para Kotlin/Android (24hface)

## 1. `~/.zshrc` — Exportar JAVA_HOME

Adicionar ao final do arquivo:

```bash
export JAVA_HOME="$HOME/jdk/zulu17.58.21-ca-jdk17.0.15-macosx_aarch64/zulu-17.jdk/Contents/Home"
```

---

## 2. `~/.config/nvim/init.lua` — 5 alterações

### A. Adicionar LSP Kotlin ao `servers` (por volta da linha 610, junto com `gopls`, `pyright`, etc.)

```lua
kotlin_language_server = {
  settings = {
    kotlin = {
      compiler = { jvm = { target = "17" } }
    }
  }
},
```

### B. Adicionar ao `lspconfig_to_mason` (por volta da linha 653, junto com `ruby_lsp` e `ts_ls`)

```lua
kotlin_language_server = 'kotlin-language-server',
```

### C. Adicionar ao `vim.list_extend(ensure_installed, {...})` (por volta da linha 662)

```lua
'kotlin-language-server',
'ktlint',
```

### D. Adicionar ao `formatters_by_ft` no bloco `conform.nvim` (por volta da linha 740)

```lua
kotlin = { 'ktlint' },
```

### E. Adicionar ao `filetypes` do Treesitter (por volta da linha 983, junto com `'ruby'`, `'go'`, etc.)

```lua
'kotlin',
'xml',
```

---

## 3. `~/.config/nvim/lua/custom/plugins/toggleterm.lua` — Keymap Gradle

**Nota:** `<leader>tt` já está em uso (terminal horizontal genérico). Usamos `<leader>tg` para Gradle.

Adicionar **dentro** do bloco `config = function(_, opts)`, após os keymaps existentes (linha ~45, antes do fechamento `end`):

```lua
vim.keymap.set('n', '<leader>tg', function()
  local jdk = os.getenv('HOME') .. '/jdk/zulu17.58.21-ca-jdk17.0.15-macosx_aarch64/zulu-17.jdk/Contents/Home'
  Terminal:new({
    cmd = 'JAVA_HOME="' .. jdk .. '" ./gradlew :rotation-calculator:test',
    dir = '/Users/goriok/sources/24hface',
    direction = 'horizontal',
    close_on_exit = false,
  }):toggle()
end, { desc = '[T]ests: [G]radle rotation-calculator' })
```

---

## Verificação

Depois de aplicar e reabrir o Neovim:

1. Mason instala `kotlin-language-server` e `ktlint` automaticamente na primeira abertura
2. Abrir `rotation-calculator/src/main/kotlin/com/goriok/watchface24h/HourHandRotation.kt`
3. `:LspInfo` → deve mostrar `kotlin_language_server` attached
4. `K` sobre qualquer símbolo → hover com documentação
5. `<leader>tg` → terminal abre e roda os 18 testes
