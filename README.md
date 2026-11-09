# nvim-custom

Personal Neovim customizations layered on top of
[MiniMax](https://github.com/nvim-mini/mini.nvim) (mini.nvim).

## Structure

```
plugin/50_custom.lua              — git plugins, helm, toggleterm, render-markdown, LSP/TS config
after/lsp/helm_ls.lua             — Helm LSP config
after/lsp/ruff.lua                — Ruff LSP config
after/lsp/ty.lua                  — ty LSP config
after/lsp/yaml-ls.lua             — yamlls config (skips helm charts)
after/ftplugin/markdown/custom.lua — markdown: spell, folds, mini.surround link
after/snippets/lua.json           — personal Lua snippets
snippets/global.json              — global snippets (date/time)
```

## Install

```bash
git clone <repo> ~/dotfiles/nvim
bash ~/dotfiles/nvim/install.sh
```

Files are symlinked into `~/.config/nvim/`. MiniMax can be updated independently.
