local status_ok, hardtime = pcall(require, "hardtime")
if not status_ok then
	return
end
local sidebars = require("user.lib.sidebars")

hardtime.setup({
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
})
