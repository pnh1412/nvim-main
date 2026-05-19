local function reveal_current_file()
  local path = vim.fn.expand("%:p")
  local stat = path ~= "" and vim.uv.fs_stat(path) or nil

  if not stat then
    path = vim.fn.getcwd()
    stat = vim.uv.fs_stat(path)
  end

  local dir = path
  local reveal_file = nil

  if stat and stat.type ~= "directory" then
    dir = vim.fn.fnamemodify(path, ":h")
    reveal_file = path
  end

  require("neo-tree.command").execute({
    toggle = true,
    dir = dir,
    reveal_file = reveal_file,
  })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  cmd = "Neotree",
  keys = {
    {
      "\\",
      reveal_current_file,
      desc = "NeoTree reveal",
      silent = true,
    },
    {
      "<leader>e",
      reveal_current_file,
      desc = "Neo-tree",
      silent = true,
    },
  },
  opts = {
    window = {
      width = 30,
    },
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        { source = "document_symbols" },
        { source = "git_status" },
      },
    },
    filesystem = {
      bind_to_cwd = false,
      cwd_target = {
        sidebar = "none",
        current = "none",
      },
      filtered_items = {
        hide_by_name = {
          "node_modules",
        },
        visible = true,
        hide_gitignored = false,
        hide_hidden = false,
        hide_dotfiles = false,
      },
      use_libuv_file_watcher = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ["\\"] = "close_window",
        },
      },
    },
    default_component_configs = {
      name = {
        highlight_opened_files = "all",
      },
    },
    auto_clean_after_session_restore = true,
    popup_border_style = "rounded",
    sources = {
      "filesystem",
      "buffers",
      "document_symbols",
      "git_status",
    },
    close_if_last_window = true,
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bold = true, underline = true })
    require("neo-tree").setup(opts)
  end,
}
