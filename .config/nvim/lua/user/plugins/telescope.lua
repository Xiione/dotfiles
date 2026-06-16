return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nosduco/remote-sshfs.nvim",
		"Juksuu/worktrees.nvim",
	},
	opts = function()
		local utils = require("user.lib.utils")
		local actions = require("telescope.actions")

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = "  ",
				path_display = { "smart" },
				file_ignore_patterns = { "^%.git/", "^%.git$", ".DS_Store", "node_modules" },
				dynamic_preview_title = true,
				results_title = false,
				border = true,
				borderchars = utils.borderchars,
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
						borderchars = utils.borderchars,
					}),
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("ui-select")
		telescope.load_extension("remote-sshfs")
		telescope.load_extension("worktrees")
	end,
}
