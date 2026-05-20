-- NOTE: Floating buffer-local search and replace
return {
  "ankushbhagats/match.nvim",
  cmd = {
    "Match",
    "MatchWord",
    "MatchLine",
  },
  keys = {
    {
      "<leader>Ms",
      function()
        vim.ui.input({ prompt = "Match search: " }, function(input)
          if input and input ~= "" then
            vim.api.nvim_cmd({ cmd = "Match", args = { input } }, {})
          end
        end)
      end,
      desc = "Match | Search and Replace",
    },
    { "<leader>Mw", "<cmd>MatchWord<cr>", desc = "Match | Word Under Cursor" },
    { "<leader>Ml", "<cmd>MatchLine<cr>", desc = "Match | Current Line" },
  },
  opts = {
    prefix = "",
    anchor = "NE",
    style = "minimal",
    border = vim.g.border_enabled and "rounded" or "none",
    border_hl = "Function",
  },
}
