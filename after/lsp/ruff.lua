return {
  cmd = { 'ruff', 'server', '--preview' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.git' },

  on_attach = function(client, bufnr)
    -- Отключаем у ruff hover/completion, чтобы ty их предоставлял
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.completionProvider = nil
  end,
}
