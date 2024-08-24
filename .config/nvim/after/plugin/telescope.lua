local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		-- selection_caret = " ",
		selection_caret = "  ",
		path_display = { "smart" },
		file_ignore_patterns = { "^%.git/", "^%.git$", ".DS_Store", "node_modules" },
		dynamic_preview_title = true,
		results_title = false,

		-- winblend = 8,
		border = true,
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		color_devicons = true,

		mappings = {
			i = {
				["<Esc>"] = actions.close,
				["<Down>"] = actions.cycle_history_next,
				["<Up>"] = actions.cycle_history_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = { "--hidden" },
		},
		buffers = {
			sort_lastused = true,
		},
		oldfiles = {
			cwd_only = true,
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
			}),
		},
	},
})

require("telescope").load_extension("ui-select")
