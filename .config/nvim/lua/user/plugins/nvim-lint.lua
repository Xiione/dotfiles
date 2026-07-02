return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>ll",
			function()
				require("user.lsp.lint").try_lint()
			end,
			desc = "Lint buffer",
		},
		{
			"<leader>lL",
			function()
				require("user.lsp.lint").try_all()
			end,
			desc = "Lint buffer with all configured linters",
		},
	},
}
