return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	opts = {
		size = 13,
		open_mapping = [[<C-]>]],
		hide_numbers = true,
		start_in_insert = true,
		persist_size = false,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		auto_scroll = false,
		float_opts = {
			border = "solid",
			winblend = 5,
		},
		highlights = {
			Normal = {
				link = "NormalFloat",
				sp = "None",
			},
			NormalFloat = {
				link = "NormalFloat",
				sp = "None",
			},
			FloatBorder = {
				link = "FloatBorder",
				sp = "None",
			},
		},
	},
}
