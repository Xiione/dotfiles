return {
	cli = {
		tools = {
			codex = {
				cmd = { vim.fn.expand("~/.codex/bin/codex-terminal-filter") },
				is_proc = "\\<codex\\>\\|\\<codex-terminal-filter\\>",
			},
		},
		prompts = {
			diagnostics = "{diagnostics}",
			diagnostics_all = "{diagnostics_all}",
		},
		win = {
			keys = {
				nav_right = {
					"<C-l>",
					function() end,
					mode = "t",
					desc = "Ignore Ctrl-L in Sidekick terminal", -- codex clear chat is annoying and i dont need it
				},
			},
		},
		mux = {
			backend = "zellij",
			enabled = true,
		},
	},
	nes = {
		enabled = false,
	},
}
