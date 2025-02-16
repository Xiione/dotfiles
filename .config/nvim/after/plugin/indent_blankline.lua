local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colors")

local hooks = require("ibl.hooks")

-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "IblRainbowRed", { fg = colors.nord11 })
	vim.api.nvim_set_hl(0, "IblRainbowYellow", { fg = colors.nord13 })
	vim.api.nvim_set_hl(0, "IblRainbowCyan", { fg = colors.nord8 })
end)

local highlight = {
	"IblRainbowCyan",
	"IblRainbowRed",
	"IblRainbowYellow",
}

indent_blankline.setup({
	exclude = {
		buftypes = { "terminal", "nofile" },
		filetypes = sidebars.sidebar_types,
	},
	indent = {
		char = "▏",
        -- highlight = highlight
	},
	scope = {
		show_start = false,
		show_end = false,
        highlight = highlight
	},
})
