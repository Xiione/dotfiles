local misc = require("user.lib.misc")

local M = {}

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
    "spectre_panel",
    "Avante",
    "AvanteInput",
    "AvantePromptInput",
    "AvanteSelectedFiles",
}
M.sidebar_types_set = misc.to_set(M.sidebar_types)

local vimtex_toc_open = false
local avante_open = false

M.sidebar_functions = {
	dapui = {
		exclusive = true,
		is_right_side = false,
		toggle = function() return require("dapui").toggle() end,
		open = function() return require("dapui").open() end,
		close = function() return require("dapui").close() end,
	},
	nvimtree = {
		exclusive = false,
		is_right_side = false,
		toggle = function() return require("nvim-tree.api").tree.toggle() end,
		open = function() return require("nvim-tree.api").tree.open() end,
		close = function() return require("nvim-tree.api").tree.close() end,
	},
	undotree = {
		exclusive = false,
		is_right_side = true,
		toggle = function()
			vim.cmd("UndotreeToggle")
		end,
		open = function()
			vim.cmd("UndotreeShow")
		end,
		close = function()
			vim.cmd("UndotreeHide")
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
	-- symbols_outline = {
	-- 	exclusive = false,
	-- 	is_right_side = true,
	-- 	toggle = function()
	-- 		vim.cmd("Outline")
	-- 	end,
	-- 	open = function()
	-- 		vim.cmd("OutlineOpen")
	-- 	end,
	-- 	close = function()
	-- 		vim.cmd("OutlineClose")
	-- 	end,
	-- },
    avante = {
        exclusive = false,
        is_right_side = true,
        toggle = function()
            vim.cmd("AvanteToggle")
            avante_open = not avante_open
        end,
        open = function()
            if not avante_open then
                vim.cmd("AvanteToggle")
                avante_open = true
            end
        end,
        close = function()
            if avante_open then
                vim.cmd("AvanteToggle")
                avante_open = false
            end
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
