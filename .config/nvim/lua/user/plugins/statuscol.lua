return {
	"luukvbaal/statuscol.nvim",
	opts = function()
		local builtin = require("statuscol.builtin")

		return {
			foldfunc = "builtin",
			setopt = true,
			ft_ignore = require("user.lib.sidebars").sidebar_types,
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{
					text = { builtin.lnumfunc, " " },
					condition = { true, builtin.not_empty },
				},
			},
			clickhandlers = {
				FoldClose = builtin.foldclose_click,
				FoldOpen = builtin.foldopen_click,
				FoldOther = builtin.foldother_click,
				["diagnostic/signs"] = builtin.diagnostic_click,
				gitsigns = builtin.gitsigns_click,
			},
		}
	end,
}
