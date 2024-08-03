local status_ok, grapple = pcall(require, "grapple")
if not status_ok then
	return
end

grapple.setup({
	icons = true,
	win_opts = {
		border = "solid",
	},
	statusline = {
		icon = "",
		active = "%s",
		inactive = " %s ",
	},
})
