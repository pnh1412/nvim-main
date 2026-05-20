---@type NvPluginSpec
-- NOTE: Completion Engine

return {
	{
		"saghen/blink.cmp",
		enabled = true,
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		init = function()
			if vim.g.toggle_blink == nil then
				vim.g.toggle_blink = true
			end

			vim.keymap.set("n", "<leader>oa", function()
				vim.g.toggle_blink = not vim.g.toggle_blink
				if vim.g.toggle_blink then
					vim.notify("Toggled On", vim.log.levels.INFO, { title = "Autocomplete" })
				else
					vim.notify("Toggled Off", vim.log.levels.INFO, { title = "Autocomplete" })
				end
			end, { desc = "Options | Toggle Autocomplete" })
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			keymap = {
				preset = "super-tab",
				["<C-space>"] = {
					"show",
					"show_documentation",
					"hide_documentation",
				},
					["<M-;>"] = {
						"show",
						"show_documentation",
						"hide_documentation",
					},
					["<M-c>"] = {
						"show",
						"show_documentation",
						"hide_documentation",
					},
					["<C-e>"] = {
						"cancel",
						"hide",
					"fallback",
				},
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						end

						return cmp.select_and_accept()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					"select_prev",
					"snippet_backward",
					"fallback",
				},
				["<C-n>"] = {
					"select_next",
					"fallback",
				},
				["<C-p>"] = {
					"select_prev",
					"fallback",
				},
				["<Up>"] = {
					"select_prev",
					"fallback",
				},
				["<Down>"] = {
					"select_next",
					"fallback",
				},
				["<C-b>"] = {
					"scroll_documentation_up",
					"fallback",
				},
				["<C-f>"] = {
					"scroll_documentation_down",
					"fallback",
				},
			},
			enabled = function()
				return not vim.tbl_contains({ "DressingInput", "sagarename" }, vim.bo.filetype)
					and vim.g.toggle_blink ~= false
			end,
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				trigger = {
					prefetch_on_insert = true,
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_on_insert = true,
					show_on_insert_on_trigger_character = true,
					show_on_backspace = true,
					show_on_backspace_in_keyword = true,
				},
				menu = {
					border = "rounded",
					auto_show = true,
					auto_show_delay_ms = 0,
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
					},
				},
				ghost_text = {
					enabled = true,
					show_with_menu = true,
					show_without_menu = true,
				},
			},
			cmdline = {
				completion = {
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == ":"
						end,
					},
				},
			},
			sources = {
				default = { "ecolog", "lazydev", "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
					mysql = { "snippets", "dadbod", "buffer" },
					plsql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					lsp = {
						min_keyword_length = 1,
					},
					path = {
						min_keyword_length = 0,
					},
					snippets = {
						min_keyword_length = 1,
					},
					buffer = {
						min_keyword_length = 0,
						max_items = 12,
					},
					ecolog = {
						name = "ecolog",
						module = "ecolog.integrations.cmp.blink_cmp",
					},
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {},
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				build = "make install_jsregexp",
				config = function()
					local luasnip = require("luasnip")
					luasnip.filetype_extend("javascriptreact", { "html" })
					luasnip.filetype_extend("typescriptreact", { "html" })
					luasnip.filetype_extend("svelte", { "html" })
					luasnip.filetype_extend("javascript", { "javascriptreact" })
					luasnip.filetype_extend("typescript", { "typescriptreact" })

					local vscode_loader = require("luasnip.loaders.from_vscode")
					vscode_loader.lazy_load()
					vscode_loader.load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
			{
				"Kaiser-Yang/blink-cmp-avante",
			},
			{
				"ph1losof/ecolog.nvim",
				opts = {
					integrations = {
						blink_cmp = true,
					},
				},
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			disable_filetype = {
				"TelescopePrompt",
				"snacks_picker_input",
				"vim",
			},
			fast_wrap = {},
		},
	},
}
