local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ import = "plugins.terminal" },
		{ import = "plugins.ui" },
		{ import = "plugins.git" },
		{ import = "plugins.database" },
		{ import = "plugins.dap" },
		{ import = "plugins.completion" },
		{ import = "plugins.ai" },
		{ import = "plugins.editor" },
		{ import = "plugins.langs" },
		{ import = "plugins.lsp.configs" },
		{ import = "plugins.navigation" },
		{ import = "plugins.sessions" },
		{ import = "plugins.testing" },
		{ import = "plugins.writing" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	local_spec = false,
	pkg = {
		enabled = false,
	},
	rocks = {
		enabled = false,
	},
	change_detection = {
		enabled = false,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"matchit",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"tutor",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
			},
		},
	},
	ui = {
		size = { width = 0.9, height = 0.9 },
		border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
	},
	checker = {
		enabled = false,
	},
})
