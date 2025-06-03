local utils = require("user.lib.utils")

return {
	styles = {
		input = {
			border = utils.window_border,
			relative = "cursor",
			wo = {
				winhighlight = "",
				cursorline = false,
			},
		},
	},
	input = {
		enabled = true,
	},
}
