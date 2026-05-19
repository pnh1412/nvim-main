-- -- NOTE: For Java
-- return {
--   "nvim-java/nvim-java",
--   event = "VeryLazy",
--   enable= false,
--   config = function()
--     require("java").setup()
--     require("lspconfig").jdtls.setup {
--       on_attach = require("config.lsp").on_attach,
--       capabilities = require("config.lsp").capabilities,
--     }
--   end,
-- }

return {
	"nvim-java/nvim-java",
	enabled = function()
		return not vim.g.no_ide
	end,
	dependencies = {
		"JavaHello/spring-boot.nvim",
		"nvim-java/lua-async-await",
		"nvim-java/nvim-java-core",
		"nvim-java/nvim-java-test",
		"nvim-java/nvim-java-dap",
		"MunifTanjim/nui.nvim",
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		{
			"williamboman/mason.nvim",
			opts = {
				registries = {
					"github:nvim-java/mason-registry",
					"github:mason-org/mason-registry",
				},
			},
		},
	},
	ft = { "java" },
	config = function()
		require("java").setup({
			spring_boot_tools = {
				enable = true,
			},
		})

		vim.lsp.config("jdtls", {
			on_attach = require("config.lsp").on_attach,
			capabilities = require("config.lsp").capabilities,
		})
		vim.lsp.enable("jdtls")
	end,
}
