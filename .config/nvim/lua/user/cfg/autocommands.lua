local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local sidebars = require("user.lib.sidebars")

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
	pattern = { "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

autocmd({ "BufWinEnter" }, {
	callback = function()
		if vim.bo.filetype:match("dap") then
			sidebars.use_sidebar_hl({ cursorline = false, signcolumn = false })
		end
	end,
})

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
		vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
	end,
})

-- autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.java" },
-- 	callback = function()
-- 		vim.lsp.codelens.refresh()
-- 	end,
-- })

-- autocmd({ "VimEnter" }, {
--     callback = function()
--         vim.cmd("hi link illuminatedWord LspReferenceText")
--     end,
-- })

-- autocmd({ "BufWinEnter" }, {
-- 	callback = function()
-- 	local line_count = vim.api.nvim_buf_line_count(0)
-- 		if line_count >= 5000 then
-- 			vim.cmd("IlluminatePauseBuf")
-- 		end
-- 	end,
-- })

autocmd({ "FileType" }, {
	group = augroup("DapRepl", { clear = true }),
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

autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function()
		vim.opt.formatoptions:remove("c")
		vim.opt.formatoptions:remove("r")
		vim.opt.formatoptions:remove("o")
	end,
})

local luasnip = require("luasnip")

autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if
			((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
			and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
			and not luasnip.session.jump_active
		then
			luasnip.unlink_current()
		end
	end,
})

-- fixes telescope winborder until plenary merges winborder fixes
autocmd("User", {
	pattern = "TelescopeFindPre",
	callback = function()
		vim.opt_local.winborder = "none"
		vim.api.nvim_create_autocmd("WinLeave", {
			once = true,
			callback = function()
				vim.opt_local.winborder = "solid"
			end,
		})
	end,
})

-- https://www.reddit.com/r/neovim/comments/1kuj9xm/comment/mv93w7h/
autocmd("FileType", {
	desc = "User: enable treesitter highlighting",
	callback = function(ctx)
		local noHl = { "tex" }
		if vim.list_contains(noHl, ctx.match) then
			return
		end

		-- highlights
		local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

		-- indent
		local noIndent = { "lua", "markdown" }
		if hasStarted and not vim.list_contains(noIndent, ctx.match) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

autocmd("DirChanged", {
	desc = "Neogurt: Change session title on cd",
	pattern = "global",
	callback = function(ctx)
		if not vim.g.neogurt then
			return
		end

		local path = vim.fs.normalize(ctx.file)
		vim.g.neogurt_cmd("session_edit", {
			name = ("%s/%s"):format(
				vim.fs.basename(vim.fs.dirname(path)), -- parent directory’s name
				vim.fs.basename(path) -- last component
			),
		})
	end,
})
