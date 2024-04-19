local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer(0, { virtcolumn = "100" })

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
