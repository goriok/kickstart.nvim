# Using Mini Plugins

`mini.nvim` is a collection of small, independent, highly customizable Lua modules that you can use individually or in combination. They're bundled together but function as separate plugins.

## Overview

Available mini modules (see https://github.com/nvim-mini/mini.nvim):

- **mini.ai** - Better text objects (around/inside)
- **mini.align** - Align text by separators
- **mini.animate** - Animate common Neovim actions
- **mini.basics** - Basic editor options
- **mini.bufremove** - Remove buffers without closing windows
- **mini.clue** - Show keybinding clues
- **mini.colors** - Color manipulation
- **mini.comment** - Comment/uncomment lines
- **mini.completion** - Completion (lightweight alternative to blink)
- **mini.cursorword** - Auto-highlight word under cursor
- **mini.diff** - Work with diffs
- **mini.doc** - Minimal documentation generator
- **mini.extra** - Extra features for other modules
- **mini.files** - File navigator
- **mini.fuzzy** - Fuzzy matching
- **mini.git** - Git integration
- **mini.hipatterns** - Highlight patterns (TODOs, HEX colors, etc.)
- **mini.icons** - File/extension icons
- **mini.indentscope** - Visualize indentation
- **mini.jump** - Extended f/F/t/T motions
- **mini.notify** - Notification system
- **mini.operators** - Custom operators
- **mini.pick** - Picker UI
- **mini.sessions** - Session management
- **mini.splitjoin** - Split/join code blocks
- **mini.statusline** - Status line
- **mini.surround** - Manipulate surroundings (brackets, quotes)
- **mini.tabline** - Tab line
- **mini.test** - Run tests
- **mini.tricky-motions** - Tricky text motions
- **mini.visits** - Track and navigate file visits

## Current Setup in Your Config

In `init.lua`, you have:

```lua
{ -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    
    -- mini.statusline is commented out (you use lualine instead)
  end,
}
```

**Active modules**: `mini.ai`, `mini.surround`

## How to Use Mini Plugins

### Option 1: Add to `init.lua` (Current Setup)

Edit the existing mini.nvim config block in `init.lua`:

```lua
{ -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup { n_lines = 500 }
    
    -- Add/delete/replace surroundings
    require('mini.surround').setup()
    
    -- Highlight indentation scope
    require('mini.indentscope').setup()
    
    -- Highlight word under cursor
    require('mini.cursorword').setup()
    
    -- Highlight patterns (HEX colors, TODOs, etc)
    require('mini.hipatterns').setup()
    
    -- Comment/uncomment lines
    require('mini.comment').setup()
  end,
}
```

### Option 2: Create Separate Plugin File (Recommended)

Following your convention, create `lua/custom/plugins/mini.lua`:

```lua
return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup { n_lines = 500 }
    
    -- Add/delete/replace surroundings
    require('mini.surround').setup()
    
    -- Highlight indentation scope
    require('mini.indentscope').setup {
      symbol = '│',
      options = { try_as_border = true },
    }
    
    -- Highlight word under cursor
    require('mini.cursorword').setup()
    
    -- Comment/uncomment lines
    require('mini.comment').setup()
  end,
}
```

Then lazy.nvim will automatically import it via the `{ import = 'custom.plugins' }` line.

## Popular Mini Modules & Examples

### mini.ai - Better Text Objects

Already configured! Provides `ia`, `aa` (around), `ii`, `ai` (inside) for text objects.

```lua
require('mini.ai').setup { n_lines = 500 }
```

**Usage:**
- `vii` - Select inside indentation
- `vai` - Select around indentation
- `vi)` - Select inside parentheses
- `ca"` - Change around quotes

### mini.surround - Manipulate Surroundings

Already configured!

```lua
require('mini.surround').setup()
```

**Usage:**
- `saiw)` - Add surround around word with `)`
- `sd'` - Delete surrounding quotes
- `sr)'` - Replace `)` with `'`

### mini.comment - Comment/Uncomment

```lua
require('mini.comment').setup()
```

**Usage:**
- `gc` - Comment/uncomment (motion required: `gcc` for line, `gcp` for paragraph)

### mini.indentscope - Visualize Indentation

```lua
require('mini.indentscope').setup {
  symbol = '│',
  options = { try_as_border = true },
  draw = { delay = 100, animation = require('mini.animate').gen_timing.linear { duration = 100 } }
}
```

Shows a vertical line indicating the current indentation level.

### mini.cursorword - Auto-Highlight Word

```lua
require('mini.cursorword').setup()
```

Automatically highlights the word under cursor.

### mini.hipatterns - Highlight Special Patterns

```lua
require('mini.hipatterns').setup {
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFIXME' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHACK'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTODO'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNOTE'  },
    
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
}
```

### mini.files - File Navigator

```lua
require('mini.files').setup {
  options = { use_as_default_explorer = true },
  windows = { preview = true, width_nofocus = 20 },
}

-- Optional keymap to open mini.files
vim.keymap.set('n', '<leader>e', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0))
end, { desc = '[E]xplore files' })
```

### mini.notify - Notifications

```lua
require('mini.notify').setup()

-- Use it:
-- MiniNotify.show('Hello!', 'INFO')
-- vim.notify('Message', vim.log.levels.INFO) -- if set as default
```

### mini.pick - Picker UI

```lua
require('mini.pick').setup()

-- Use builtin telescope or mini.pick based on preference
vim.keymap.set('n', '<leader>sp', function() require('mini.pick').builtin.files() end, { desc = 'Pick files' })
```

### mini.sessions - Session Management

```lua
require('mini.sessions').setup {
  autoread = true,  -- Auto-load last session
  autowrite = true, -- Auto-save session
}

-- Keymaps
vim.keymap.set('n', '<leader>qs', function() require('mini.sessions').write() end, { desc = '[Q]uit [S]ave session' })
vim.keymap.set('n', '<leader>qr', function() require('mini.sessions').read() end, { desc = '[Q]uit [R]ead session' })
```

## Recommended Combination

For a solid experience alongside your current setup:

```lua
return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Already enabled
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    
    -- Additional recommendations
    require('mini.comment').setup()      -- gc to comment
    require('mini.cursorword').setup()   -- Highlight word under cursor
    require('mini.indentscope').setup {
      symbol = '│',
      options = { try_as_border = true },
    }
  end,
}
```

## Disabling Modules

Simply don't call `require()` on them. Only modules you explicitly configure are loaded.

## Keymaps

Most mini modules work out-of-the-box with default keymaps. Check the docs by:

1. `:help mini.{module}` (e.g., `:help mini.surround`)
2. https://github.com/nvim-mini/mini.nvim

## Tips

- Mini modules are **lightweight** and **self-contained** — no heavy dependencies
- They integrate well with each other
- Start with a few and add as you need them
- Most have sensible defaults and are highly customizable
- No need to create separate plugin files for each; one `mini.nvim` entry handles all
