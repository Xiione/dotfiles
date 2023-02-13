local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer({ virtcolumn = "80" })

local utils = require("user.lib.utils")

local cmd_build = "g++ " .. utils.resolve_spaces(vim.fn.expand("%:p")) ..
            " -std=gnu++17" ..
            " -o " .. utils.resolve_spaces(vim.fn.expand("%:p:r"))
utils.setup_build_command("n", "<M-c>", cmd_build)

local cmd_build_debug = cmd_build .. " -g"
utils.setup_debug_command("n", "<M-d>", cmd_build_debug)

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
