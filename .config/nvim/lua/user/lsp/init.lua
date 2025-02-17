local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

local utils = require("user.lib.utils")

require("lspconfig.ui.windows").default_options.border = utils.window_border

require("user.lsp.mason")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
