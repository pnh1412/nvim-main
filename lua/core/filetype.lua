-- NOTE: Additional Filetypes
vim.filetype.add({
	extension = {
		["axaml"] = "xml",
		["jinja"] = "htmldjango",
		["mongo"] = "javascript",
		["mongodb"] = "javascript",
		["pkb"] = "plsql",
		["pks"] = "plsql",
		["pls"] = "plsql",
		["plsql"] = "plsql",
	},
	pattern = {
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
})
