local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require('lspconfig.ui.windows').default_options.border = 'solid'

require("user.lsp.mason")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
