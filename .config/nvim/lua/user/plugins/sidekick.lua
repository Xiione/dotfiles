local function installed_tools()
	local tool_commands = {
		aider = "aider",
		amazon_q = "amazon-q",
		codex = vim.fn.expand("~/.codex/bin/codex-terminal-filter"),
		copilot = "copilot",
		crush = "crush",
		cursor = "cursor",
		gemini = "gemini",
		grok = "grok",
		opencode = "opencode",
		pi = "pi",
		qwen = "qwen",
	}

	local tools = {}
	for name, command in pairs(tool_commands) do
		if vim.fn.executable(command) == 1 then
			tools[name] = {}
		end
	end

	if tools.codex ~= nil then
		tools.codex = {
			cmd = { vim.fn.expand("~/.codex/bin/codex-terminal-filter") },
			is_proc = "\\<codex\\>\\|\\<codex-terminal-filter\\>",
		}
	end

	return tools
end

return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			tools = installed_tools(),
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
