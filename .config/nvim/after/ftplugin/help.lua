vim.opt_local.buflisted = false

vim.keymap.set("n", "K", function()
	local keys = vim.v.count > 0 and (vim.v.count .. "K") or "K"
	vim.cmd("normal! " .. keys)
end, { buffer = true, silent = true, desc = "Run keywordprg" })
