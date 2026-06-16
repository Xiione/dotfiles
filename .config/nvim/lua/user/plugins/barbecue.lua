local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colors")

return {
	"adonespitogo/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		attach_navic = true,
		exclude_filetypes = sidebars.sidebar_types,
		theme = {
			normal = { fg = colors.nord3L, bg = colors.nord18 },
			-- dirname = { fg = colors.nord3 },
			basename = { fg = colors.nord4 },
			separator = { fg = colors.nord3 },
		},
		symbols = {
			modified = "[+]",
			ellipsis = "",
			separator = "",
		},
		show_modified = true,
		show_dirname = false,
		kinds = require("user.lib.utils").lspkind_icons,
	},
}
