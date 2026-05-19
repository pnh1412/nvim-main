---@type NvPluginSpec
-- NOTE: Windsurf
return {
  {
    "Exafunction/windsurf.nvim",
    enabled = false,
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup {}
    end,
  },
}
