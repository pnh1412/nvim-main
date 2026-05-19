vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.commentstring = "// %s"

vim.opt_local.colorcolumn = "120"

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>jo", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.organizeImports" },
		},
	})
end, vim.tbl_extend("force", opts, { desc = "Java | Organize Imports" }))
map("n", "<leader>jr", "<cmd>JavaRunnerRunMain<cr>", vim.tbl_extend("force", opts, { desc = "Java | Run Main" }))
map(
	"n",
	"<leader>jt",
	"<cmd>JavaTestRunCurrentMethod<cr>",
	vim.tbl_extend("force", opts, { desc = "Java | Test Method" })
)
map(
	"n",
	"<leader>jT",
	"<cmd>JavaTestRunCurrentClass<cr>",
	vim.tbl_extend("force", opts, { desc = "Java | Test Class" })
)
