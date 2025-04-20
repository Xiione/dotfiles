vim.opt_local.signcolumn = "no"
vim.opt_local.cursorline = false
vim.opt_local.mousescroll = "ver:1,hor:0"

local utils = require("user.lib.utils")
utils.map("n", "<Up>", "<Up>", { silent = true }, vim.api.nvim_get_current_buf())
utils.map("n", "<Down>", "<Down>", { silent = true }, vim.api.nvim_get_current_buf())
