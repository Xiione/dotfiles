local keys = {
	{
		"<leader>M",
		function()
			require("grapple").toggle()
		end,
		desc = "Toggle Grapple tag",
	},
	{
		"<leader>m",
		function()
			require("grapple").toggle_tags()
		end,
		desc = "Open Grapple tags",
	},
}

for number = 1, 9 do
	local index = number
	table.insert(keys, {
		string.format("<leader>%d", index),
		function()
			require("grapple").select({ index = index })
		end,
		desc = string.format("Select Grapple tag %d", index),
	})
end

return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "BufReadPost", "BufNewFile" },
	keys = keys,
	opts = {
		scope = "git_branch",
		icons = true,
		win_opts = {
			border = "solid",
		},
		statusline = {
			icon = "",
			active = "%s",
			inactive = " %s ",
		},
	},
}
