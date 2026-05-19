-- ~/.config/nvim/lua/plugins/ui/statusline.lua

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local function palette()
        local ok, palettes = pcall(require, "catppuccin.palettes")
        if ok then
          return palettes.get_palette("mocha")
        end

        return {
          base = "#000000",
          mantle = "#000000",
          surface0 = "#313244",
          surface1 = "#45475a",
          overlay0 = "#6c7086",
          overlay1 = "#7f849c",
          text = "#cdd6f4",
          lavender = "#b4befe",
          blue = "#89b4fa",
          sapphire = "#74c7ec",
          sky = "#89dceb",
          teal = "#94e2d5",
          green = "#a6e3a1",
          yellow = "#f9e2af",
          peach = "#fab387",
          maroon = "#eba0ac",
          red = "#f38ba8",
          mauve = "#cba6f7",
        }
      end

      local colors = palette()
      local status_bg = colors.base
      local status_theme = {
        normal = {
          a = { fg = colors.mauve, bg = status_bg, gui = "bold" },
          b = { fg = colors.text, bg = status_bg },
          c = { fg = colors.text, bg = status_bg },
        },
        insert = {
          a = { fg = colors.green, bg = status_bg, gui = "bold" },
          b = { fg = colors.text, bg = status_bg },
          c = { fg = colors.text, bg = status_bg },
        },
        visual = {
          a = { fg = colors.peach, bg = status_bg, gui = "bold" },
          b = { fg = colors.text, bg = status_bg },
          c = { fg = colors.text, bg = status_bg },
        },
        replace = {
          a = { fg = colors.red, bg = status_bg, gui = "bold" },
          b = { fg = colors.text, bg = status_bg },
          c = { fg = colors.text, bg = status_bg },
        },
        command = {
          a = { fg = colors.yellow, bg = status_bg, gui = "bold" },
          b = { fg = colors.text, bg = status_bg },
          c = { fg = colors.text, bg = status_bg },
        },
        inactive = {
          a = { fg = colors.overlay1, bg = status_bg },
          b = { fg = colors.overlay1, bg = status_bg },
          c = { fg = colors.overlay1, bg = status_bg },
        },
      }

      local function hide_in_width()
        return vim.o.columns > 100
      end

      local function mode_color()
        local mode = vim.fn.mode()
        if mode:match("^[iR]") then
          return { fg = colors.green, bg = status_bg, gui = "bold" }
        end
        if mode:match("^[vV\22]") then
          return { fg = colors.peach, bg = status_bg, gui = "bold" }
        end
        if mode:match("^c") then
          return { fg = colors.yellow, bg = status_bg, gui = "bold" }
        end
        return { fg = colors.mauve, bg = status_bg, gui = "bold" }
      end

      local function readonly()
        if vim.bo.readonly or not vim.bo.modifiable then
          return ""
        end
        return ""
      end

      local function file_size()
        local file = vim.fn.expand("%:p")
        if file == "" then
          return ""
        end

        local size = vim.fn.getfsize(file)
        if size <= 0 then
          return ""
        end

        local units = { "B", "K", "M", "G" }
        local idx = 1
        while size > 1024 and idx < #units do
          size = size / 1024
          idx = idx + 1
        end

        if idx == 1 then
          return string.format("%d%s", size, units[idx])
        end
        return string.format("%.1f%s", size, units[idx])
      end

      local function cwd()
        local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        if name == "" then
          return ""
        end
        return "󰉋 " .. name
      end

      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return " none"
        end

        local names = {}
        local excluded = {
          ["copilot"] = true,
          ["null-ls"] = true,
        }

        for _, client in ipairs(clients) do
          if not excluded[client.name] then
            table.insert(names, client.name)
          end
        end

        if #names == 0 then
          return " none"
        end

        table.sort(names)
        return " " .. table.concat(names, ",")
      end

      local function format_state()
        if vim.g.disable_autoformat or vim.b.disable_autoformat then
          return "󰉿 off"
        end
        return "󰉿 on"
      end

      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "󰑋 @" .. reg
      end

      local function search_count()
        if vim.v.hlsearch == 0 then
          return ""
        end

        local ok, count = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
        if not ok or count.total == 0 then
          return ""
        end

        return string.format(" %d/%d", count.current, count.total)
      end

      local function selection_count()
        local mode = vim.fn.mode()
        if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
          return ""
        end

        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        local lines = math.abs(end_line - start_line) + 1
        return "󰈈 " .. lines .. "L"
      end

      local function dap_status()
        local ok, dap = pcall(require, "dap")
        if not ok then
          return ""
        end

        local status = dap.status()
        if status == "" then
          return ""
        end
        return " " .. status
      end

      -- ── Scrollbar ─────────────────────────────────────────────────────────
      local function scrollbar()
        local blocks = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local curr = vim.fn.line(".")
        local total = vim.fn.line("$")
        local pct = math.floor(curr / total * 100)
        local idx = math.max(1, math.ceil(curr / total * #blocks))
        return blocks[idx] .. " " .. pct .. "%%"
      end

      -- ── Setup ─────────────────────────────────────────────────────────────
      require("lualine").setup({
        options = {
          theme = status_theme,
          globalstatus = true,
          always_divide_middle = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "│", right = "│" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter", "lazy" },
          },
        },

        sections = {

          -- ── Trái ──────────────────────────────────────────────────────────
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str
              end,
              color = mode_color,
              padding = { left = 1, right = 1 },
            },
          },

          lualine_b = {
            {
              "branch",
              icon = "",
              color = { fg = colors.sky, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              "diff",
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red },
              },
              cond = hide_in_width,
            },
          },

          lualine_c = {
            {
              cwd,
              color = { fg = colors.green, gui = "bold" },
              cond = hide_in_width,
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ●",
                readonly = "",
                unnamed = " No Name",
              },
              color = { fg = colors.text, gui = "bold" },
            },
            {
              readonly,
              color = { fg = colors.red, gui = "bold" },
              padding = { left = 0, right = 1 },
            },
            {
              "diagnostics",
              sources = { "nvim_lsp", "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰌵 ",
              },
              diagnostics_color = {
                error = { fg = colors.red },
                warn = { fg = colors.yellow },
                info = { fg = colors.sky },
                hint = { fg = colors.teal },
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
            },
            {
              macro_recording,
              color = { fg = colors.red, gui = "bold" },
            },
            {
              search_count,
              color = { fg = colors.peach, gui = "bold" },
            },
            {
              selection_count,
              color = { fg = colors.mauve, gui = "bold" },
            },
          },

          -- ── Phải ──────────────────────────────────────────────────────────
          lualine_x = {
            {
              dap_status,
              color = { fg = colors.red, gui = "bold" },
              cond = hide_in_width,
            },
            {
              lsp_clients,
              color = { fg = colors.teal, gui = "bold" },
              cond = hide_in_width,
            },
            {
              format_state,
              color = function()
                if vim.g.disable_autoformat or vim.b.disable_autoformat then
                  return { fg = colors.overlay1, gui = "bold" }
                end
                return { fg = colors.green, gui = "bold" }
              end,
              cond = hide_in_width,
            },
            {
              file_size,
              color = { fg = colors.mauve, gui = "bold" },
              cond = hide_in_width,
            },
            {
              "encoding",
              fmt = string.lower,
              color = { fg = colors.lavender, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              "fileformat",
              symbols = {
                unix = "",
                dos = "",
                mac = "",
              },
              color = { fg = colors.sapphire, gui = "bold" },
              padding = { left = 0, right = 1 },
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              color = { fg = colors.yellow, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
          },

          lualine_y = {
            {
              "progress",
              color = { fg = colors.yellow, bg = status_bg, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
          },

          lualine_z = {
            {
              "location",
              color = { fg = colors.sky, bg = status_bg, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              scrollbar,
              color = { fg = colors.red, bg = status_bg, gui = "bold" },
              padding = { left = 0, right = 1 },
            },
          },
        },

        -- ── Inactive ──────────────────────────────────────────────────────
        inactive_sections = {
          lualine_a = {},
          lualine_b = { { "branch", icon = "" } },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },

        extensions = {
          "neo-tree",
          "toggleterm",
          "trouble",
          "lazy",
          "mason",
          "quickfix",
        },
      })
    end,
  },
}
