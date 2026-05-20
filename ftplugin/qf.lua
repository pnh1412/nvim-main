vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.foldcolumn = "0"
vim.opt_local.scrolloff = 0
vim.opt_local.sidescrolloff = 0

vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true, desc = "Quickfix | Close" })
