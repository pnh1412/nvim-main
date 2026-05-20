-- NOTE: Keymaps Popup/Guide
return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "", -- symbol prepended to a group
			},
			preset = "classic",
			win = {
				border = vim.g.border_enabled and "rounded" or "none",
				no_overlap = false,
			},
			delay = function()
				return 0
			end,
		},
		config = function(_, opts)
			require("which-key").setup(opts)
			require("which-key").add({
				{
					{ "<leader>s", group = "Sessions", icon = "󰔚" },
					{ "<leader>a", group = "AI", icon = "" },
					{ "<leader>d", group = "Debugging", icon = "" },
					{ "<leader>D", group = "Database", icon = "󰆼" },
					{ "<leader>f", group = "Find", icon = "" },
					{ "<leader>g", group = "Git", icon = "󰊢" },
					{ "<leader>gC", group = "CodeDiff", icon = "" },
					{ "<leader>h", group = "Harpoon", icon = "" },
					{ "<leader>H", group = "HTTP", icon = "" },
					{ "<leader>l", group = "LSP", icon = "" },
					{ "<leader>L", group = "Lazygit", icon = "󰫐" },
					{ "<leader>M", group = "Match Replace", icon = "󰛔" },
					{ "<leader>m", group = "Markdown", icon = "" },
					{ "<leader>n", group = "Neovim", icon = "" },
					{ "<leader>np", group = "Package", icon = "" },
					{ "<leader>o", group = "Options", icon = "" },
					{ "<leader>p", group = "Plugins", icon = "" },
					{ "<leader>r", group = "Runner", icon = "" },
					{ "<leader>t", group = "Terminal", icon = "" },
					{ "<leader>T", group = "Trouble", icon = "" },
					{ "<leader>v", group = "Venv", icon = "" },
					{ "<leader>w", group = "Web", icon = "󰖟" },
					{ "<leader>x", group = "Tests", icon = "󰙨" },
				},
			})
		end,
	},
}
