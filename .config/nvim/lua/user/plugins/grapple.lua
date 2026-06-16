return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		scope = "git_branch",
		icons = true,
		win_opts = {
			border = "solid",
		},
		statusline = {
			icon = "",
			active = "%s",
			inactive = " %s ",
		},
	},
}
