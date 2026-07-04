local icons = require("user.cfg.icons")

return {
	"onsails/lspkind-nvim",
	lazy = true,
	opts = {
		preset = "codicons",
		symbol_map = icons.lsp_kind,
	},
}
