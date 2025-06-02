local sidebars = require("user.lib.sidebars")

return {
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
}
