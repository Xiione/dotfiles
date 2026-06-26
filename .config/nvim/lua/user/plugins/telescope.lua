return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nosduco/remote-sshfs.nvim",
		"Juksuu/worktrees.nvim",
	},
	opts = function()
		local utils = require("user.lib.utils")
		local actions = require("telescope.actions")

		local ignored_names = {
			".git",
			".DS_Store",
			"node_modules",
			".next",
			"dist",
			"build",
		}

		local file_ignore_patterns = {}
		for _, name in ipairs(ignored_names) do
			table.insert(file_ignore_patterns, name)
		end

		local function rg_args()
			local args = { "-j1" }

			for _, name in ipairs(ignored_names) do
				table.insert(args, "--glob=!**/" .. name)
				table.insert(args, "--glob=!**/" .. name .. "/**")
			end

			return args
		end

		local function fd_find_command()
			local command = {
				"fd",
				"--type",
				"f",
				"--hidden",
			}

			for _, name in ipairs(ignored_names) do
				table.insert(command, "--exclude")
				table.insert(command, name)
			end

			return command
		end

		local vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		}
		vim.list_extend(vimgrep_arguments, rg_args())

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = "  ",
				path_display = { "smart" },
				file_ignore_patterns = file_ignore_patterns,
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
				vimgrep_arguments = vimgrep_arguments,
			},
			pickers = {
				find_files = {
					find_command = fd_find_command,
					previewer = false,
					layout_strategy = "center",
					layout_config = {
						width = 0.5,
						prompt_position = "bottom"
					},
				},
				live_grep = {
					additional_args = function()
						return rg_args()
					end,
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
				fzf = {},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("ui-select")
		telescope.load_extension("fzf")
		telescope.load_extension("remote-sshfs")
		telescope.load_extension("worktrees")
	end,
}
