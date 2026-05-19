---@type NvPluginSpec
-- NOTE: Linting
return {
	"mfussenegger/nvim-lint",
	enabled = function()
		return not vim.g.no_ide
	end,
	event = {
		"BufReadPost",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			go = { "golangcilint" },
			dockerfile = { "hadolint" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			yaml = { "yamllint" },
			sql = { "sqlfluff" },
			lua = { "luacheck" },
		}

		local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = group,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
