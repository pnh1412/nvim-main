-- NOTE: Autocommands

local fn = vim.fn

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General", { clear = true })

local function force_normal_mode()
  local function stop()
    local mode = vim.fn.mode()
    if mode:sub(1, 1) == "i" or mode == "R" or mode == "t" then
      local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
      vim.api.nvim_feedkeys(keys, "nx", false)
      pcall(vim.cmd, "stopinsert")
    end
  end

  stop()
  vim.schedule(stop)
  vim.defer_fn(stop, 30)
  vim.defer_fn(stop, 100)
end

local function feed_normal_key(lhs)
  force_normal_mode()
  vim.schedule(function()
    local keys = vim.api.nvim_replace_termcodes(lhs, true, false, true)
    vim.api.nvim_feedkeys(keys, "m", false)
  end)
end

local function is_dashboard_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  if ft == "alpha" or ft == "dashboard" or ft == "starter" then
    return true
  end

  if vim.b[bufnr].pnhau_dashboard_buffer then
    return true
  end

  if vim.bo[bufnr].buftype ~= "nofile" then
    return false
  end

  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, math.min(vim.api.nvim_buf_line_count(bufnr), 30), false)
  if not ok then
    return false
  end

  local text = table.concat(lines, "\n")
  return text:find("Find Files", 1, true) ~= nil
    or text:find("New file", 1, true) ~= nil
end

autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
      vim.cmd "Telescope find_files"
      -- require("nvim-tree.api").tree.open()
    end
  end,
  group = general,
  desc = "Open Telescope when it's a Directory",
})

-- Enable Line Number in Telescope Preview
autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
  end,
  group = general,
  desc = "Enable Line Number in Telescope Preview",
})

-- Hide folds and Disable statuscolumn in these filetypes
autocmd("FileType", {
  pattern = { "sagaoutline", "nvcheatsheet" },
  callback = function()
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.stc = "" -- not really important
  end,
  group = general,
  desc = "Disable Fold & StatusColumn",
})

-- Remove this if there's an issue
autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    -- In wsl 2, just install xclip
    -- Ubuntu
    -- sudo apt install xclip
    -- Arch linux
    -- sudo pacman -S xclip
    vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
  end,
  group = general,
  desc = "Lazy load clipboard",
})

autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd "startinsert!"
  end,
  group = general,
  desc = "Terminal Options",
})

autocmd({ "BufLeave", "WinLeave" }, {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if
      not vim.tbl_contains({ "opencode", "opencode_output", "opencode_footer", "neo-tree" }, ft)
      and not is_dashboard_buffer(args.buf)
    then
      return
    end

    force_normal_mode()
  end,
  group = general,
  desc = "Return to normal mode after leaving AI/explorer UI buffers",
})

local function protect_dashboard_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.b[bufnr].pnhau_dashboard_buffer = true

  local function mark_leader_pending()
    vim.b[bufnr].pnhau_dashboard_leader_pending = true
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.b[bufnr].pnhau_dashboard_leader_pending = false
      end
    end, vim.o.timeoutlen + 100)
  end

  local replay_keys = { "<Space>", "[", "]", "/", "\\", ";", "'", ",", ".", "-", "=" }
  for code = string.byte("a"), string.byte("z") do
    replay_keys[#replay_keys + 1] = string.char(code)
  end
  for code = string.byte("A"), string.byte("Z") do
    replay_keys[#replay_keys + 1] = string.char(code)
  end
  for code = string.byte("0"), string.byte("9") do
    replay_keys[#replay_keys + 1] = string.char(code)
  end

  for _, lhs in ipairs(replay_keys) do
    pcall(vim.keymap.set, "i", lhs, function()
      if lhs == "<Space>" then
        mark_leader_pending()
        feed_normal_key(lhs)
        return
      end

      if vim.b[bufnr].pnhau_dashboard_leader_pending then
        vim.b[bufnr].pnhau_dashboard_leader_pending = false
        feed_normal_key(lhs)
        return
      end

      force_normal_mode()
    end, {
      buffer = bufnr,
      desc = "Dashboard | Replay key in Normal mode",
      silent = true,
    })
  end

  for _, lhs in ipairs({ "a", "b", "d", "D", "g", "h", "H", "M", "m", "n", "r", "s", "u", "v", "w", "x" }) do
    pcall(vim.keymap.set, "n", lhs, function()
      if not vim.b[bufnr].pnhau_dashboard_leader_pending then
        return
      end

      vim.b[bufnr].pnhau_dashboard_leader_pending = false
      feed_normal_key(lhs)
    end, {
      buffer = bufnr,
      desc = "Dashboard | Complete pending leader key",
      silent = true,
    })
  end

  vim.schedule(function()
    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end

    force_normal_mode()
  end)
end

autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "*",
  callback = function(args)
    if not is_dashboard_buffer(args.buf) then
      return
    end

    protect_dashboard_buffer(args.buf)
    force_normal_mode()
  end,
  group = general,
  desc = "Keep dashboard buffers protected after redraw/focus changes",
})

autocmd("FileType", {
  pattern = { "alpha", "dashboard" },
  callback = function(args)
    protect_dashboard_buffer(args.buf)
  end,
  group = general,
  desc = "Protect dashboard from insert-mode text input",
})

autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    protect_dashboard_buffer(vim.api.nvim_get_current_buf())
  end,
  group = general,
  desc = "Protect alpha dashboard after render",
})

