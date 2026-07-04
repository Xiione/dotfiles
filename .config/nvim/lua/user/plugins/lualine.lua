return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- dependencies = { "AndreM222/copilot-lualine" },
	opts = function()
		local sidebars = require("user.lib.sidebars")
		local colors = require("user.cfg.colors")
		local icons = require("user.cfg.icons")
		local nord = require("lualine.themes.nord")
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
			nord[mode] = {
				a = { fg = colors.nord0, bg = color, gui = "bold" },
				b = { fg = color, bg = colors.nord1 },
				c = { fg = colors.nord4, bg = colors.nord0 },
			}
		end

		nord.inactive = {
			a = { fg = colors.nord2, bg = colors.nord2, gui = "bold" },
			b = { fg = colors.nord1, bg = colors.nord1 },
			c = { fg = colors.nord4, bg = colors.nord0 },
			y = { fg = colors.nord3, bg = colors.nord1 },
			z = { fg = colors.nord0, bg = colors.nord2, gui = "bold" },
		}

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = icons.diagnostic.error .. " ", warn = icons.diagnostic.warn .. " " },
			colored = false,
			always_visible = true,
		}

		return {
			options = {
				globalstatus = false,
				icons_enabled = true,
				theme = nord,
				component_separators = "",
				section_separators = "",
				disabled_filetypes = {
					statusline = sidebars.sidebar_types,
				},
			},
			sections = {
				lualine_a = { { "mode", padding = 1 } },
				lualine_b = { diagnostics },
				lualine_c = { "grapple" },
				lualine_x = { "filetype" },
				lualine_y = { { "progress", padding = 1 } },
				lualine_z = { { "location", padding = 1 } },
			},
			inactive_sections = {
				lualine_a = { { "mode", padding = 1 } },
				lualine_b = { diagnostics },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { { "progress", padding = 1 } },
				lualine_z = { { "location", padding = 1 } },
			},
		}
	end,
}
