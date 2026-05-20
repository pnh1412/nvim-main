---@type NvPluginSpec
-- NOTE: Code action picker with preview
return {
	"rachartier/tiny-code-action.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>lp",
			function()
				require("tiny-code-action").code_action()
			end,
			desc = "LSP | Preview Code Action",
			mode = { "n", "x" },
			silent = true,
		},
	},
	opts = {
		backend = "vim",
		picker = "telescope",
		notify = {
			enabled = true,
			on_empty = true,
		},
	},
}
