local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colors")
local supermaven = require("supermaven-nvim.api")

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

local supermaven_status = function()
    return supermaven.is_running() and "" or ""
end


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

local winbar_settings = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {
		{
			"filetype",
			padding = { left = 1, right = 0 },
			icon_only = true,
			color = { bg = "bg" },
		},
		{
			"filename",
			padding = 0,
			path = 0,
			color = { fg = "fg", bg = "bg" },
			symbols = {
				modified = "[+]",
			},
		},
	},
	lualine_x = {},
	lualine_y = {},
	lualine_z = {},
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
			-- statusline = { "alpha" },
			-- winbar = vim.tbl_extend("force", sidebars.sidebar_types, { "alpha" }),
		},
	},
	sections = {
		lualine_a = { { "mode", padding = 1 } },
		lualine_b = { diagnostics },
		-- lualine_c = { diff },
		lualine_c = { "grapple" },
		lualine_x = {
            supermaven_status,
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
	-- winbar = winbar_settings,
})
