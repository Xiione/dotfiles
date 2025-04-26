local dap = require("dap")
local dapui = require("dapui")
local toggleterm = require("toggleterm")

local M = {}

local commands = {
	keys = {},
	callbacks = {},
}

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

-- toggleterm needs to be opened at least once for silent/non-open commands to execute properly
local initalized = false

M.exec_cmd = function(args)
	vim.cmd("wall")
	if type(args) == "string" then
		toggleterm.exec(args, vim.v.count, nil, nil, nil, nil, nil)
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
			toggleterm.exec(args.cmd, vim.v.count, nil, args.dir, nil, nil, args.open)
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

M.setup_build_command = function(mode, mapping, cmd, prepare)
	M.map(mode, mapping, function()
		if prepare then
			prepare()
		end
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
	end, nil, vim.fn.bufnr())
end

M.setup_debug_command = function(mode, mapping, cmd, prepare)
	M.map(mode, mapping, function()
		if prepare then
			prepare()
		end
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
	end, nil, vim.fn.bufnr())
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

local session_dap_executable
M.get_dap_executable = function()
	local makefile = io.open("./Makefile")
	if makefile then
		local executable
		for line in makefile:lines() do
			executable = line:match("^EXECUTABLE%s*=%s*(.+)")
			if executable then
				session_dap_executable = executable
			else
				local cwdbasename = vim.fs.basename(vim.fn.getcwd())
				if io.open(cwdbasename) and os.execute("test -x " .. cwdbasename) == 0 then
					session_dap_executable = cwdbasename
				end
			end
		end
	end
	if not session_dap_executable then
		session_dap_executable = vim.fn.input("  Path to executable: ", vim.fn.getcwd() .. "/", "file")
		return session_dap_executable
	end
	return session_dap_executable
end

M.lspkind_icons = {
	Array = "",
	Boolean = "",
	Class = "",
	Component = "",
	Color = "󰝤",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Fragment = "󰊕",
	Function = "󰊕",
	Interface = "",
	Key = "",
	Keyword = "",
	Method = "󰊕",
	Module = "",
	Namespace = "",
	Null = "󰟢",
	Number = "",
	Object = "",
	Operator = "",
	Package = "󰅩",
	Property = "",
	Reference = "󰈇",
	Snippet = "",
	String = "",
	Struct = "",
	Supermaven = "",
	Text = " ",
	TypeParameter = "",
	Unit = "󰑭",
	Value = "",
	Variable = "",
}

-- M.borderchars = { " ", "▕", " ", "▏", "▏", "▕", "▕", "▏" }
-- M.borderchars = { " ", " ", " ", "▏", "▏", " ", " ", "▏" }
M.borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }
-- ▕x▏
-- M.window_border = { "▏", " ", "▕", "▕", "▕", " ", "▏", "▏" }
M.window_border = { "▎", " ", " ", " ", " ", " ", "▎", "▎" }

M.table_filter = function(t, filter)
	local out = {}
	for k, v in pairs(t) do
		if filter(v, k, t) then
			out[k] = v
		end
	end
	return out
end

M.array_filter = function(a, filter)
	local out = {}
	for k, v in pairs(a) do
		if filter(v, k, a) then
		    table.insert(out, v)
		end
	end
	return out
end

return M
