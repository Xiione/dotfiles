local status_ok, barbecue = pcall(require, "barbecue")
if not status_ok then
	return
end

local utils = require("user.lib.utils")

local colors = {
	nord17 = "#1e2128", -- custom
	nord16 = "#272c36", -- custom
	nord0 = "#2E3440",
	-- nord0o = "#2E3441", -- i think the nord nvim theme takes all bgs with the nord0 color "none"
	nord1 = "#3B4252",
	nord2 = "#434C5E",
	nord3 = "#4C566A",
	nord4 = "#D8DEE9",
	nord5 = "#E5E9F0",
	nord6 = "#ECEFF4",
	nord7 = "#8FBCBB",
	nord8 = "#88C0D0",
	nord9 = "#81A1C1",
	nord10 = "#5E81AC",
	nord11 = "#BF616A",
	nord12 = "#D08770",
	nord13 = "#EBCB8B",
	nord14 = "#A3BE8C",
	nord15 = "#B48EAD",
}

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
