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
}
