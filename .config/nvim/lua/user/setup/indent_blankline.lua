local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")

indent_blankline.setup({
	char = "│",
    char_blankline = "┆",
	space_char_blankline = " ",
	show_trailing_blankline_indent = false,
	show_first_indent_level = true,
	use_treesitter = true,
	show_current_context = true,
	buftype_exclude = { "terminal", "nofile" },
	filetype_exclude = sidebars.sidebar_types,
})
