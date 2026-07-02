return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
		{
			"<leader>lF",
			function()
				require("conform").format({ async = false, timeout_ms = 3000, lsp_format = "fallback" })
			end,
			desc = "Format buffer synchronously",
		},
	},
}
