-- NOTE: Static web live reload server

return {
	"ankushbhagats/liveserver.nvim",
	cmd = {
		"LiveServerStart",
		"LiveServerStop",
		"LiveServerSelect",
	},
	ft = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	keys = {
		{ "<leader>ws", "<cmd>LiveServerStart<cr>", desc = "Live Server Start" },
		{ "<leader>wS", "<cmd>LiveServerStop<cr>", desc = "Live Server Stop" },
		{ "<leader>wl", "<cmd>LiveServerSelect<cr>", desc = "Live Server Select" },
	},
	build = "npm i",
	opts = {
		filetypes = {
			html = true,
			css = true,
			scss = true,
			javascript = true,
			javascriptreact = true,
			typescript = true,
			typescriptreact = true,
		},
		args = {
			port = 8080,
			host = "127.0.0.1",
			["no-browser"] = false,
			watch = "*.html,*.css,*.scss,*.js,*.jsx,*.ts,*.tsx",
		},
		colortype = "hex",
	},
}
