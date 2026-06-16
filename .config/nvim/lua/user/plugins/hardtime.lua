local sidebars = require("user.lib.sidebars")

return {
	"m4xshen/hardtime.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		disable_mouse = false,
		disabled_filetypes = sidebars.sidebar_types,
		disabled_keys = {
			["<Up>"] = {},
			["<Down>"] = {},
			["<Left>"] = {},
			["<Right>"] = {},
		},
		restricted_keys = {
			["h"] = {},
			["j"] = {},
			["k"] = {},
			["l"] = {},
		},
	},
}
