---@type NvPluginSpec
-- NOTE: Debug Adapter Protocol
return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "DAP | Continue",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "DAP | Step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "DAP | Step into",
		},
		{
			"<leader>du",
			function()
				require("dap").step_out()
			end,
			desc = "DAP | Step out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "DAP | Toggle breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "DAP | Conditional breakpoint",
		},
		{
			"<leader>dd",
			function()
				require("dapui").toggle()
			end,
			desc = "DAP | Toggle UI",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "DAP | Run last",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "DAP | REPL",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "DAP | Terminate",
		},
	},
	config = function()
		-- NOTE: Check out this for guide
		-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		local dap = require("dap")
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

		local dapui = require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		-- dap.listeners.before.event_terminated["dapui_config"] = function()
		--   dapui.close()
		-- end

		-- dap.listeners.before.event_exited["dapui_config"] = function()
		--   dapui.close()
		-- end

		-- NOTE: Make sure to install the needed files/exectubles through mason
		-- require "plugins.dap.settings.cpptools"
		-- require "plugins.dap.settings.netcoredbg"
		-- require "plugins.dap.settings.godot"
		-- require "plugins.dap.settings.bash-debug-adapter"
		-- require "plugins.dap.settings.php-debug-adapter"
		-- require "plugins.dap.settings.dart-debug-adapter"
		-- require "plugins.dap.settings.chrome-debug-adapter"
		-- require "plugins.dap.settings.firefox-debug-adapter"
		-- require "plugins.dap.settings.java-debug"
		-- require "plugins.dap.settings.node-debug2"
		-- require "plugins.dap.settings.debugpy"
		-- -- require "plugins.dap.settings.go-debug-adapter"
		-- require "plugins.dap.settings.js-debug"
	end,
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
	},
}
