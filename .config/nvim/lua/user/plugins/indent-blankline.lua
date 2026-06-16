return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		local sidebars = require("user.lib.sidebars")
		local colors = require("user.cfg.colors")
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IblRainbowRed", { fg = colors.nord11 })
			vim.api.nvim_set_hl(0, "IblRainbowYellow", { fg = colors.nord13 })
			vim.api.nvim_set_hl(0, "IblRainbowCyan", { fg = colors.nord8 })
		end)

		require("ibl").setup({
			exclude = {
				buftypes = { "terminal", "nofile" },
				filetypes = sidebars.sidebar_types,
			},
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
				highlight = "IblRainbowCyan",
			},
		})
	end,
}
