return {
	"mbbill/undotree",
	keys = {
		{
			"<leader>u",
			function()
				require("user.lib.sidebars").toggle("undotree")
			end,
			desc = "Toggle undo tree",
		},
	},
	cmd = {
		"UndotreeToggle",
		"UndotreeShow",
		"UndotreeHide",
		"UndotreeFocus",
		"UndotreePersistUndo",
	},
}
