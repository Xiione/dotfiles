local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
	return
end

local utils = require("user.lib.utils")

lsp_signature.setup({
	bind = true,
	doc_lines = 0,
	handler_opts = {
		border = utils.window_border,
	},
	hi_parameter = "LspSignatureActiveParameter",
	hint_enable = false,
})
