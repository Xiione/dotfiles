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

-- servers launched internally in neovim
local internal_servers = { codelldb = "codelldb server" }

-- adapters
dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.codelldb = function(callback, _)
	utils.send_cmd("codelldb --port 13000", vim.fn.expand("%:p:h"), true)
	vim.defer_fn(function()
		callback({ type = "server", host = "127.0.0.1", port = 13000 })
	end, 100)
end

-- language configurations
dap.configurations.python = {
	{
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
		type = "codelldb",
		request = "launch",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
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
	icons = { expanded = "", collapsed = "", circular = "" },
	mappings = {
		expand = {"<CR>", "l"},
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.33 },
				{ id = "breakpoints", size = 0.17 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "console", size = 0.505 },
				{ id = "repl", size = 0.495 },
			},
			size = 0.27,
			position = "bottom",
		},
	},
	floating = { border = "rounded", mappings = { close = { "q", "<esc>" } } },
})

-- remove debugging keymaps
local function remove_maps()
	utils.unmap("n", "<m-d>B")
	utils.unmap({ "n", "v" }, "<m-d>k")
	utils.unmap("n", "<m-1>")
	utils.unmap("n", "<m-2>")
	utils.unmap("n", "<m-3>")
	utils.unmap("n", "<m-q>")
	utils.unmap("n", "<f4>")
end

-- setup debugging keymaps
local function setup_maps()
	utils.map("n", "<m-d>B", function()
		local condition = vim.fn.input("breakpoint condition: ")
		if condition then
			dap.set_breakpoint(condition)
		end
	end)

	utils.map({ "n", "v" }, "<m-d>k", dapui.eval)
	utils.map("n", "<m-1>", dap.step_over)
	utils.map("n", "<m-2>", dap.step_into)
	utils.map("n", "<m-3>", dap.step_out)

	utils.map("n", "<m-q>", function()
		remove_maps()
		dap.close()
	end)

	utils.map("n", "<f4>", dapui.toggle)
end

local function start_session()
	setup_maps()
	dapui.open()

	-- force local statusline
	-- require("user.lib.misc").toggle_global_statusline(true)
end

local function terminate_session()
	remove_maps()
end

-- dap events
dap.listeners.after.event_initialized["dapui"] = start_session
dap.listeners.before.event_terminated["dapui"] = terminate_session
dap.listeners.before.event_exited["dapui"] = terminate_session
dap.defaults.fallback.focus_terminal = true

-- signs
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
-- general keymaps
utils.map("n", "<f5>", function()
	dap.continue()
end)

return { remove_maps = remove_maps, setup_maps = setup_maps }
