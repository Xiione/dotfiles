local utils = require("user.lib.utils")

return {
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
	},
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	preview_config = {
		-- Options passed to nvim_open_win
		border = utils.window_border,
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
}
