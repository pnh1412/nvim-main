return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  cmd = "Trouble",
  keys = {
    { "<leader>Tw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble workspace diagnostics" },
    { "<leader>Td", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble document diagnostics" },
    { "<leader>Ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble symbols" },
    { "<leader>Tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble LSP" },
    { "<leader>Tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Trouble LSP references" },
    { "<leader>TL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble loclist" },
    { "<leader>Tq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble quickfix" },
  },
  opts = { focus = true },
}
