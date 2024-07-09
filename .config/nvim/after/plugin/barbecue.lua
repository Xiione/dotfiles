local status_ok, barbecue = pcall(require, "barbecue")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colorscheme")

barbecue.setup({
	exclude_filetypes = sidebars.sidebar_types,
	theme = {
		normal = { fg = colors.nord3 },
		-- dirname = { fg = colors.nord3 },
		basename = { fg = colors.nord4 },
        separator = { fg = colors.nord3 }
	},
	symbols = {
		modified = "[+]",
		ellipsis = "",
		separator = "",
	},
	show_modified = true,
    show_dirname = false,
	kinds = require("user.lib.utils").lspkind_icons
})
