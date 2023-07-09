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
	utils.exec_cmd({
		cmd = "codelldb --port 13000",
		dir = vim.fn.expand("%:p:h"),
		open = false,
	})
	vim.defer_fn(function()
		callback({ type = "server", host = "127.0.0.1", port = 13000 })
	end, 150)
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
		program = "${fileDirname}/${fileBasenameNoExtension}",
		args = {},
		terminal = "integrated",
		console = "integratedTerminal",
	},
}

dap.configurations.cpp = {
	{
		type = "codelldb",
		request = "launch",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		program = "${fileDirname}/${fileBasenameNoExtension}",
		args = {},
		terminal = "integrated",
		console = "integratedTerminal",
	},
}
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
				{ id = "scopes", size = 0.33 },
				{ id = "breakpoints", size = 0.17 },
				{ id = "stacks", size = 0.125 },
				{ id = "watches", size = 0.125 },
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
	floating = { border = "solid", mappings = { close = { "q", "<esc>" } } },
})

local types_enabled = false
dapui.update_render({ max_type_length = types_enabled and -1 or 0 })

-- remove debugging keymaps
local function remove_maps()
	-- utils.unmap("n", "<M-b>")
	-- utils.unmap("n", "<M-S-b>")
	utils.unmap({ "n", "v" }, "<M-k>")
	utils.unmap("n", "<M-1>")
	utils.unmap("n", "<M-2>")
	utils.unmap("n", "<M-3>")
end

-- setup debugging keymaps
local function setup_maps()
	utils.map({ "n", "v" }, "<M-k>", dapui.eval)
	utils.map("n", "<M-1>", dap.continue)
	utils.map("n", "<M-2>", dap.step_over)
	utils.map("n", "<M-3>", dap.terminate)
	utils.map("n", "<M-4>", dap.step_into)

	-- utils.map("n", "<m-q>", function()
	-- 	remove_maps()
	-- 	dap.close()
	-- end)
	--
	-- utils.map("n", "<f4>", dapui.toggle)
end

local function start_session()
	setup_maps()
	require("nvim-tree.api").tree.close()
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
-- general keymaps
utils.map("n", "<F5>", function()
	dap.continue()
end)
utils.map("n", "<F4>", function()
	require('nvim-tree.api').tree.close()
    -- vim.wait(100, dapui.toggle)
    dapui.toggle()
end)
utils.map("n", "<M-b>", dap.toggle_breakpoint)
utils.map("n", "<M-S-b>", function()
	local condition = vim.fn.input("Breakpoint condition: ")
	if condition then
		dap.set_breakpoint(condition)
	end
end)

return { remove_maps = remove_maps, setup_maps = setup_maps }
