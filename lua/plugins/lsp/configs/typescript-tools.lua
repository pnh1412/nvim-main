---@type NvPluginSpec
-- NOTE: For Typescript
return {
	"pmizio/typescript-tools.nvim",
	enabled = function()
		return not vim.g.no_ide
	end,
	event = {
		"BufReadPost",
		"BufNewFile",
	},
	opts = {
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			require("config.lsp").on_attach(client, bufnr)
		end,
		settings = {
			separate_diagnostic_server = true, -- Disable separate diagnostic server
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeCompletionsForModuleExports = true,
				quotePreference = "auto",
			},
		},
	},
}
