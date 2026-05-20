---@type NvPluginSpec
-- NOTE: Note Taking
return {
  {
    "nvim-neorg/neorg",
    -- lazy = false,
    ft = { "norg" },
    version = "*",
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
    ft = { "norg" },
  },
  {
    "nvim-neorg/tree-sitter-norg-meta",
    ft = { "norg" },
  },
}
