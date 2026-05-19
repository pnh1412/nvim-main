-- ~/.config/nvim/lua/plugins/ui/notify.lua

return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      -- ── Appearance ──────────────────────────────────────────────────────
      render          = "wrapped-compact", -- "default" | "minimal" | "compact" | "wrapped-compact"
      stages          = "fade",            -- "fade" | "slide" | "fade_in_slide_out" | "static"
      background_colour = "#000000",
      on_open         = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,

      -- ── Timing ──────────────────────────────────────────────────────────
      timeout   = 3000,   
      fps       = 60,     -- animation frame rate

      -- ── Size ────────────────────────────────────────────────────────────
      max_width  = function() return math.floor(vim.o.columns * 0.4) end,
      max_height = function() return math.floor(vim.o.lines   * 0.4) end,
      minimum_width = 20,

      -- ── Icons theo level ────────────────────────────────────────────────
      icons = {
        ERROR = " ",
        WARN  = " ",
        INFO  = " ",
        DEBUG = " ",
        TRACE = "✎ ",
      },

      -- ── Level tối thiểu để hiện (trace < debug < info < warn < error) ──
      level = vim.log.levels.INFO,

      -- ── Vị trí hiện notification ────────────────────────────────────────
      top_down = false,   -- false = xuất hiện từ dưới lên (góc dưới phải)
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)

      -- Override vim.notify mặc định → dùng nvim-notify
      vim.notify = notify

      -- ── Keymap xem lại notification history ───────────────────────────
      vim.keymap.set("n", "<leader>nn", function()
        require("telescope").extensions.notify.notify()
      end, { desc = "Notification History" })

      vim.keymap.set("n", "<leader>nd", function()
        notify.dismiss({ silent = true, pending = true })
      end, { desc = "Dismiss All Notifications" })
    end,
  },
}
