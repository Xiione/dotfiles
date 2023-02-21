local dap = require("dap")
local dapui = require("dapui")
local toggleterm = require("toggleterm")

local M = {}

local commands = {
	keys = {},
	callbacks = {},
}

-- toggleterm needs to be opened at least once for silent/non-open commands to execute properly
local initalized = false

M.map = function(mode, lhs, rhs, opts, bufnr)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	if bufnr then
		options["buffer"] = bufnr
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

M.unmap = function(mode, lhs, bufnr)
	local options = {}
	if bufnr then
		options["buffer"] = bufnr
	end

	-- vim.keymap.del(mode, lhs, options)
	pcall(vim.keymap.del, mode, lhs, options)
end

-- add custom command
M.add_command = function(key, callback, cmd_opts, also_custom)
	-- opts defined, create user command
	if cmd_opts and next(cmd_opts) then
		vim.api.nvim_create_user_command(key, callback, cmd_opts)
	end

	-- create custom command
	if also_custom then
		-- assert opts not defined, or 0 args
		assert((not cmd_opts) or not cmd_opts.nargs or cmd_opts.nargs == 0)
		if commands.callbacks[key] == nil then
			table.insert(commands.keys, key)
		end

		if type(callback) == "function" then
			commands.callbacks[key] = callback
		else
			commands.callbacks[key] = function()
				vim.api.nvim_command(callback)
			end
		end
	end
end

M.resolve_spaces = function(str)
	return string.gsub(str, "%s", "\\ ")
end

M.exec_cmd = function(args)
	vim.cmd("wall")
	if type(args) == "string" then
		toggleterm.exec(vim.fn.expandcmd(args), vim.v.count, nil, nil, nil, nil, nil)
	else
		if not initalized then
			local Terminal = require("toggleterm.terminal").Terminal
			Terminal:new({
				cmd = vim.fn.expandcmd(args.cmd),
				count = vim.v.count,
				dir = args.dir,
			})
			initalized = true
		else
			toggleterm.exec(vim.fn.expandcmd(args.cmd), vim.v.count, nil, args.dir, nil, nil, args.open)
		end
	end
end

M.send_return = function()
	M.exec_cmd({
		cmd = "q\x03",
		dir = nil,
		open = false,
	})
end

M.add_callback_flags = function(cmd, on_success, on_failure)
	return cmd .. [[ && ]] .. on_success .. [[ || ]] .. on_failure
end

M.flag_build_success = "NV_BUILD_SUCCESS"
M.flag_build_fail = "NV_BUILD_FAIL"
M.flag_ready_debug = "NV_READY_FOR_DEBUG"

M.setup_build_command = function(mode, mapping, cmd)
	M.map(mode, mapping, function()
		print("Building...")
		M.send_return()
		M.exec_cmd({
			cmd = M.add_callback_flags(
				cmd,
				"echo '" .. M.flag_build_success .. "'",
				"echo '" .. M.flag_build_fail .. "'"
			),
			dir = vim.fn.expand("%:p:h"),
			open = false,
		})
	end)
end

M.setup_debug_command = function(mode, mapping, cmd)
	M.map(mode, mapping, function()
		print("Building...")
		M.send_return()
		M.exec_cmd({
			cmd = M.add_callback_flags(
				cmd,
				"echo '" .. M.flag_ready_debug .. "'",
				"echo '" .. M.flag_build_fail .. "'"
			),
			dir = vim.fn.expand("%:p:h"),
			open = false,
		})
		print("Building...")
	end)
end

M.create_packer_snapshot = function()
	local fn = os.date("%y-%m-%d_%H-%M")
	print("Creating new snapshot " .. fn .. "...")
	require("packer").snapshot(fn)
end

local types_enabled = false
M.toggle_scope_types = function()
	types_enabled = not types_enabled
	dapui.update_render({ max_type_length = types_enabled and -1 or 0 })
end

-- used instead of contrast() in nord/util.lua
M.sidebar = function(opts)
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
	"qf",
	"NvimTree",
	"undotree",
}

return M
