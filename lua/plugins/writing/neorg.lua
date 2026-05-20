---@type NvPluginSpec
-- NOTE: Note Taking
return {
  {
    "nvim-neorg/neorg",
    -- lazy = false,
    ft = { "norg" },
    version = "*",
    dependencies = {
      "nvim-neorg/tree-sitter-norg",
      "nvim-neorg/tree-sitter-norg-meta",
    },
    opts = {
      load = {
        ["core.defaults"] = {},                                                     -- Loads default behaviour
        ["core.concealer"] = { config = { folds = true, icon_preset = "varied" } }, -- Adds pretty icons to your documents
        ["core.keybinds"] = {
          config = {
            neorg_leader = ",",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
          },
        },
      },
    },
  },
  {
    "nvim-neorg/tree-sitter-norg",
    lazy = true,
    ft = { "norg" },
  },
  {
    "nvim-neorg/tree-sitter-norg-meta",
    lazy = true,
    ft = { "norg" },
  },
}
