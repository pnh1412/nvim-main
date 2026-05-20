return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{
			"<leader>gCd",
			"<cmd>CodeDiff<cr>",
			desc = "CodeDiff | Changed Files",
		},
		{
			"<leader>gCf",
			"<cmd>CodeDiff file HEAD<cr>",
			desc = "CodeDiff | Current File vs HEAD",
		},
		{
			"<leader>gCh",
			"<cmd>CodeDiff history<cr>",
			desc = "CodeDiff | History",
		},
		{
			"<leader>gCi",
			"<cmd>CodeDiff --inline<cr>",
			desc = "CodeDiff | Inline Diff",
		},
		{
			"<leader>gCS",
			"<cmd>CodeDiff --side-by-side<cr>",
			desc = "CodeDiff | Side-by-side Diff",
		},
	},
	opts = {
		diff = {
			layout = "side-by-side",
			disable_inlay_hints = true,
			ignore_trim_whitespace = false,
			compute_moves = false,
		},
		explorer = {
			position = "left",
			width = 38,
			auto_refresh = true,
			view_mode = "list",
			visible_groups = {
				staged = true,
				unstaged = true,
				conflicts = true,
			},
		},
	},
}
