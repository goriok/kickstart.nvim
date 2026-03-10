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

# Run checkhealth for common modules
echo "--- Running checkhealth ---"
nvim --headless -c "checkhealth vim.lsp" -c "qa!" 2>&1 || true
echo ""

# Check for lua syntax errors in config
echo "--- Checking Lua syntax ---"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
errors=0
for f in $(find "$config_dir/lua" -name "*.lua" 2>/dev/null); do
  if ! luac -p "$f" 2>/dev/null; then
    echo "❌ Syntax error: $f"
    errors=$((errors + 1))
  fi
done

if [ "$errors" -eq 0 ]; then
  echo "✅ All Lua files parse correctly"
fi

echo ""
echo "=== Done ==="
