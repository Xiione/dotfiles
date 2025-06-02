-- easier leave to previous window
local utils = require("user.lib.utils")
utils.map("i", "<D-i>", "<C-o><D-i>", { remap = true, silent = true, buffer = true })
