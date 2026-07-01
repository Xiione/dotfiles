local colors = require("user.cfg.colors")

return {
	"luckasRanarison/tailwind-tools.nvim",
	ft = {
		"html",
		"javascript",
		"javascriptreact",
		"svelte",
		"typescript",
		"typescriptreact",
	},
	opts = {
		server = {
			override = false,
		},
		document_color = {
			enabled = false,
		},
		conceal = {
			enabled = false, -- can be toggled by commands
			min_length = nil, -- only conceal classes exceeding the provided length
			symbol = "", -- only a single character is allowed
			highlight = { -- extmark highlight options, see :h 'highlight'
				fg = colors.nord3L,
			},
		},
		custom_filetypes = {}, -- see the extension section to learn how it works
	},
	config = function(_, opts)
		require("tailwind-tools").setup(opts)

		-- The plugin requests colors on ColorScheme even when its renderer is disabled.
		vim.api.nvim_clear_autocmds({ group = "tailwind_colors" })
	end,
}
