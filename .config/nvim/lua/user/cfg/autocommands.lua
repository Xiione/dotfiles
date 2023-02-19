local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require("user.lib.utils")

autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

autocmd({ "FileType" }, {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

autocmd({ "BufWinEnter" }, {
	callback = function()
        if vim.bo.filetype:match("dap") then
            utils.sidebar({ cursorline = false, signcolumn = false })
        end
	end,
})

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

autocmd({ "CmdWinEnter" }, {
	callback = function()
		vim.cmd("quit")
	end,
})

autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
	end,
})

-- autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.java" },
-- 	callback = function()
-- 		vim.lsp.codelens.refresh()
-- 	end,
-- })

autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})

-- autocmd({ "BufWinEnter" }, {
-- 	callback = function()
-- 	local line_count = vim.api.nvim_buf_line_count(0)
-- 		if line_count >= 5000 then
-- 			vim.cmd("IlluminatePauseBuf")
-- 		end
-- 	end,
-- })

autocmd({ "FileType" }, {
    group = augroup("DapRepl", {clear = true}),
	pattern = { "dap-repl" },
	callback = function()
        vim.opt_local.buflisted = false
	end,
})

-- autocmd({ "ColorScheme" }, {
--     group = augroup("nord", {clear = false}),
--     callback = function ()
--         require("nord.util").onColorScheme()
--     end
-- })
