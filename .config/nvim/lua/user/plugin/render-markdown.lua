local utils = require("user.lib.utils")

return {
	file_types = { "markdown", "Avante" },
	latex = { enabled = false },
	win_options = { conceallevel = { rendered = 2 } },
	code = {
		border = "none",
		language_border = "",
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
}
