return {
  cmd = { "helm_ls", "serve" },
  filetypes = { "helm" },
  root_markers = { "Chart.yaml" },
  settings = {
    ["helm-ls"] = {
      logLevel = "info",
      valuesFiles = {
        mainValuesFile = "values.yaml",
        additionalValuesFilesGlobPattern = "values*.yaml",
      },
      helmLint = { enabled = true },
      yamlls = {
        enabled = true,
        path = "yaml-language-server",
        config = {
          schemas = { kubernetes = "templates/**" },
          completion = true,
          hover = true,
        },
      },
    },
  },
}
