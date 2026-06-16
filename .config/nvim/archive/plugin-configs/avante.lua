local utils = require("user.lib.utils")

return {
	"yetone/avante.nvim",
	lazy = true,
	autostart = false,
	version = false,
	build = "make",
	enabled = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		"HakonHarnes/img-clip.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
	},
	opts = {
		provider = "copilot",
		providers = {
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "claude-sonnet-4.6",
				proxy = nil,
				allow_insecure = false,
				timeout = 30000,
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
		},
		auto_suggestions_provider = nil,
		cursor_applying_provider = "copilot",
		memory_summary_provider = "copilot",
		web_search_engine = {
			provider = "google",
			proxy = nil,
		},
		behaviour = {
			auto_focus_sidebar = true,
			auto_suggestions = false,
			auto_suggestions_respect_ignore = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = true,
			jump_result_buffer_on_finish = true,
			support_paste_from_clipboard = true,
			minimize_diff = true,
			enable_token_counting = true,
			enable_cursor_planning_mode = true,
			use_cwd_as_project_root = true,
			auto_focus_on_diff_view = false,
		},
		hints = {
			enabled = true,
		},
		mappings = {
			ask = "<D-S-i>",
			focus = "<D-i>",
			edit = "<D-k>",
			stop = "<leader>as",
			diff = {
				ours = "<D-n>",
				theirs = "<D-y>",
				all_theirs = "<D-CR>",
			},
			cancel = {
				insert = { "<C-c>" },
			},
			submit = {
				insert = "<CR>",
			},
			sidebar = {
				apply_all = "<D-CR>",
				close_from_input = {
					insert = "<C-c>",
				},
			},
			toggle = {
				default = "<leader>aa",
				suggestion = "<leader>aS",
			},
		},
		windows = {
			input = {
				prefix = "▋ ",
			},
			edit = {
				border = utils.window_border,
			},
			ask = {
				border = utils.window_border,
			},
		},
		file_selector = {
			provider = "telescope",
		},
		selector = {
			provider = "telescope",
		},
		selection = {
			enabled = false,
			hint_display = "delayed",
		},
		prompt_logger = {
			enabled = true,
			fortune_cookie_on_success = false,
			next_prompt = {
				normal = "<Down>",
				insert = "<Down>",
			},
			prev_prompt = {
				normal = "<Up>",
				insert = "<Up>",
			},
		},
	},
}
