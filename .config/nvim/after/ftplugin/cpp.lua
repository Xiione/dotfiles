local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer({ virtcolumn = "80" })

local utils = require("user.lib.utils")

utils.map("n", "<leader>r", function()
	local cmd = utils.resolve_spaces(vim.fn.expand("%:p:r"))
	utils.send_cmd(cmd, "%:p:h")
end)

utils.map("n", "<leader>b", function()
	local cmd = "g++ " .. utils.resolve_spaces(vim.fn.expand("%:p")) ..
                " -std=gnu++17" ..
                " -g" ..
                " -O2" ..
                " -o " .. utils.resolve_spaces(vim.fn.expand("%:p:r"))
	utils.send_cmd(cmd, "%:p:h")
end)

vim.opt_local.shiftwidth = 2
