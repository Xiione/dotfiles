local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
