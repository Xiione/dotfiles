-- easier leave to previous window
local utils = require("user.lib.utils")
local opts = { remap = true, silent = true, buffer = true }
utils.map("i", "<D-i>", "<C-o><D-i>", opts)

utils.map("i", "<C-h>", "<C-o><C-h>", opts)
utils.map("i", "<C-j>", "<C-o><C-j>", opts)
utils.map("i", "<C-k>", "<C-o><C-k>", opts)
utils.map("i", "<C-l>", "<C-o><C-l>", opts)
