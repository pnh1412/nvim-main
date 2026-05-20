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
		local function available(...)
			local linters = {}

			for _, linter in ipairs({ ... }) do
				if vim.fn.executable(linter) == 1 then
					table.insert(linters, linter)
				end
			end

			return linters
		end

		lint.linters_by_ft = {
			javascript = available("quick-lint-js", "typos", "eslint_d"),
			javascriptreact = available("quick-lint-js", "typos", "eslint_d"),
			typescript = available("typos", "eslint_d"),
			typescriptreact = available("typos", "eslint_d"),
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
