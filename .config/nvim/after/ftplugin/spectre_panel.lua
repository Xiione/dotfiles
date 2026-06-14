local sidebars = require("user.lib.sidebars")
sidebars.use_sidebar_hl({ signcolumn = false, cursorline = false })
vim.opt_local.buflisted = false

vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true })
