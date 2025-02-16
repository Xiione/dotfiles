local misc = require("user.lib.misc")

local M = {}

local dapui = require("dapui")
local nvim_tree = require("nvim-tree.api")

M.make_winhighlight = function(opts)
	return "Normal:NormalSidebar,SignColumn:NormalSidebar,CursorLine:NormalSidebar"
		.. (opts.cursorline and "" or ",CursorLine:NormalSidebar")
end

-- used instead of contrast() in nord/util.lua
M.use_sidebar_hl = function(opts)
	vim.opt_local.winhighlight = M.make_winhighlight(opts)
    vim.opt_local.signcolumn = opts.signcolumn and "yes" or "no"
	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.cursorline = false
	vim.opt.cursorlineopt = opts.cursorline and "both" or "number"
	vim.opt_local.statuscolumn = "%="
end

M.sidebar_types = {
	"dap-repl",
	"dapui_breakpoints",
	"dapui_console",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"diff",
	"help",
	"Outline",
	"qf",
	"man",
	"NvimTree",
	"undotree",
	"vimtex-toc",
	"TelescopeResults",
	"TelescopePrompt",
	"toggleterm",
}
M.sidebar_types_set = misc.to_set(M.sidebar_types)

local undo_tree_open = false
local vimtex_toc_open = false

M.sidebar_functions = {
	dapui = {
		exclusive = true,
		is_right_side = false,
		toggle = dapui.toggle,
		open = dapui.open,
		close = dapui.close,
	},
	nvimtree = {
		exclusive = false,
		is_right_side = false,
		toggle = nvim_tree.tree.toggle,
		open = nvim_tree.tree.open,
		close = nvim_tree.tree.close,
	},
	undotree = {
		exclusive = false,
		is_right_side = true,
		toggle = function()
			vim.cmd("UndotreeToggle")
			undo_tree_open = not undo_tree_open
			if undo_tree_open then
				vim.cmd("UndotreeFocus")
			end
		end,
		open = function()
			vim.cmd("UndotreeShow")
			vim.cmd("UndotreeFocus")
			undo_tree_open = true
		end,
		close = function()
			vim.cmd("UndotreeHide")
			undo_tree_open = false
		end,
	},
	vimtex_toc = {
		exclusive = false,
		is_right_side = false,
		toggle = function()
			vim.cmd("VimtexTocToggle")
			vimtex_toc_open = not vimtex_toc_open
		end,
		open = function()
			vim.cmd("VimtexTocOpen")
			vimtex_toc_open = true
		end,
		close = function()
			if vimtex_toc_open then
				vim.cmd("VimtexTocToggle")
				vimtex_toc_open = false
			end
		end,
	},
	symbols_outline = {
		exclusive = false,
		is_right_side = true,
		toggle = function()
			vim.cmd("Outline")
		end,
		open = function()
			vim.cmd("OutlineOpen")
		end,
		close = function()
			vim.cmd("OutlineClose")
		end,
	},
}

M.toggle = function(sidebar)
	-- get target of toggle
	local target = M.sidebar_functions[sidebar]
	local is_right_side = target.is_right_side

	-- first close the sidebar that may be open on the appropriate side
	for key, val in pairs(M.sidebar_functions) do
		if target.exclusive or val.exclusive or val.is_right_side == is_right_side then
			if key ~= sidebar then
				-- symbols-outline throws an error when it's 'closed' when it isn't open
				pcall(val.close)
			end
		end
	end

	-- finally toggle the target sidebar
	target.toggle()
end

M.open = function(sidebar)
	local target = M.sidebar_functions[sidebar]
	local is_right_side = target.is_right_side

	for key, val in pairs(M.sidebar_functions) do
		if target.exclusive or val.exclusive or val.is_right_side == is_right_side then
			if key ~= sidebar then
				pcall(val.close)
			end
		end
	end

	pcall(target.open)
end

M.close = function(sidebar)
	local target = M.sidebar_functions[sidebar]
	pcall(target.close)
end

return M