autocmd("InsertEnter", {
  pattern = "*",
  callback = function(args)
    if not is_dashboard_buffer(args.buf) then
      return
    end

    force_normal_mode()
  end,
  group = general,
  desc = "Never stay in insert mode on dashboard",
})

autocmd("InsertCharPre", {
  pattern = "*",
  callback = function(args)
    if not is_dashboard_buffer(args.buf) then
      return
    end

    local char = vim.v.char
    vim.v.char = ""

    if char == " " then
      vim.b[args.buf].pnhau_dashboard_leader_pending = true
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.b[args.buf].pnhau_dashboard_leader_pending = false
        end
      end, vim.o.timeoutlen + 100)
      feed_normal_key("<Space>")
      return
    end

    if vim.b[args.buf].pnhau_dashboard_leader_pending then
      vim.b[args.buf].pnhau_dashboard_leader_pending = false
      feed_normal_key(char)
      return
    end

    force_normal_mode()
  end,
  group = general,
  desc = "Prevent text insertion into dashboard buffers",
})

autocmd("FileType", {
  pattern = { "opencode", "opencode_output" },
  callback = function(args)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end

      vim.keymap.set({ "n", "i" }, "<Esc>", function()
        force_normal_mode()
      end, {
        buffer = args.buf,
        desc = "Opencode | Leave Insert mode",
        silent = true,
      })
    end, 50)
  end,
  group = general,
  desc = "Harden Opencode escape handling",
})

autocmd("FileType", {
  pattern = { "neo-tree" },
  callback = function(args)
    vim.keymap.set("i", "<Space>", function()
      local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n><Space>", true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end, {
      buffer = args.buf,
      desc = "Dashboard | Escape insert before leader",
      silent = true,
    })
  end,
  group = general,
  desc = "Escape insert before leader in explorer UI",
})

autocmd("BufReadPost", {
  callback = function()
    if fn.line "'\"" > 1 and fn.line "'\"" <= fn.line "$" then
      vim.cmd 'normal! g`"'
    end
  end,
  group = general,
  desc = "Go To The Last Cursor Position",
})

autocmd("TextYankPost", {
  callback = function()
    if vim.version().minor >= 11 then
      require("vim.hl").on_yank { higroup = "Visual", timeout = 200 }
    else
      require("vim.highlight").on_yank { higroup = "Visual", timeout = 200 }
    end
  end,
  group = general,
  desc = "Highlight when yanking",
})

-- autocmd({ "BufEnter", "BufNewFile" }, {
--   callback = function()
--     vim.o.showtabline = 0
--   end,
--   group = general,
--   desc = "Disable Tabline",
-- })

autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Disable comment on new line
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = general,
  desc = "Disable New Line Comment",
})

autocmd("FileType", {
  pattern = { "c", "cpp", "py", "java", "cs" },
  callback = function()
    vim.bo.shiftwidth = 4
  end,
  group = general,
  desc = "Set shiftwidth to 4 in these filetypes",
})

-- :h W10
autocmd("FileChangedRO", {
  callback = function()
    vim.bo.readonly = false
  end,
  group = general,
  desc = "Disable Readonly Message",
})

autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
  -- nested = true, -- for format on save
  callback = function()
    if vim.bo.filetype ~= "" and vim.bo.buftype == "" and vim.bo.modified then
      vim.cmd "silent! w"
    end
  end,
  group = general,
  desc = "Auto Save",
})

autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File reloaded automatically", vim.log.levels.INFO, { title = "nvim" })
  end,
  group = general,
  desc = "Notify when file is reloaded",
})

autocmd("VimResized", {
  callback = function()
    vim.cmd "wincmd ="
  end,
  group = general,
  desc = "Equalize Splits",
})

-- autocmd("ModeChanged", {
--   callback = function()
--     if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
--       vim.opt.hlsearch = true
--     else
--       vim.opt.hlsearch = false
--     end
--   end,
--   group = general,
--   desc = "Highlighting matched words when searching",
-- })

autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    if mode:match "i" then
      vim.opt.hlsearch = false -- hide in insert mode
    else
      vim.opt.hlsearch = true -- show in normal / visual / command modes
    end
  end,
  group = general,
  desc = "Show search highlights in normal mode, hide in insert mode",
})

-- Timer-based file reload for TUI
local file_check_timer = nil
local last_check = {}

autocmd("VimEnter", {
  callback = function()
    file_check_timer = fn.timer_start(5000, function()
      local bufnr = vim.api.nvim_get_current_buf()
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == "" then
        return
      end

      local current_time = fn.getftime(fname)
      if current_time == -1 then
        return
      end

      if last_check[bufnr] and current_time > last_check[bufnr] then
        vim.cmd "checktime"
      end

      last_check[bufnr] = current_time
    end, { ["repeat"] = -1 })
  end,
  group = general,
  desc = "Start timer for file reload",
})

autocmd("VimLeave", {
  callback = function()
    if file_check_timer then
      fn.timer_stop(file_check_timer)
    end
  end,
  group = general,
  desc = "Stop timer on exit",
})

-- Better paste in visual mode
autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.go.clipboard = ""
    end
  end,
  group = general,
  desc = "Fix clipboard after yank",
})

-- Smart fold
autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "spectre_panel",
    "dart",
    "fugitive",
    "git",
    "alpha",
    "dashboard",
    "nvcheatsheet",
    "lazy",
    "mason",
  },
  callback = function()
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
  end,
  group = general,
  desc = "Better settings for special buffers",
})

-- Disable auto-comment continuation
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  group = general,
  desc = "Disable auto comment continuation",
})
