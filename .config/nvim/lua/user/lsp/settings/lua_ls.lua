return {
	settings = {
		Lua = {
			window = {
				progressBar = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
			},
		},
	},
}
