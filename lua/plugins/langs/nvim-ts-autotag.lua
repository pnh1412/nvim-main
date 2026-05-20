-- NOTE: Auto close and rename HTML/JSX/TSX tags.
return {
	"windwp/nvim-ts-autotag",
	ft = {
		"astro",
		"html",
		"javascriptreact",
		"svelte",
		"typescriptreact",
		"vue",
		"xml",
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
	},
}
