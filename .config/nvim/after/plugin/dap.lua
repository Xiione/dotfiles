local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end
local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

local core = require("user.lib.core")
local utils = require("user.lib.utils")
local sidebars = require("user.lib.sidebars")
local keymaps = require("user.cfg.keymaps")
local mason_path = vim.fn.glob(vim.fn.stdpath("data")) .. "/mason"
local mason_bin_path = mason_path .. "/bin"

-- servers launched internally in neovim
local internal_servers = { codelldb = "codelldb server" }

local M = {}

-- adapters
dap.adapters.python = {
	type = "executable",
	command = "python3",
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
	icons = { expanded = "", collapsed = "", circular = "", current_frame = "" },
	mappings = {
		expand = { "<CR>", "l" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.45 },
				{ id = "breakpoints", size = 0.1 },
				{ id = "stacks", size = 0.1 },
				{ id = "watches", size = 0.1 },
				{ id = "repl", size = 0.25 },
			},
			size = 80,
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
	floating = { border = "solid", mappings = { close = { "q", "<esc>" } } },
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

local function start_session()
	keymaps.setup_dap_maps()
    sidebars.open("dapui")
end

local function terminate_session()
	keymaps.remove_dap_maps()
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
