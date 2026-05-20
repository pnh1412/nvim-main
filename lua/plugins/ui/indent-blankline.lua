return {
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local exclude_ft = {
				help = true,
				git = true,
				markdown = true,
				snippets = true,
				text = true,
				gitconfig = true,
				alpha = true,
				dashboard = true,
				["neo-tree"] = true,
				lspinfo = true,
				mason = true,
				lazy = true,
				trouble = true,
				Trouble = true,
				man = true,
				notify = true,
			}
			require("hlchunk").setup({
				chunk = {
					enable = true,
					exclude_filetypes = exclude_ft,
				},
				line_num = {
					enable = true,
					exclude_filetypes = exclude_ft,
				},
				indent = {
					enable = true,
					chars = { "┊" },
					exclude_filetypes = exclude_ft,
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		enabled = false,
		event = "VeryLazy",
		opts = {
			symbol = "▏",
			-- symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"alpha",
					"dashboard",
					"fzf",
					"help",
					"lazy",
					"lazyterm",
					"mason",
					"neo-tree",
					"notify",
					"toggleterm",
					"Trouble",
					"trouble",
					"man",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
