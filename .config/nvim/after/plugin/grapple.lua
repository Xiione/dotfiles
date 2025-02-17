local status_ok, grapple = pcall(require, "grapple")
if not status_ok then
	return
end

local utils = require("user.lib.utils")

grapple.setup({
	icons = true,
	win_opts = {
		border = utils.window_border,
	},
	statusline = {
		icon = "",
		active = "%s",
		inactive = " %s ",
	},
})
