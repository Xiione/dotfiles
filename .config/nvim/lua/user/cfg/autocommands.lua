local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local neogurt = require("user.lib.neogurt")
local sidebars = require("user.lib.sidebars")

local virt_columns = {
	c = 80,
	cpp = 80,
	glsl = 80,
	java = 100,
	javascript = 80,
	json = 80,
	kotlin = 80,
	python = 80,
	ruby = 100,
	scala = 80,
	sh = 80,
	svelte = 80,
	tex = 80,
	typescript = 80,
	typescriptreact = 80,

	gitcommit = 72,
	rust = 100,
}

autocmd("FileType", {
	group = augroup("VirtColumnByFiletype", { clear = true }),
	pattern = vim.tbl_keys(virt_columns),
	callback = function(ctx)
		local ok, virt_column = pcall(require, "virt-column")
		if not ok then
			return
		end

		virt_column.setup_buffer(ctx.buf, {
			virtcolumn = tostring(virt_columns[vim.bo[ctx.buf].filetype]),
		})
	end,
})

local sidebar_cursorline_filetypes = {
	DiffviewFiles = true,
	DiffviewFileHistory = true,
	NvimTree = true,
	Outline = true,
	qf = true,
}

local function apply_sidebar_highlights(ctx)
	local filetype = vim.bo[ctx.buf].filetype
	if sidebars.sidebar_types_set[filetype] == nil then
		return
	end

	local opts = {
		cursorline = sidebar_cursorline_filetypes[filetype] == true,
		signcolumn = false,
	}

	if filetype == "qf" then
		opts.highlights = { "Delimiter:QuickFixDelimiter" }
	end

	sidebars.use_sidebar_hl(opts)
end

autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
	group = augroup("SidebarHighlights", { clear = true }),
	callback = apply_sidebar_highlights,
})

autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- autocmd({ "CmdWinEnter" }, {
-- 	callback = function()
-- 		vim.cmd("quit")
-- 	end,
-- })

autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank({ higroup = "Search", timeout = 200 })
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

autocmd("User", {
	group = augroup("PersistenceSkipQuickfix", { clear = true }),
	pattern = "PersistenceSavePre",
	callback = function()
		for _, win in ipairs(vim.fn.getwininfo()) do
			if win.quickfix == 1 then
				pcall(vim.api.nvim_win_close, win.winid, true)
			end
		end
	end,
})

autocmd("User", {
	group = augroup("PersistenceSkipQuickfix", { clear = true }),
	pattern = "PersistenceSavePre",
	callback = function()
		for _, win in ipairs(vim.fn.getwininfo()) do
			if win.quickfix == 1 then
				pcall(vim.api.nvim_win_close, win.winid, true)
			end
		end
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

autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		local luasnip = package.loaded["luasnip"]
		if not luasnip then
			return
		end

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
		local noIndent = { "lua", "markdown", "kotlin", "ql" }
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

		vim.g.neogurt_cmd("session_edit", {
			name = neogurt.session_name(ctx.file),
		})
	end,
})
