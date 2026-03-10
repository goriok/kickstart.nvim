#!/usr/bin/env bash
# Quick diagnostic check for Neovim config issues
# Usage: bash ${CLAUDE_SKILL_DIR}/scripts/check-health.sh

set -euo pipefail

echo "=== Neovim Config Health Check ==="
echo ""

# Check if nvim is available
if ! command -v nvim &>/dev/null; then
  echo "❌ nvim not found in PATH"
  exit 1
fi

echo "Neovim version: $(nvim --version | head -1)"
echo ""

# Print loaded config path
echo "--- Config path ---"
nvim --headless -c "lua io.write(vim.fn.stdpath('config') .. '\n')" -c "qa!" 2>/dev/null || true
echo ""

# Check for lua syntax errors in config
echo "--- Checking Lua syntax ---"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
errors=0

if ! command -v luac &>/dev/null; then
  echo "⚠️  luac not found — skipping Lua syntax check"
else
  while IFS= read -r f; do
    if ! luac -p "$f" 2>/dev/null; then
      echo "❌ Syntax error: $f"
      errors=$((errors + 1))
    fi
  done < <(find "$config_dir/lua" -name "*.lua" 2>/dev/null)

  if [ "$errors" -eq 0 ]; then
    echo "✅ All Lua files parse correctly"
  else
    echo "❌ $errors file(s) with syntax errors"
  fi
fi

echo ""
echo "=== Done ==="
