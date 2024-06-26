local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer(0, { virtcolumn = "80" })

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.cmd("compiler gcc")
