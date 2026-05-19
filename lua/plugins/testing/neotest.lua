---@type NvPluginSpec
-- NOTE: Tests
return {
	"nvim-neotest/neotest",
	keys = {
		{
			"<leader>xr",
			function()
				require("neotest").run.run()
			end,
			desc = "Test | Run nearest",
		},
		{
			"<leader>xf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test | Run file",
		},
		{
			"<leader>xw",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Test | Run workspace",
		},
		{
			"<leader>xd",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Test | Debug nearest",
		},
		{
			"<leader>xs",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test | Summary",
		},
		{
			"<leader>xo",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Test | Output",
		},
		{
			"<leader>xO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Test | Output panel",
		},
		{
			"<leader>xS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Test | Stop",
		},
	},
	dependencies = {
		"nvim-neotest/neotest-python",
		-- "nvim-neotest/neotest-go", -- does not support monorepos where go.mod is not in root
		-- "marilari88/neotest-vitest",
		-- "nvim-neotest/neotest-jest",
		-- "rouge8/neotest-rust",
		-- "rcasia/neotest-java",
		"orjangj/neotest-ctest",
		"nvim-treesitter/nvim-treesitter",
		-- extra dependencies for golang debugging with suppport for monorepos
		-- ref https://github.com/fredrikaverpil/neotest-golang/?tab=readme-ov-file#example-configuration-debugging
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		{
			"fredrikaverpil/neotest-golang", -- Installation
			dependencies = {
				{
					"leoluz/nvim-dap-go",
					opts = {},
				},
			},
		},
	},
	config = function()
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					return diagnostic.message:gsub("[\r\n\t%s]+", " ")
				end,
			},
		}, neotest_ns)

		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					runner = "pytest",
				}),
				require("neotest-golang"), -- Registration
				require("neotest-ctest"),
			},
		})

		require("neotest-ctest").setup({
			root = function(dir)
				return require("neotest.lib").files.match_root_pattern(
					"CMakePresets.json",
					"compile_commands.json",
					".clangd",
					".clang-format",
					".clang-tidy",
					"build",
					"out",
					".git"
				)(dir)
			end,
			frameworks = { "gtest", "catch2", "doctest" },
			extra_args = {},
		})
	end,
}
