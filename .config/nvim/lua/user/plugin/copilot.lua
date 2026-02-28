local sidebars = require("user.lib.sidebars")

local disabled = {
	yaml = false,
	markdown = false,
	help = false,
	gitcommit = false,
	gitrebase = false,
	hgcommit = false,
	svn = false,
	cvs = false,
	["."] = false,
}
for _, ft in ipairs(sidebars.sidebar_types) do
	disabled[ft] = false
end
local filetypes = disabled

return {
	panel = {
		enabled = false,
	},
	suggestion = {
		enabled = true,
		auto_trigger = false,
		trigger_on_accept = true,
		keymap = {
			accept = "<S-tab>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = filetypes,
	copilot_model = "gpt-41-copilot",
	-- https://github.com/zbirenbaum/copilot.lua/issues/484#issuecomment-3656544280
	server_opts_overrides = {
		-- Connection management to prevent GitHub handle leaks
		settings = {
			advanced = {
				timeout = 10000, -- 10 seconds instead of indefinite
			},
		},
		flags = {
			debounce_text_changes = 500, -- Reduce API calls
			allow_incremental_sync = false, -- Force clean syncs
		},
	},
}
