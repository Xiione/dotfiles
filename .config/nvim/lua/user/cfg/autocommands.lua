local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local undo_excluded_extensions = {
	"age",
	"asc",
	"der",
	"enc",
	"enc.json",
	"enc.yaml",
	"encrypted",
	"encrypted.json",
	"encrypted.yaml",
	"env",
	"gpg",
	"jks",
	"key",
	"keytab",
	"keystore",
	"kdbx",
	"p12",
	"p7b",
	"p7c",
	"p8",
	"pk8",
	"pkcs8",
	"pem",
	"pgp",
	"pfx",
	"ppk",
	"secret",
	"secrets",
	"sops.json",
	"sops.yaml",
	"tfplan",
	"tfstate",
	"tfstate.backup",
	"tfvars",
	"tfvars.json",
}

local undo_excluded_names = {
	".dockerconfigjson",
	".envrc",
	".netrc",
	".npmrc",
	".pgpass",
	".pypirc",
	".vault-token",
	"application_default_credentials.json",
	"client_secret.json",
	"credentials",
	"credentials.json",
	"service-account-key.json",
	"service-account.json",
	"token.json",
}

local ssh_private_key_names = { "id_dsa", "id_ecdsa", "id_ed25519", "id_rsa" }

local function has_suffix(name, suffix)
	return name:sub(-#suffix) == suffix
end

local function is_ssh_private_key_name(name)
	for _, key_name in ipairs(ssh_private_key_names) do
		if name == key_name or (name:match("^" .. key_name .. "[_%-].+") and not name:match("%.pub$")) then
			return true
		end
	end
	return false
end

local function is_undo_file(path)
	if path == "" then
		return false
	end

	path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
	local normalized_path = path:lower()
	for _, undo_dir in ipairs(vim.opt.undodir:get()) do
		local normalized_undo_dir = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(undo_dir), ":p")):lower()
		if normalized_path == normalized_undo_dir or vim.startswith(normalized_path, normalized_undo_dir .. "/") then
			return true
		end
	end

	local name = vim.fs.basename(path):lower()
	if
		vim.tbl_contains(undo_excluded_names, name)
		or is_ssh_private_key_name(name)
		or name == ".env"
		or name == "env"
	then
		return true
	end
	if name:match("^%.env[%.%-_].+") or name:match("^env[%.%-_].+") or name:match("^secrets?%.") then
		return true
	end

	for _, extension in ipairs(undo_excluded_extensions) do
		if has_suffix(name, "." .. extension) then
			return true
		end
	end
	return false
end

autocmd({ "BufReadPre", "BufNewFile", "BufWritePre" }, {
	group = augroup("UserUndoFileExclusions", { clear = true }),
	callback = function(ctx)
		if is_undo_file(vim.api.nvim_buf_get_name(ctx.buf)) then
			vim.bo[ctx.buf].undofile = false
		end
	end,
})

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

local sidebar_signcolumn_filetypes = {
	NvimTree = true,
}

local function apply_sidebar_highlights(ctx)
	local filetype = vim.bo[ctx.buf].filetype
	if sidebars.sidebar_types_set[filetype] == nil then
		return
	end

	local opts = {
		cursorline = sidebar_cursorline_filetypes[filetype] == true,
		signcolumn = sidebar_signcolumn_filetypes[filetype] == true,
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

autocmd("User", {
	group = augroup("LazyReloadNotification", { clear = true }),
	pattern = "LazyReload",
	callback = function()
		vim.api.nvim_echo({ { "lazy.nvim config reloaded", "MoreMsg" } }, false, {})
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

local session_title_group = augroup("NeogurtSessionTitle", { clear = true })

local function update_neogurt_session_title(path)
	if not vim.g.neogurt then
		return
	end

	vim.g.neogurt_cmd("session_edit", {
		name = neogurt.session_name(path),
	})
end

autocmd("DirChanged", {
	group = session_title_group,
	desc = "Neogurt: update session title on cd",
	pattern = "global",
	callback = function(ctx)
		update_neogurt_session_title(ctx.file)
	end,
})

autocmd("User", {
	group = session_title_group,
	desc = "Neogurt: update session title on branch change",
	pattern = "GitSignsUpdate",
	callback = function()
		update_neogurt_session_title()
	end,
})
