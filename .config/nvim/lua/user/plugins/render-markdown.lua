local utils = require("user.lib.utils")
local icons = require("user.cfg.icons")

local heading_signs = vim.tbl_map(function(icon)
	return icon .. " "
end, icons.markdown_heading)
local hidden_heading_icons = vim.tbl_map(function()
	return ""
end, icons.markdown_heading)

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "Avante" },
	opts = {
		file_types = { "markdown", "Avante" },
		latex = { enabled = false },
		win_options = { conceallevel = { rendered = 2 } },
		code = {
			border = "none",
			language_border = "",
		},
		heading = {
			icons = hidden_heading_icons,
			signs = heading_signs,
		},
		on = {
			attach = function()
				-- nabla
				vim.keymap.set("n", "K", function()
					require("nabla").popup({
						border = utils.window_border,
					})
				end, { buffer = 0, silent = true })
			end,
		},
	},
}
