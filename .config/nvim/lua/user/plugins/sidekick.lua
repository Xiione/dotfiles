return {
	"folke/sidekick.nvim",
	lazy = false,
	keys = {
		{
			"<S-Tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<S-Tab>"
				end
			end,
			mode = "i",
			expr = true,
			desc = "Go to/apply next edit suggestion",
		},
		{
			"<D-i>",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").focus("codex")
			end,
			mode = { "n", "t", "i" },
			desc = "Focus Codex",
		},
		{
			"<leader>aa",
			function()
				require("user.lib.sidebars").toggle("sidekick")
			end,
			desc = "Toggle Codex",
		},
		{
			"<leader>a?",
			function()
				require("sidekick.cli").select({ filter = { name = "codex" } })
			end,
			desc = "Select Codex session",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close("codex")
			end,
			desc = "Detach a Codex session",
		},
		{
			"<leader>at",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send this to Codex",
		},
		{
			"<leader>ac",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{file}" })
			end,
			desc = "Send file to Codex",
		},
		{
			"<D-i>",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{selection}" })
			end,
			mode = "x",
			desc = "Send visual selection to Codex",
		},
		{
			"<leader>ap",
			function()
				local cli = require("sidekick.cli")
				cli.prompt(function(_, text)
					if text then
						require("user.lib.sidebars").open("sidekick", true)
						cli.send({ name = "codex", text = text })
					end
				end)
			end,
			mode = { "n", "x" },
			desc = "Select prompt for Codex",
		},
	},
	opts = {
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
	},
}
