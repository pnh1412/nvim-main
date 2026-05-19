-- NOTE: Utilities
local M = {}

M.git = function()
  local status_ok, _ = pcall(require, "toggleterm")
  if not status_ok then
    return vim.notify "toggleterm.nvim isn't installed!!!"
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new { cmd = "lazygit", hidden = true }
  lazygit:toggle()
end

-- HUUUUUUUUUUUUUUUUUUUUUUUGE kudos and thanks to
-- https://github.com/hown3d for this function <3
M.substitute = function(cmd)
  local function shellescape(value)
    return vim.fn.shellescape(value)
  end

  local function replace(token, value)
    cmd = cmd:gsub(vim.pesc(token), function()
      return value
    end)
  end

  replace("$fileBaseName", shellescape(vim.fn.expand "%:t:r"))
  replace("$fileName", shellescape(vim.fn.expand "%:t"))
  replace("$fileBase", shellescape(vim.fn.expand "%:r"))
  replace("$filePath", shellescape(vim.fn.expand "%:p"))
  replace("$file", shellescape(vim.fn.expand "%"))
  replace("$dir", shellescape(vim.fn.expand "%:p:h"))
  replace("$altFile", shellescape(vim.fn.expand "#"))
  replace("#", shellescape(vim.fn.expand "#"))
  replace("%", shellescape(vim.fn.expand "%:p"))

  return cmd
end

local function open_output(lines)
  vim.cmd("botright 12new")
  local bufnr = vim.api.nvim_get_current_buf()

  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "runner-output"

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false
end

local function run_in_terminal(cmd)
  local output = vim.fn.systemlist(cmd .. " 2>&1")
  local exit_code = vim.v.shell_error

  local lines = { "$ " .. cmd, "" }
  vim.list_extend(lines, output)
  table.insert(lines, "")
  table.insert(lines, "[Process exited " .. exit_code .. "]")

  open_output(lines)
end

M.run_code = function(preferred)
  local file = vim.fn.expand("%:p")
  if file ~= "" then
    vim.cmd("silent write")
    vim.cmd.cd(vim.fn.fnameescape(vim.fn.fnamemodify(file, ":h")))
  end

  local file_extension = vim.fn.expand "%:e"
  local selected_cmd = ""
  local supported_filetypes = {
    c = {
      default = "gcc $fileName -o $fileBaseName && ./$fileBaseName",
      debug = "gcc -g $fileName -o $fileBaseName && ./$fileBaseName",
    },
    cpp = {
      default = "g++ $fileName -o $fileBaseName && ./$fileBaseName",
      debug = "g++ -g $fileName -o $fileBaseName",
      -- competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && $fileBase<input.txt",
      competitive = "g++ -std=c++17 -Wall -DAL -O2 $fileName -o $fileBaseName && ./$fileBaseName",
    },
    cs = {
      default = "dotnet run",
    },
    go = {
      default = "go run %",
    },
    html = {
      default = "firefox $filePath", -- NOTE: Change this based on your browser that you use
    },
    java = {
      default = "java %",
    },
    jl = {
      default = "julia %",
    },
    js = {
      default = "node %",
      debug = "node --inspect %",
    },
    lua = {
      default = "lua %",
    },
    php = {
      default = "php %",
    },
    pl = {
      default = "perl %",
    },
    py = {
      default = "python3 %",
    },
    r = {
      default = "Rscript %",
    },
    rb = {
      default = "ruby %",
    },
    rs = {
      default = "rustc % && $fileBase",
    },
    ts = {
      default = "tsc % && node $fileBase",
    },
  }

  if supported_filetypes[file_extension] then
    local choices = vim.tbl_keys(supported_filetypes[file_extension])

    if preferred and supported_filetypes[file_extension][preferred] then
      selected_cmd = supported_filetypes[file_extension][preferred]
      run_in_terminal(M.substitute(selected_cmd))
    elseif #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selected_cmd = supported_filetypes[file_extension][choices[1]]
      run_in_terminal(M.substitute(selected_cmd))
    else
      vim.ui.select(choices, { prompt = "Choose a command: " }, function(choice)
        selected_cmd = supported_filetypes[file_extension][choice]
        if selected_cmd then
          run_in_terminal(M.substitute(selected_cmd))
        end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

return M
