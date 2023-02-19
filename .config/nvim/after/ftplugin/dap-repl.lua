local utils = require("user.lib.utils")
utils.sidebar({ signcolumn = false, cursorline = false })

vim.api.nvim_set_hl(0, "WinBar", { link = "NormalSidebar" })

