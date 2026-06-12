local sidebars = require("user.lib.sidebars")
sidebars.use_sidebar_hl({ signcolumn = false, cursorline = false })
vim.opt_local.buflisted = false

vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "K", function()
	local keys = vim.v.count > 0 and (vim.v.count .. "K") or "K"
	vim.cmd("normal! " .. keys)
end, { buffer = true, silent = true, desc = "Run keywordprg" })
