-- NOTE: For Flutter Development
return {
  "akinsho/flutter-tools.nvim",
  ft = "dart",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  opts = {
    lsp = {
      on_attach = function(client, bufnr)
        require("config.lsp").on_attach(client, bufnr)
      end,
      capabilities = function()
        return require("config.lsp").capabilities
      end,
    },
    setting = {
      analysisExcludedFolders = {
        vim.g.is_windows and vim.fn.expand "$HOME/AppData/Local/Pub/Cache" or nil,
      },
    },
  },
}
