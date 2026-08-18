local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Reclaim <Leader>g keys from 20_keymaps.lua (mini.git / mini.diff block).
-- Those mappings are commented out in MiniMax but the xmap 'gs' is active
-- and references MiniGit which is not set up. Delete it and pre-claim all
-- keys this config uses so a future MiniMax update cannot override them.
Config.now(function()
  -- active in 20_keymaps.lua but MiniGit is not set up
  pcall(vim.keymap.del, 'x', '<Leader>gs')

  -- commented out in 20_keymaps.lua; claim them so an upstream uncomment
  -- cannot conflict with the custom git workflow below
  local noop = function() end
  local keys = { 'ga', 'gA', 'gc', 'gC', 'gd', 'gD', 'go', 'gs' }
  for _, k in ipairs(keys) do
    vim.keymap.set('n', '<Leader>' .. k, noop, { desc = 'reserved (custom git)' })
  end
end)

-- Tree-sitter: additional languages on top of MiniMax defaults
now_if_args(function()
  local extra_langs = { 'yaml', 'python', 'gotmpl', 'helm' }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, extra_langs)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(extra_langs) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter (custom langs)')
end)

-- LSP: lua_ls custom on_attach (reduce noisy completion triggers)
vim.lsp.config('lua_ls', {
  on_attach = function(client, _)
    client.server_capabilities.completionProvider.triggerCharacters =
      { '.', ':', '#', '(' }
  end,
})

-- LSP: enable servers beyond lua_ls
now_if_args(function()
  vim.lsp.enable({ 'helm_ls', 'yamlls', 'ty', 'ruff' })
end)

-- Terminal
now_if_args(function()
  add({ 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({})
end)

-- Git: file history, blame, lazygit
vim.pack.add({
  -- diffview: просмотр истории файла по коммитам
  'https://github.com/sindrets/diffview.nvim',

  -- gitsigns: blame по строке, ханки, stage
  'https://github.com/lewis6991/gitsigns.nvim',

  -- lazygit: floating window
  { src = 'https://github.com/kdheepak/lazygit.nvim', depends = { 'https://github.com/nvim-lua/plenary.nvim' } },
})

-- diffview
require('diffview').setup({
  view = {
    merge_tool = { layout = 'diff3_mixed' },
  },
})

-- gitsigns
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 200,
    virt_text_pos = 'eol',
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', gs.next_hunk, 'Next hunk')
    map('n', '[c', gs.prev_hunk, 'Prev hunk')
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>hb', gs.blame_line, 'Blame line')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hd', gs.diffthis, 'Diff this')
    map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff this ~')
  end,
})

-- lazygit.nvim
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_scaling_factor = 0.9

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGit current file' })
vim.keymap.set('n', '<leader>gl', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'LazyGit file log' })

-- diffview keys
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history (commits)' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Project history' })
vim.keymap.set('n', '<leader>gx', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' })

-- Helm: auto-detect yaml files inside a Helm chart and set filetype to helm
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('HelmOverride', { clear = true }),
  pattern = 'yaml',
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname == '' then return end
    local chart = vim.fs.find('Chart.yaml', {
      upward = true,
      path = vim.fs.dirname(bufname),
      stop = vim.loop.os_homedir(),
    })
    if #chart > 0 then vim.bo[args.buf].filetype = 'helm' end
  end,
})

-- Helm: lint keybinding and quickfix settings
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('HelmLint', { clear = true }),
  pattern = 'helm',
  callback = function()
    vim.opt_local.makeprg = 'helm lint .'
    vim.opt_local.errorformat = '%f:%l:%c: %tRROR %m,%f:%l:%c: %tARN %m'
    vim.keymap.set('n', '<leader>hl', ':make<CR>', { buffer = true, desc = 'Helm lint' })
  end,
})
