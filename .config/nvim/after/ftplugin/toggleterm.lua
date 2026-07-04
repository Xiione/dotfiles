vim.opt_local.sidescrolloff = 0

local utils = require("user.lib.utils")
utils.map("n", "<Up>", "<Up>", { silent = true }, vim.api.nvim_get_current_buf())
utils.map("n", "<Down>", "<Down>", { silent = true }, vim.api.nvim_get_current_buf())
utils.map("n", "<ScrollWheelLeft>", "<Nop>", { silent = true }, vim.api.nvim_get_current_buf())
utils.map("n", "<ScrollWheelRight>", "<Nop>", { silent = true }, vim.api.nvim_get_current_buf())
utils.map("t", "<C-q>", function()
	vim.cmd.stopinsert()
end, { silent = true }, vim.api.nvim_get_current_buf())
