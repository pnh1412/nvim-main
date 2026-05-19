---@type NvPluginSpec
-- NOTE: Code Runner
return {
  "Zeioth/compiler.nvim",
  init = function()
    local function cd_to_current_file_dir()
      local file = vim.fn.expand("%:p")
      if file == "" then
        return
      end

      local dir = vim.fn.fnamemodify(file, ":h")
      if dir ~= "" and vim.fn.isdirectory(dir) == 1 and vim.uv.cwd() == vim.uv.os_homedir() then
        vim.cmd.cd(vim.fn.fnameescape(dir))
      end
    end

    vim.keymap.set("n", "<leader>r", function()
      require("core.utils").run_code("default")
    end, { desc = "Run Current File", silent = true })

    vim.keymap.set("n", "<leader>rr", function()
      require("core.utils").run_code("default")
    end, { desc = "Run Current File", silent = true })

    vim.keymap.set("n", "<leader>rR", function()
      cd_to_current_file_dir()
      vim.cmd.CompilerRedo()
    end, { desc = "Compiler | Redo Last Action", silent = true })

    vim.keymap.set("n", "<leader>ro", function()
      cd_to_current_file_dir()
      vim.cmd.CompilerOpen()
    end, { desc = "Compiler | Open", silent = true })

    vim.keymap.set("n", "<leader>rs", function()
      vim.cmd.CompilerStop()
    end, { desc = "Compiler | Stop All Tasks", silent = true })

    vim.keymap.set(
      "n",
      "<leader>rt",
      function()
        vim.cmd.CompilerToggleResults()
      end,
      { desc = "Compiler | Toggle Results", silent = true }
    )
  end,
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "CompilerStop" },
  dependencies = {
    {
      "stevearc/overseer.nvim",
      commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 10,
          max_height = 15,
          default_detail = 1,
        },
      },
    },
  },
  opts = {},
}
