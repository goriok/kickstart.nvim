--- Sync agent skills symlinks: nvim config → ~/.claude/skills/
---
--- On VimEnter, ensures that every skill in:
---   ~/.config/nvim/.claude/skills/<name>/
--- has a corresponding symlink at:
---   ~/.claude/skills/<name> → <absolute source path>
---
--- Also removes stale symlinks that point into the source dir but whose
--- target no longer exists (i.e. the skill was deleted from the nvim config).
---
--- Symlinks pointing elsewhere (manually created skills) are never touched.

local M = {}

local source_dir = vim.fn.expand '~/.config/nvim/.claude/skills'
local target_dir = vim.fn.expand '~/.claude/skills'

function M.sync()
  vim.fn.mkdir(target_dir, 'p')

  -- 1. Create symlinks for new skills
  local source_skills = vim.fn.glob(source_dir .. '/*', false, true)
  for _, src_path in ipairs(source_skills) do
    local name = vim.fn.fnamemodify(src_path, ':t')
    local link = target_dir .. '/' .. name
    local stat = vim.uv.fs_lstat(link)
    if not stat then
      vim.uv.fs_symlink(src_path, link)
    end
    -- If stat exists: either it already points here (ok) or it's manual (skip)
  end

  -- 2. Remove stale symlinks that pointed into source_dir but target is gone
  -- Use fs_scandir instead of glob: glob silently skips broken symlinks
  local handle = vim.uv.fs_scandir(target_dir)
  if handle then
    while true do
      local name, ftype = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if ftype == 'link' then
        local link = target_dir .. '/' .. name
        local real = vim.uv.fs_readlink(link)
        if real and vim.startswith(real, source_dir) then
          if vim.uv.fs_stat(real) == nil then
            vim.uv.fs_unlink(link)
          end
        end
      end
    end
  end
end

return M
