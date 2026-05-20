-- NOTE: package.json dependency versions and actions.
local function is_package_json()
	return vim.fn.expand("%:t") == "package.json"
end

local function package_info(action, opts)
	return function()
		if not is_package_json() then
			vim.notify("package-info.nvim only works in package.json", vim.log.levels.WARN)
			return
		end

		require("package-info")[action](opts)
	end
end

return {
	"vuki656/package-info.nvim",
	event = {
		"BufReadPost package.json",
		"BufNewFile package.json",
	},
	cmd = {
		"PackageInfoShow",
		"PackageInfoShowForce",
		"PackageInfoHide",
		"PackageInfoUpdate",
		"PackageInfoDelete",
		"PackageInfoChangeVersion",
		"PackageInfoInstall",
	},
	keys = {
		{ "<leader>npS", package_info("show"), desc = "Package | Show versions" },
		{ "<leader>npf", package_info("show", { force = true }), desc = "Package | Force refresh versions" },
		{ "<leader>nph", package_info("hide"), desc = "Package | Hide versions" },
		{ "<leader>npt", package_info("toggle"), desc = "Package | Toggle versions" },
		{ "<leader>npu", package_info("update"), desc = "Package | Update dependency" },
		{ "<leader>npd", package_info("delete"), desc = "Package | Delete dependency" },
		{ "<leader>npc", package_info("change_version"), desc = "Package | Change version" },
		{ "<leader>npi", package_info("install"), desc = "Package | Install dependency" },
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		autostart = true,
		hide_up_to_date = false,
		hide_unstable_versions = false,
		package_manager = "npm",
		highlights = {
			up_to_date = {
				fg = "#a6e3a1",
			},
			outdated = {
				fg = "#f38ba8",
			},
			invalid = {
				fg = "#f38ba8",
			},
		},
		icons = {
			enable = true,
			style = {
				up_to_date = "  ",
				outdated = "  ",
			},
		},
	},
	config = function(_, opts)
		require("package-info").setup(opts)
	end,
}
