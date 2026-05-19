return {
  {
    "kevinhwang91/nvim-bqf",
    event = "QuickFixCmdPost",
    opts = {
      auto_enable = true,
      preview = {
        auto_preview = true,
        show_title   = true,
        show_scroll_bar = true,
        win_height   = 15,
        win_vheight  = 15,
        delay_syntax = 80,
        wrap         = false,
      },
      filter = {
        fzf = {
          action_for = {
            ["ctrl-t"] = "tabedit",
            ["ctrl-v"] = "vsplit",
            ["ctrl-s"] = "split",
            ["ctrl-q"] = "signtoggle",
          },
          extra_opts = { "--bind", "ctrl-o:toggle-all" },
        },
      },
    },
  },
}