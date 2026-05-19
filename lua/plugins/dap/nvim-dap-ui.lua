---@type NvPluginSpec
-- NOTE: Debugging
return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		{ "nvim-neotest/nvim-nio" },
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
	},
	opts = {
		layouts = {
			{
				elements = {
					-- Elements can be strings or table with id and size keys.
					{ id = "scopes", size = 0.25 },
					"breakpoints",
					"stacks",
					"watches",
				},
				size = 40, -- 40 columns
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 0.25, -- 25% of total lines
				position = "bottom",
			},
		},
	},
}
