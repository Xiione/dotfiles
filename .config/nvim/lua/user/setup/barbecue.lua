local status_ok, barbecue = pcall(require, "barbecue")
if not status_ok then
	return
end

local utils = require("user.lib.utils")
local colors = require("user.cfg.colorscheme")

barbecue.setup({
	exclude_filetypes = utils.sidebar_types,
	theme = {
		normal = { fg = colors.nord3 },
		-- dirname = { fg = colors.nord3 },
		basename = { fg = colors.nord4 },
        separator = { fg = colors.nord3 }
	},
	symbols = {
		modified = "●",
		ellipsis = "…",
		separator = "",
	},
	show_modified = true,
    show_dirname = false,
	kinds = {
		Array = "",
		Boolean = "",
		Class = "",
		Constant = "",
		Constructor = "",
		Enum = "",
		EnumMember = "",
		Event = "",
		Field = "",
		File = "",
		Function = "󰊕",
		Interface = "",
		Key = "",
		Method = "",
		Module = "",
		Namespace = "",
		Null = "",
		Number = "",
		Object = "",
		Operator = "",
		Package = "",
		Property = "",
		String = "",
		Struct = "",
		TypeParameter = "",
		Variable = "",
	},
})
