local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colorscheme")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = "󰏫 ", removed = "󰇾 " }, -- changes diff symbols
	cond = hide_in_width,
}
local filetype = {
	"filetype",
	icons_enabled = true,
}

local mynord = require("lualine.themes.nord")
local mode_colors = {
	normal = colors.nord4,
	insert = colors.nord9,
	visual = colors.nord7,
	replace = colors.nord13,
	command = colors.nord12,
	terminal = colors.nord15,
	select = colors.nord10,
}

for mode, color in pairs(mode_colors) do
	mynord[mode] = {
		a = {
			fg = colors.nord0,
			bg = color,
			gui = "bold",
		},
		b = {
			fg = color,
			bg = colors.nord1,
		},
		c = { fg = colors.nord4, bg = colors.nord0 },
	}
end

mynord.inactive = {
	c = {
		fg = colors.nord3,
		bg = colors.nord0,
	},
}

lualine.setup({
	options = {
		globalstatus = false,
		icons_enabled = true,
		theme = mynord,
		component_separators = "",
		section_separators = "",
		ignore_focus = sidebars.sidebar_types,
		disabled_filetypes = {
			statusline = { "alpha" },
			winbar = sidebars.sidebar_types,
		},
	},
	sections = {
		lualine_a = { { "mode", padding = 1 } },
		lualine_b = { diagnostics },
		-- lualine_c = { diff },
		lualine_c = { "grapple" },
		lualine_x = {
			"filetype",
		},
		lualine_y = { { "progress", padding = 1 } },
		lualine_z = { { "location", padding = 1 } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
