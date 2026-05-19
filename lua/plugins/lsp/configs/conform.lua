local formatters_by_ft = {
	php = { "pint" },
	blade = { "blade-formatter" },
	lua = { "stylua" },
	python = { "ruff_format", "ruff_fix" },
	cpp = { "clang_format" },
	c = { "clang_format" },
	go = { "gofumpt" },
	cs = { "csharpier" },
	yaml = { "prettier" },
	css = { "prettier" },
	flow = { "prettier" },
	graphql = { "prettier" },
	html = { "prettier" },
	json = { "prettier" },
	javascriptreact = { "prettier" },
	javascript = { "prettier" },
	less = { "prettier" },
	markdown = { "prettier" },
	scss = { "prettier" },
	typescript = { "prettier" },
	typescriptreact = { "prettier" },
	vue = { "prettier" },
	rust = { "rustfmt" },
	java = { "google-java-format" },
	toml = { "taplo" },
	sql = { "sqlfluff" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	r = { "styler" },
	ruby = { "rubocop" },
}

---@type NvPluginSpec
return {
	-- NOTE: Formatting
	"stevearc/conform.nvim",
	enabled = function()
		return not vim.g.no_ide
	end,
	event = {
		"BufReadPost",
		"BufNewFile",
	},
	opts = {
		format_after_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			-- Disable autoformat for files in a certain path
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("/node_modules/") then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
		formatters_by_ft = formatters_by_ft,
	},
}
