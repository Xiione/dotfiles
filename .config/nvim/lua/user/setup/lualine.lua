local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

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
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = true,
}

local location = {
	"location",
	padding = 1,
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local colors = {
	-- nord0 = "#2E3440", -- i think the nord nvim theme makes all bgs with the nord0 color "none"
	nord0 = "#2E3441",
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

local mynord = require("lualine.themes.nord")

local c = { fg = colors.nord5, bg = colors.nord1 }

mynord.normal = {
	a = {
		fg = colors.nord0,
		bg = colors.nord4,
		gui = "bold",
	},
	b = {
		fg = colors.nord4,
		bg = colors.nord0,
	},
	c = c,
}
mynord.insert = {
	a = {
		fg = colors.nord0,
		bg = colors.nord14,
		gui = "bold",
	},
	b = {
		fg = colors.nord14,
		bg = colors.nord0,
	},
	c = c,
}
mynord.visual = {
	a = {
		fg = colors.nord0,
		bg = colors.nord7,
		gui = "bold",
	},
	b = {
		fg = colors.nord7,
		bg = colors.nord0,
	},
	c = c,
}
mynord.replace = {
	a = {
		fg = colors.nord0,
		bg = colors.nord13,
		gui = "bold",
	},
	b = {
		fg = colors.nord13,
		bg = colors.nord0,
	},
	c = c,
}
mynord.command = {
	a = {
		fg = colors.nord0,
		bg = colors.nord12,
		gui = "bold",
	},
	b = {
		fg = colors.nord12,
		bg = colors.nord0,
	},
	c = c,
}

mynord.terminal = {
	a = {
		fg = colors.nord0,
		bg = colors.nord15,
		gui = "bold",
	},
	b = {
		fg = colors.nord15,
		bg = colors.nord0,
	},
	c = c,
}

lualine.setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		theme = mynord,
		disabled_filetypes = { "alpha" }
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { diagnostics },
		lualine_c = { "branch", diff },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { location },
	},
})
