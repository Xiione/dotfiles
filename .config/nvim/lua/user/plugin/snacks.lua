local sidebars = require("user.lib.sidebars")
local utils = require("user.lib.utils")

return {
	styles = {
		input = {
			border = utils.window_border,
			relative = "cursor",
			wo = {
				winhighlight = sidebars.float_winhl,
				cursorline = false,
			},
		},
	},
	input = {
		enabled = true,
	},
}
