---@type NvPluginSpec
-- NOTE:  Opencode

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
	vim.defer_fn(stop, 250)
end

local function opencode_action(name, args, opts)
	return function()
		if opts and opts.force_normal then
			force_normal_mode()
		end

		local commands = require("opencode.commands")
		local parsed = commands.build_parsed_intent(name, args or {})
		commands.execute_parsed_intent(parsed)

		if opts and opts.force_normal then
			force_normal_mode()
		end
	end
end

return {
  "sudo-tee/opencode.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>aa", desc = "Opencode | Toggle" },
    { "<leader>aq", desc = "Opencode | Close" },
    { "<leader>at", desc = "Opencode | Toggle focus" },
    { "<leader>as", desc = "Opencode | Select session" },
    { "<leader>ap", desc = "Opencode | Configure provider" },
    { "<leader>a]", desc = "Opencode | Next diff" },
    { "<leader>a[", desc = "Opencode | Previous diff" },
    { "<leader>ac", desc = "Opencode | Close diff" },
    { "<leader>ara", desc = "Opencode | Revert all since last prompt" },
    { "<leader>art", desc = "Opencode | Revert file since last prompt" },
    { "<leader>arA", desc = "Opencode | Revert all session changes" },
    { "<leader>arT", desc = "Opencode | Revert file session changes" },
    { "<leader>arr", desc = "Opencode | Restore current file" },
    { "<leader>arR", desc = "Opencode | Restore all files" },
    { "<leader>ax", desc = "Opencode | Swap position" },
    { "<leader>aS", desc = "Opencode | Select child session" },
    { "<leader>aD", desc = "Opencode | Debug message" },
    { "<leader>aO", desc = "Opencode | Debug output" },
    { "<leader>ads", desc = "Opencode | Debug session" },
    {
      "<leader>apa",
      function()
        require("opencode.api").permission_accept()
      end,
      desc = "Opencode | Permission accept",
    },
    {
      "<leader>apA",
      function()
        require("opencode.api").permission_accept_all()
      end,
      desc = "Opencode | Permission accept all",
    },
    {
      "<leader>apd",
      function()
        require("opencode.api").permission_deny()
      end,
      desc = "Opencode | Permission deny",
    },
  },
  opts = {
    ui = {
      input = {
        -- Fixed input height avoids a deferred resize callback racing with a
        -- just-closed input buffer in opencode.nvim.
        min_height = 0.12,
        max_height = 0.12,
        text = {
          wrap = true, -- Wraps text inside input window
        },
      },
    },
    keymap_prefix = "<leader>a",
    keymap = {
      editor = {
        ["<leader>ag"] = false, -- duplicate of <leader>aa from default global keymaps
        ["<leader>aa"] = { opencode_action("toggle", nil, { force_normal = true }) }, -- Open opencode. Close if opened
        ["<leader>ai"] = false, -- redundant with <leader>aa for daily use
        ["<leader>aI"] = false, -- redundant with <leader>aa for daily use
        ["<leader>ao"] = false, -- redundant with <leader>aa for daily use
        ["<leader>at"] = { "toggle_focus" }, -- Toggle focus between opencode and last window
        ["<leader>aq"] = { opencode_action("close", nil, { force_normal = true }) }, -- Close UI windows
        ["<leader>as"] = { "select_session" }, -- Select and load a opencode session
        ["<leader>ap"] = { "configure_provider" }, -- Quick provider and model switch from predefined list
        ["<leader>ad"] = false, -- opens the same side UI when no diff exists; keep diff navigation/revert keys
        ["<leader>a]"] = { "diff_next" }, -- Navigate to next file diff
        ["<leader>a["] = { "diff_prev" }, -- Navigate to previous file diff
        ["<leader>ac"] = { "diff_close" }, -- Close diff view tab and return to normal editing
        ["<leader>ara"] = { "diff_revert_all_last_prompt" }, -- Revert all file changes since the last opencode prompt
        ["<leader>art"] = { "diff_revert_this_last_prompt" }, -- Revert current file changes since the last opencode prompt
        ["<leader>arA"] = { "diff_revert_all" }, -- Revert all file changes since the last opencode session
        ["<leader>arT"] = { "diff_revert_this" }, -- Revert current file changes since the last opencode session
        ["<leader>arr"] = { "diff_restore_snapshot_file" }, -- Restore a file to a restore point
        ["<leader>arR"] = { "diff_restore_snapshot_all" }, -- Restore all files to a restore point
        ["<leader>ax"] = { "swap_position" }, -- Swap Opencode pane left/right
      },
      input_window = {
        ["<cr>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
        ["<esc>"] = { force_normal_mode, mode = { "n", "i" } }, -- Leave insert mode without closing Opencode
        ["<C-c>"] = { "cancel" }, -- Cancel running opencode request
        ["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
        ["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
        ["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
        ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
        ["<up>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
        ["<down>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
        ["<M-m>"] = { "switch_mode" }, -- Switch between modes (build/plan)
      },
      output_window = {
        ["<esc>"] = { force_normal_mode, mode = { "n", "i" } }, -- Leave insert mode without closing Opencode
        ["<C-c>"] = { "cancel" }, -- Cancel running opencode request
        ["]]"] = { "next_message" }, -- Navigate to next message in the conversation
        ["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
        ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
        ["<C-i>"] = { "focus_input" }, -- Focus on input window and enter insert mode at the end of the input from the output window
        ["<leader>aS"] = { "navigate_session_tree", { "child", "picker" } }, -- Select and load a child session
        ["<leader>aD"] = { "debug_message" }, -- Open raw message in new buffer for debugging
        ["<leader>aO"] = { "debug_output" }, -- Open raw output in new buffer for debugging
        ["<leader>ads"] = { "debug_session" }, -- Open raw session in new buffer for debugging
      },
    },
  },
}
