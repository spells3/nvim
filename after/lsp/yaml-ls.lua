return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git", ".yamllint" },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(fname)
    -- Если вверх по дереву есть Chart.yaml — это helm, yamlls off
    local chart = vim.fs.find("Chart.yaml", {
      upward = true,
      path = dir,
      stop = vim.loop.os_homedir(),
    })
    if #chart > 0 then
      return nil
    end
    local root = vim.fs.root(bufnr, { ".git", ".yamllint" })
    on_dir(root)
  end,

  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = "*.k8s.yaml",
      },
    },
  },
}
