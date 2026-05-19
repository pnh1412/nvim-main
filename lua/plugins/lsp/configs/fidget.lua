---@type NvPluginSpec
-- NOTE: LSP Progress Indicator
return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  tag = "legacy",
  opts = {
    notification = {
      window = {
        winblend = 0,
      },
      override_vim_notify = true,
    },
    sources = {
      ["null-ls"] = {
        ignore = true,
      },
    },
  },
}
