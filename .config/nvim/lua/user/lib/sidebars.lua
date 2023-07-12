local M = {}

local dapui = require("dapui")
local nvim_tree = require("nvim-tree.api")

-- used instead of contrast() in nord/util.lua
M.use_sidebar_hl = function(opts)
	vim.opt_local.winhighlight = "Normal:NormalSidebar,SignColumn:NormalSidebar,CursorLine:NormalSidebar"
		.. (opts.cursorline and "" or ",CursorLine:NormalSidebar")
	vim.opt_local.signcolumn = opts.signcolumn and "yes" or "no"
	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.cursorline = false
	vim.opt.cursorlineopt = opts.cursorline and "both" or "number"
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
	"",
}

local undo_tree_open = false
local vimtex_toc_open = false

M.sidebar_functions = {
	dapui = {
		is_right_side = false,
		toggle = dapui.toggle,
		open = dapui.open,
		close = dapui.close,
	},
	nvimtree = {
		is_right_side = false,
		toggle = nvim_tree.tree.toggle,
		open = nvim_tree.tree.open,
		close = nvim_tree.tree.close,
	},
	undotree = {
		is_right_side = true,
		toggle = function()
			vim.cmd("UndotreeToggle")
			undo_tree_open = not undo_tree_open
		end,
		open = function()
			if not undo_tree_open then
				vim.cmd("UndotreeToggle")
				undo_tree_open = true
			end
		end,
		close = function()
			if undo_tree_open then
				vim.cmd("UndotreeToggle")
				undo_tree_open = false
			end
		end,
	},
	vimtex_toc = {
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
		is_right_side = true,
		toggle = function()
			vim.cmd("SymbolsOutline")
		end,
		open = function()
			vim.cmd("SymbolsOutlineOpen")
		end,
		close = function()
			vim.cmd("SymbolsOutlineClose")
		end,
	},
}

M.toggle = function(sidebar)
	-- get target of toggle
	local target = M.sidebar_functions[sidebar]
	local is_right_side = target.is_right_side

	-- first close the sidebar that may be open on the appropriate side
	for key, val in pairs(M.sidebar_functions) do
		if key ~= sidebar then
			if val.is_right_side == is_right_side then
                -- symbols-outline throws an error when it's 'closed' when it isn't open 
                pcall(val.close)
			end
		end
	end

    -- finally toggle the target sidebar
	target.toggle()
end

return M
