return {
	"mrcjkb/rustaceanvim",
	version = "^4",
	ft = { "rust" },
	init = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = require("user.lsp.handlers").on_attach,
			},
		}
	end,
}
