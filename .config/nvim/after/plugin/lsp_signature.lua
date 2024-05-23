local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
	return
end

lsp_signature.setup({
	bind = true,
    doc_lines = 0,
	handler_opts = {
		border = "solid",
	},
	hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
	hint_enable = false,
})
