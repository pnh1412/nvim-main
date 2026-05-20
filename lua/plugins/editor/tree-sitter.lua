-- NOTE: Treesitter Configuration
return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = {
			"TSInstall",
			"TSInstallConfigured",
			"TSUpdate",
			"TSUninstall",
		},
		build = ":TSUpdate",
		config = function()
			local ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"graphql",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"scss",
				"sql",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			vim.api.nvim_create_user_command("TSInstallConfigured", function()
				require("nvim-treesitter").install(ensure_installed)
			end, { desc = "Install configured Treesitter parsers" })

			local function start_treesitter(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype == "" then
					return
				end

				local file = vim.api.nvim_buf_get_name(bufnr)
				local ok, stats = pcall(vim.uv.fs_stat, file)
				if ok and stats and stats.size > 100 * 1024 then
					return
				end

				pcall(vim.treesitter.start, bufnr)

				if not vim.tbl_contains({ "python", "yaml" }, vim.bo[bufnr].filetype) then
					vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
				callback = function(args)
					start_treesitter(args.buf)
				end,
			})

			start_treesitter(vim.api.nvim_get_current_buf())
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local select = require("nvim-treesitter-textobjects.select")
			local swap = require("nvim-treesitter-textobjects.swap")
			local move = require("nvim-treesitter-textobjects.move")

			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select_maps = {
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
				aa = "@parameter.outer",
				ia = "@parameter.inner",
				ai = "@conditional.outer",
				ii = "@conditional.inner",
				al = "@loop.outer",
				il = "@loop.inner",
				at = "@comment.outer",
				it = "@comment.inner",
				as = "@statement.outer",
				["is"] = "@statement.inner",
				aw = "@word.outer",
			}

			for lhs, query in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end, { desc = "Treesitter select " .. query })
			end

			vim.keymap.set("n", "]A", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Treesitter swap next parameter" })

			vim.keymap.set("n", "[A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Treesitter swap previous parameter" })

			local next_start = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
				["]a"] = "@parameter.inner",
				["]p"] = "@parameter.outer",
				["]i"] = "@conditional.inner",
				["]l"] = "@loop.inner",
			}

			local previous_start = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[a"] = "@parameter.inner",
				["[p"] = "@parameter.outer",
				["[i"] = "@conditional.inner",
				["[l"] = "@loop.inner",
			}

			for lhs, query in pairs(next_start) do
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					move.goto_next_start(query, "textobjects")
				end, { desc = "Treesitter next start " .. query })
			end

			for lhs, query in pairs(previous_start) do
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					move.goto_previous_start(query, "textobjects")
				end, { desc = "Treesitter previous start " .. query })
			end

			vim.keymap.set({ "n", "x", "o" }, "]F", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Treesitter next function end" })

			vim.keymap.set({ "n", "x", "o" }, "]C", function()
				move.goto_next_end("@class.outer", "textobjects")
			end, { desc = "Treesitter next class end" })

			vim.keymap.set({ "n", "x", "o" }, "[F", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Treesitter previous function end" })

			vim.keymap.set({ "n", "x", "o" }, "[C", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Treesitter previous class end" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			max_lines = 3,
			trim_scope = "outer",
		},
	},
}
