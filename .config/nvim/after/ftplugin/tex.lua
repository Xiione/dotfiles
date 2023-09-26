local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer(0, { virtcolumn = "80" })

local utils = require("user.lib.utils")

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.spell = true
-- vim.opt_local.wrap = true
