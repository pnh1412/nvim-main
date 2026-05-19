return {
	init_options = {
		vue = {
			hybridMode = true,
		},
		typescript = {
			tsdk = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/typescript/lib",
		},
	},
}
