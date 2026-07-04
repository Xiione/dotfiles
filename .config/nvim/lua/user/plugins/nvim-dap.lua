return {
	"mfussenegger/nvim-dap",
	lazy = true,
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Continue debugging",
		},
		{
			"<F4>",
			function()
				require("user.lib.sidebars").toggle("dapui")
			end,
			desc = "Toggle DAP UI",
		},
		{
			"<M-b>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<M-S-b>",
			function()
				local icon = require("user.cfg.icons").debug.breakpoint_conditional
				local condition = vim.fn.input(icon .. " Breakpoint condition: ")
				if condition then
					require("dap").toggle_breakpoint(condition)
				end
			end,
			desc = "Set conditional breakpoint",
		},
	},
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"Weissle/persistent-breakpoints.nvim",
	},
	config = function()
		require("user.cfg.nvim-dap")
	end,
}
