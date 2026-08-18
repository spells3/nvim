#!/usr/bin/env bash
# Install: symlink custom nvim files into ~/.config/nvim
# Run from any directory: bash ~/dotfiles/nvim/install.sh

set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
NVIM="$HOME/.config/nvim"

link() {
  local src="$DOT/$1"
  local dst="$NVIM/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    echo "skip (already linked): $1"
  elif [ -e "$dst" ]; then
    echo "backup + link: $1"
    mv "$dst" "$dst.bak"
    ln -s "$src" "$dst"
  else
    echo "link: $1"
    ln -s "$src" "$dst"
  fi
}

link plugin/50_custom.lua
link after/ftplugin/markdown/custom.lua
link after/lsp/helm_ls.lua
link after/lsp/ruff.lua
link after/lsp/ty.lua
link after/lsp/yaml-ls.lua
link after/snippets/lua.json
link snippets/global.json

echo "Done."
