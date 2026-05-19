return {
  -- Theme Manager
  {
    "flashcodes-themayankjha/fkthemes.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Setup fkthemes trước
      require("fkthemes").setup({
        themes = {
          "tokyonight",
          "catppuccin",
          "gruvbox",
          "everblush",
          "nightfly",
          "everforest",
          "kanagawa",
          "ayu",
          "solarized-osaka",
          "rose-pine",
          "gruvbox-material",
        },
        default_theme = "catppuccin",
        transparent_background = false,
      })

      -- Danh sách themes
      local themes = {
        "tokyonight-night",
        "tokyonight-storm",
        "tokyonight-moon",
        "catppuccin-frappe",
        "catppuccin-macchiato",
        "catppuccin-mocha",
        "gruvbox",
        "everblush",
        "nightfly",
        "everforest",
        "kanagawa",
        "ayu",
        "solarized-osaka",
        "rose-pine",
        "gruvbox-material",
        "nightSyscall",
        "daySyscall"
      }

      -- Custom Telescope Theme Picker với Live Preview
      local telescope_theme_picker = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        -- Lưu theme hiện tại để restore nếu ESC
        local current_theme = vim.g.colors_name

        pickers
          .new(
            require("telescope.themes").get_dropdown({
              prompt_title = "🎨 Select Theme (Live Preview)",
              previewer = false,
              layout_config = {
                width = 0.35,
                height = 0.5,
              },
            }),
            {
              finder = finders.new_table({
                results = themes,
              }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                -- Live preview khi di chuyển cursor
                local function preview_theme()
                  local selection = action_state.get_selected_entry()
                  if selection then
                    vim.cmd("colorscheme " .. selection[1])
                    pcall(function()
                      require("lualine").refresh()
                    end)
                  end
                end

                -- Apply theme khi nhấn Enter
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  -- Theme đã được apply rồi, không cần làm gì thêm
                end)

                -- Restore theme cũ khi nhấn ESC
                local function restore_theme()
                  if current_theme then
                    vim.cmd("colorscheme " .. current_theme)
                    pcall(function()
                      require("lualine").refresh()
                    end)
                  end
                  actions.close(prompt_bufnr)
                end

                map("i", "<CR>", actions.select_default)
                map("i", "<Esc>", restore_theme)
                map("n", "<CR>", actions.select_default)
                map("n", "<Esc>", restore_theme)
                map("n", "q", restore_theme)

                map("i", "<Down>", function()
                  actions.move_selection_next(prompt_bufnr)
                  preview_theme()
                end)
                map("i", "<Up>", function()
                  actions.move_selection_previous(prompt_bufnr)
                  preview_theme()
                end)
                map("n", "j", function()
                  actions.move_selection_next(prompt_bufnr)
                  preview_theme()
                end)
                map("n", "k", function()
                  actions.move_selection_previous(prompt_bufnr)
                  preview_theme()
                end)
                map("n", "<Down>", function()
                  actions.move_selection_next(prompt_bufnr)
                  preview_theme()
                end)
                map("n", "<Up>", function()
                  actions.move_selection_previous(prompt_bufnr)
                  preview_theme()
                end)

                return true
              end,
            }
          )
          :find()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>[", telescope_theme_picker, { desc = "Theme Picker (Telescope)" })
    end,
  },

  -- Catppuccin Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        flavour = "mocha",
        no_italic = false,
        term_colors = true,
        transparent_background = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = { "italic" },
          functions = {},
          keywords = { "italic" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = { "italic" },
        },
        integrations = {
          cmp = true,
          markdown = true,
          mason = true,
          mini = { enabled = true },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = {},
              hints = {},
              warnings = {},
              information = {},
              ok = {},
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
              ok = { "underline" },
            },
            inlay_hints = { background = true },
          },
          semantic_tokens = true,
          telescope = {
            enabled = true,
            style = "nvchad",
          },
          treesitter = true,
          treesitter_context = true,
        },
        highlight_overrides = {
          all = function(colors)
            return {
              Folded = { bg = colors.surface0 },
              Comment = { fg = colors.overlay0, style = { "italic" } },
              RenderMarkdownCodeBorder = { bg = colors.surface0 },
              RenderMarkdownCode = { bg = colors.mantle },
              RenderMarkdownTableHead = { fg = colors.overlay0 },
              RenderMarkdownTableRow = { fg = colors.overlay0 },
              ["@markup.quote"] = { fg = colors.maroon, style = { "italic" } },
              ["@keyword"] = { style = { "italic" } },
              ["@keyword.conditional"] = { style = { "italic" } },
              ["@keyword.repeat"] = { style = { "italic" } },
              ["@keyword.return"] = { style = { "italic" } },
              ["@type"] = { style = { "italic" } },
            }
          end,
          mocha = function(colors)
            local overrides = {
              Headline = { style = { "bold" } },
              FloatTitle = { fg = colors.green },
              WinSeparator = { fg = colors.surface1, style = { "bold" } },
              CursorLineNr = { fg = colors.lavender, style = { "bold" } },
              MsgArea = { fg = colors.overlay2 },
              CmpItemAbbrMatch = { fg = colors.green, style = { "bold" } },
              CmpItemAbbrMatchFuzzy = { fg = colors.green, style = { "bold" } },
              MiniFilesCursorLine = { fg = nil, bg = colors.surface0, style = { "bold" } },
              ["@parameter"] = { fg = colors.maroon, style = { "italic" } },
              ["@variable.parameter"] = { fg = colors.maroon, style = { "italic" } },
            }
            for _, hl in ipairs({ "Headline", "rainbow" }) do
              for i, c in ipairs({ "green", "sapphire", "mauve", "peach", "red", "yellow" }) do
                overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
              end
            end
            return overrides
          end,
          macchiato = function(colors)
            local overrides = {
              CurSearch = { bg = colors.peach },
              CursorLineNr = { fg = colors.blue, style = { "bold" } },
              IncSearch = { bg = colors.peach },
              MsgArea = { fg = colors.overlay1 },
              Search = { bg = colors.mauve, fg = colors.base },
              TreesitterContext = { bg = colors.surface0 },
              TreesitterContextBottom = { sp = colors.surface1, style = { "underline" } },
              WinSeparator = { fg = colors.surface1, style = { "bold" } },
              ["@constructor.lua"] = { fg = colors.pink },
            }
            for _, hl in ipairs({ "Headline", "rainbow" }) do
              for i, c in ipairs({ "blue", "pink", "lavender", "green", "peach", "flamingo" }) do
                overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
              end
            end
            return overrides
          end,
        },
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
          macchiato = {
            rosewater = "#F5B8AB",
            flamingo = "#F29D9D",
            pink = "#AD6FF7",
            mauve = "#FF8F40",
            red = "#E66767",
            maroon = "#EB788B",
            peach = "#FAB770",
            yellow = "#FACA64",
            green = "#70CF67",
            teal = "#4CD4BD",
            sky = "#61BDFF",
            sapphire = "#4BA8FA",
            blue = "#00BFFF",
            lavender = "#00BBCC",
            text = "#C1C9E6",
            subtext1 = "#A3AAC2",
            subtext0 = "#8E94AB",
            overlay2 = "#7D8296",
            overlay1 = "#676B80",
            overlay0 = "#464957",
            surface2 = "#3A3D4A",
            surface1 = "#2F313D",
            surface0 = "#1D1E29",
            base = "#0b0b12",
            mantle = "#11111a",
            crust = "#191926",
          },
        },
      }
    end,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Other Themes
  { "morhetz/gruvbox" },
  { "Everblush/nvim", name = "everblush" },
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
    config = function()
      vim.g.nightflyItalics = true
      vim.g.nightflyCursorColor = true
      vim.g.nightflyNormalFloat = true
      vim.g.nightflyWinSeparator = 2
    end,
  },
  { "folke/tokyonight.nvim" },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = "soft"
    end,
  },
  { "rebelot/kanagawa.nvim" },
  { "Shatur/neovim-ayu" },
  { "craftzdog/solarized-osaka.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "sainnhe/gruvbox-material" },
  {
  "initsyscall/themeInitNvim",
  url = "https://codeberg.org/initsyscall/themeInitNvim",
  },
}
