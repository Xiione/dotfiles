local icons = require("user.cfg.icons")

return {
	"j-hui/fidget.nvim",
	event = "VeryLazy",
	opts = {
		progress = {
			display = {
				done_icon = icons.status.success,
			},
		},
		notification = {
			window = {
				normal_hl = "NormalFloat",
				winblend = 5,
			},
		},
		integration = {
			["nvim-tree"] = {
				enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
			},
		},
	},
}
