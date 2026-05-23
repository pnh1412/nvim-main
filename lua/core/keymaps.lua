local keymap = vim.keymap.set

keymap("i", "jk", "<Esc>", {
	desc = "Insert | Escape to Normal",
	silent = true,
})

keymap("n", "<leader>y", "<cmd>%y+<cr>", {
	desc = "Yank All Text",
	silent = true,
})

keymap("n", "<leader>bR", "<cmd>%d+<cr>", {
	desc = "Remove All Text",
	silent = true,
})

keymap("n", "<leader>ce", function()
	require("core.utils").run_code()
end, {
	desc = "Execute Code",
	silent = true,
})

keymap("n", "<leader>uC", "<cmd>Telescope themes<cr>", {
	desc = "UI | Colorschemes",
	silent = true,
})

keymap("n", "<C-Up>", "<cmd>resize +2<cr>", {
	desc = "Window | Increase Height",
	silent = true,
})

keymap("n", "<C-Down>", "<cmd>resize -2<cr>", {
	desc = "Window | Decrease Height",
	silent = true,
})

keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", {
	desc = "Window | Decrease Width",
	silent = true,
})

keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", {
	desc = "Window | Increase Width",
	silent = true,
})
