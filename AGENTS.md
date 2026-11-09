# AGENTS.md

Personal Neovim config layered on top of MiniMax (mini.nvim starter).
MiniMax itself lives in `~/.config/nvim/` (`init.lua`, `plugin/10..40_*.lua`)
and is NOT in this repo. This repo only holds the custom layer, symlinked
into `~/.config/nvim/` by `install.sh`.

## Layout

- `plugin/50_custom.lua` -- everything custom: extra plugins, keymaps, LSP
  enables, tree-sitter langs, helm autocmds. Loads after MiniMax `40_plugins.lua`.
- `after/lsp/*.lua` -- per-server LSP config (`vim.lsp.config` style).
- `after/ftplugin/markdown/custom.lua` -- markdown buffer settings.
- `after/snippets/*.json`, `snippets/global.json` -- snippets.
- `install.sh` -- symlinks each file into `~/.config/nvim/`. New files must be
  added to its `link` list, otherwise Neovim never sees them.

## Conventions

- Plugins: `vim.pack.add({ 'https://github.com/owner/repo' })` then `setup()`.
  Wrap in `Config.later(...)` unless needed at startup; `Config.now_if_args`
  for things needed when a file is passed on the command line.
  Helpers come from MiniMax `init.lua` (`Config.now/later/now_if_args/new_autocmd`).
- Keymaps: `<Leader>` groups are defined by MiniMax in `20_keymaps.lua`
  (`b`uffer, `e`xplore, `f`ind, `g`it, `l`sp, `m`ap, `o`ther, `s`ession,
  `t`erminal, `v`isits). Put new keys in the matching group; `<Leader>o*` is
  the catch-all. Custom git keys live under `<Leader>g*` and `<Leader>h*`
  (hunks); `<Leader>g{a,A,c,C,d,D,o,s}` are reserved no-ops so MiniMax
  updates cannot clash.
- Tree-sitter parsers: add the language to `extra_langs` in `50_custom.lua`.
- LSP: add server file under `after/lsp/` and its name to the
  `vim.lsp.enable({...})` list.
- Neovim 0.12 (`vim.pack`, `vim.lsp.config`). No lazy.nvim, no packer.
- Keep files in English, no emojis.

## Verify

Headless smoke test (replace the checks as needed):

```bash
nvim --headless some.md -c 'lua vim.defer_fn(function() io.write(tostring(package.loaded.gitsigns ~= nil) .. "\n"); vim.cmd("qa!") end, 4000)'
```

`package.loaded.gitsigns == true` proves `50_custom.lua` is linked and loaded.
`later(...)` blocks need the delay; `now` blocks do not.

## Plans

(none yet)
