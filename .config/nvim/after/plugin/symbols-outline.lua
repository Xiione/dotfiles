local status_ok, outline = pcall(require, "outline")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")
local utils = require("user.lib.utils")
local kinds = utils.lspkind_icons

outline.setup({
	guides = {
		enabled = true,
	},
	keymaps = {
		close = { "q" },
		code_actions = "a",
		fold = "h",
		fold_all = "W",
		fold_reset = "R",
		goto_location = "<CR>",
		hover_symbol = "K",
		peek_location = "<Tab>",
		rename_symbol = "r",
		toggle_preview = "<C-Space>",
		unfold = "l",
		unfold_all = "E",
	},
	outline_items = {
		highlight_hovered_item = true,
		show_symbol_details = false,
	},
	outline_window = {
		auto_close = true,
		position = "right",
		relative_width = false,
		show_numbers = false,
		show_relative_numbers = false,
		width = 40,
		wrap = false,
		winhl = sidebars.make_winhighlight({ cursorline = true }),
	},
	preview_window = {
		auto_preview = false,
		border = utils.window_border,
		winhl = "Normal:NormalSidebar",
	},
	provider = {
		lsp = {
			blacklist_clients = {},
		},
	},
	symbol_folding = {
		auto_unfold_hover = false,
		autofold_depth = 0,
		markers = { "", "" },
	},
	symbols = {
		icons = {
			Array = { icon = kinds.Array, hl = "@constant" },
			Boolean = { icon = kinds.Boolean, hl = "@boolean" },
			Class = { icon = kinds.Class, hl = "@type" },
			Component = { icon = kinds.Component, hl = "@function" },
			Constant = { icon = kinds.Constant, hl = "@constant" },
			Constructor = { icon = kinds.Constructor, hl = "@constructor" },
			Enum = { icon = kinds.Enum, hl = "@type" },
			EnumMember = { icon = kinds.EnumMember, hl = "@field" },
			Event = { icon = kinds.Event, hl = "@type" },
			Field = { icon = kinds.Field, hl = "@field" },
			File = { icon = kinds.File, hl = "@text.uri" },
			Fragment = { icon = kinds.Fragment, hl = "@constant" },
			Function = { icon = kinds.Function, hl = "@function" },
			Interface = { icon = kinds.Interface, hl = "@type" },
			Key = { icon = kinds.Key, hl = "@type" },
			Method = { icon = kinds.Method, hl = "@method" },
			Module = { icon = kinds.Module, hl = "@namespace" },
			Namespace = { icon = kinds.Namespace, hl = "@namespace" },
			Null = { icon = kinds.Null, hl = "@type" },
			Number = { icon = kinds.Number, hl = "@number" },
			Object = { icon = kinds.Object, hl = "@type" },
			Operator = { icon = kinds.Operator, hl = "@operator" },
			Package = { icon = kinds.Package, hl = "@namespace" },
			Property = { icon = kinds.Property, hl = "@method" },
			String = { icon = kinds.String, hl = "@string" },
			Struct = { icon = kinds.Struct, hl = "@type" },
			TypeParameter = { icon = kinds.TypeParameter, hl = "@parameter" },
			Variable = { icon = kinds.Variable, hl = "@constant" },
		},
	},
})
