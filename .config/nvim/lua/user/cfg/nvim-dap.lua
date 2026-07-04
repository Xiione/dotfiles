local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end
local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

-- this has to load first because a bunch of random things use dap later

local core = require("user.lib.core")
local utils = require("user.lib.utils")
local sidebars = require("user.lib.sidebars")
local map = utils.map
local unmap = utils.unmap
local mason_path = vim.fn.glob(vim.fn.stdpath("data")) .. "/mason"
local mason_bin_path = mason_path .. "/bin"
local debugpy_python = mason_path .. "/packages/debugpy/venv/bin/python"
if vim.fn.executable(debugpy_python) ~= 1 then
	debugpy_python = vim.fn.exepath("python3")
end

-- adapters
dap.adapters.python = {
	type = "executable",
	command = debugpy_python,
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = mason_bin_path .. "/codelldb",
		args = { "--port", "${port}" },
	},
}

-- language configurations
dap.configurations.python = {
	{
		name = "python",
		type = "python",
		request = "launch",
		program = "${file}",
		terminal = "console",
		console = "integratedTerminal",
		pythonPath = core.get_python(),
	},
}

dap.configurations.c = {
	{
		name = "codelldb",
		type = "codelldb",
		request = "launch",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		program = utils.get_dap_executable,
		args = {},
		terminal = "integrated",
		console = "integratedTerminal",
	},
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.cpp

dap.configurations.scala = {
	{
		type = "scala",
		request = "launch",
		name = "RunOrTest",
		metals = {
			runType = "runOrTestFile",
			--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
		},
	},
	{
		type = "scala",
		request = "launch",
		name = "Test Target",
		metals = {
			runType = "testTarget",
		},
	},
}

-- nvim-dap-go manages go config
require("dap-go").setup()

-- repl setup
dap.repl.commands = vim.tbl_extend("force", dap.repl.commands, {
	exit = { "q", "exit" },
	custom_commands = {
		[".run_to_cursor"] = dap.run_to_cursor,
		[".restart"] = dap.run_last,
	},
})

-- dapui setup
dapui.setup({
	icons = {
		expanded = icons.ui.expanded,
		collapsed = icons.ui.collapsed,
		current_frame = icons.debug.current_frame,
	},
	mappings = {
		expand = "l",
		open = { "<CR>", "o", "<2-LeftMouse>" },
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.45 },
				{ id = "breakpoints", size = 0.15 },
				{ id = "stacks", size = 0.15 },
				-- { id = "watches", size = 0.1 },
				{ id = "repl", size = 0.25 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "console", size = 1.0 },
			},
			size = 0.25,
			position = "bottom",
		},
	},
	floating = { border = utils.window_border, mappings = { close = { "q", "<Esc>" } } },
	element_mappings = {},
	expand_lines = true,
	force_buffers = true,
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "",
			pause = "",
			play = "",
			run_last = "",
			step_back = "",
			step_into = "",
			step_out = "",
			step_over = "",
			terminate = "",
		},
	},
	render = {
		indent = 2,
		max_value_lines = 100,
		max_type_length = 12,
	},
})

local session_keys = {
	"<M-1>",
	"<M-S-q>",
	"<M-2>",
	"<M-S-w>",
	"<M-3>",
	"<M-4>",
}
local original_hover_map
local has_session_maps = false

local function find_global_map(mode, lhs)
	for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
		if mapping.lhs == lhs then
			return mapping
		end
	end
end

local function restore_global_map(mode, lhs, mapping)
	if mapping == nil then
		return
	end

	local rhs = mapping.callback or mapping.rhs
	if rhs == nil then
		return
	end

	vim.keymap.set(mode, lhs, rhs, {
		desc = mapping.desc,
		expr = mapping.expr == 1,
		nowait = mapping.nowait == 1,
		remap = mapping.noremap == 0,
		silent = mapping.silent == 1,
	})
end

local function setup_session_maps()
	if has_session_maps then
		return
	end

	has_session_maps = true
	original_hover_map = find_global_map("n", "K")
	unmap("n", "K")
	map({ "n", "v" }, "K", dapui.eval, { silent = true, desc = "Evaluate expression" })
	map("n", "<M-1>", dap.continue, { desc = "Continue debugging" })
	map("n", "<M-S-q>", dap.run_to_cursor, { desc = "Run to cursor" })
	map("n", "<M-2>", dap.step_over, { desc = "Step over" })
	map("n", "<M-S-w>", dap.step_into, { desc = "Step into" })
	map("n", "<M-3>", dap.terminate, { desc = "Terminate debugging" })
	map("n", "<M-4>", dap.run_last, { desc = "Run last debug configuration" })
end

local function remove_session_maps()
	if not has_session_maps then
		return
	end

	has_session_maps = false
	unmap({ "n", "v" }, "K")
	restore_global_map("n", "K", original_hover_map)
	original_hover_map = nil

	for _, lhs in ipairs(session_keys) do
		unmap("n", lhs)
	end
end

local function start_session()
	setup_session_maps()
	sidebars.open("dapui")
end

local function terminate_session()
	remove_session_maps()
end

-- dap events
dap.listeners.after.event_initialized["dapui"] = start_session
dap.listeners.before.event_terminated["dapui"] = terminate_session
dap.listeners.before.event_exited["dapui"] = terminate_session
dap.defaults.fallback.focus_terminal = true

-- signs
vim.fn.sign_define(
	"DapStopped",
	{ text = "", texthl = "DapBreakpointSign", linehl = "DapBreakpointSign", numhl = "" }
)
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpointSign", linehl = "", numhl = "DapBreakpointSign" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DiagnosticWarning", linehl = "", numhl = "DiagnosticWarning" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "", texthl = "DapBreakpointSign", linehl = "", numhl = "DapBreakpointSign" }
)
