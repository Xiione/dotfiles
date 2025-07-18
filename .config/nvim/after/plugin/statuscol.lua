local status_ok, statuscol = pcall(require, "statuscol")
if not status_ok then
	return
end
local builtin = require("statuscol.builtin")

statuscol.setup({
	foldfunc = "builtin",
	setopt = true,
	ft_ignore = require("user.lib.sidebars").sidebar_types,
	segments = {
		{ text = { "%s" }, click = "v:lua.ScSa" },
		-- { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
		{
			text = { builtin.lnumfunc, " " },
			condition = { true, builtin.not_empty },
		},
	},
	clickhandlers = { -- builtin click handlers
		FoldClose = builtin.foldclose_click,
		FoldOpen = builtin.foldopen_click,
		FoldOther = builtin.foldother_click,
		["diagnostic/signs"] = builtin.diagnostic_click,
		gitsigns = builtin.gitsigns_click,
	},
})
