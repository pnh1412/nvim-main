---@type NvPluginSpec
-- NOTE: Database UI
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    local function open_sqlit(args)
      local pipx_sqlit = vim.fn.expand("~/.local/bin/sqlit")
      local sqlit = vim.fn.executable(pipx_sqlit) == 1 and pipx_sqlit or vim.fn.exepath("sqlit")

      if sqlit == "" then
        vim.notify(
          "sqlit is not installed. Install it with: pipx install sqlit-tui",
          vim.log.levels.WARN,
          { title = "SQLit" }
        )
        return
      end

      local cmd = vim.fn.shellescape(sqlit)
      if args and args ~= "" then
        cmd = cmd .. " " .. args
      end

      vim.cmd("TermNew direction=float cmd=" .. cmd)
    end

    vim.g.db_ui_use_nerd_fonts = 1
    vim.keymap.set("n", "<leader>Dt", ":DBUIToggle<CR>", { desc = "Toggle DBUI" })
    vim.keymap.set("n", "<leader>Da", ":DBUIAddConnection<CR>", { desc = "Add connection" })
    vim.keymap.set("n", "<leader>Df", ":DBUIFindBuffer<CR>", { desc = "Find buffer" })
    vim.keymap.set("n", "<leader>Ds", function()
      open_sqlit()
    end, { desc = "SQLit | Open TUI", silent = true })
    vim.keymap.set("n", "<leader>Dm", function()
      open_sqlit("--mock=sqlite-demo")
    end, { desc = "SQLit | Mock SQLite Demo", silent = true })
  end,
}
