local status_ok, fidget = pcall(require, "fidget")
if not status_ok then
	return
end

fidget.setup({
	progress = {
		display = {
			done_icon = "󰄬",
		},
	},
	notification = {
		window = {
			normal_hl = "Normal",
			winblend = 0,
		},
	},
	integration = {
		["nvim-tree"] = {
			enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
		},
	},
})
