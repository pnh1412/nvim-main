---@type NvPluginSpec
-- NOTE: Manage Projects
return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    -- project.nvim still calls the deprecated/removed vim.lsp.buf_get_clients().
    -- Keep the plugin working on newer Neovim by routing that legacy API to
    -- vim.lsp.get_clients({ bufnr = ... }) without patching files in lazy/.
    vim.lsp.buf_get_clients = function(bufnr)
      local clients = vim.lsp.get_clients({ bufnr = bufnr or 0 })
      local by_id = {}

      for _, client in ipairs(clients) do
        by_id[client.id] = client
      end

      return by_id
    end

    require("project_nvim").setup(opts)
  end,
  opts = {
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearangne the detection methods.
    detection_methods = { "pattern", "lsp" },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    patterns = {
      ".git",
      "Cargo.toml",
      "*.cfg",
      "CMakeLists.txt",
      "build.zig",
      ".vscode",
      ".svn",
      "Makefile",
    },

    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    ignore_lsp = {},

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {},

    -- Show hidden files in telescope
    show_hidden = false,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = "global",

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath "data",
  },
}
