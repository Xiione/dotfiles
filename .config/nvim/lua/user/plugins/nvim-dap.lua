return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"Weissle/persistent-breakpoints.nvim",
	},
	config = function()
		require("user.cfg.nvim-dap")
	end,
}
