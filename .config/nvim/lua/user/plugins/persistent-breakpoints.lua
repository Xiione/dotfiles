return {
	"Weissle/persistent-breakpoints.nvim",
	event = "BufReadPost",
	opts = {
		save_dir = vim.fn.expand("~/.vim/breakpoints/"),
		load_breakpoints_event = "BufReadPost",
	},
}
