return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    keys = {
      { "<leader>go", "<Plug>(git-conflict-ours)", desc = "Conflict: [O]urs" },
      { "<leader>gt", "<Plug>(git-conflict-theirs)", desc = "Conflict: [T]heirs" },
      { "<leader>gb", "<Plug>(git-conflict-both)", desc = "Conflict: [B]oth" },
      { "<leader>gn", "<Plug>(git-conflict-none)", desc = "Conflict: [N]one" },
      { "[g", "<Plug>(git-conflict-prev-conflict)", desc = "Conflict: Previous" },
      { "]g", "<Plug>(git-conflict-next-conflict)", desc = "Conflict: Next" },
    },
  },
}
