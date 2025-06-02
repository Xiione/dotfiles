return {
	provider = "copilot",
	copilot = {
		endpoint = "https://api.githubcopilot.com",
		model = "gpt-4.1",
		proxy = nil, -- [protocol://]host[:port] Use this proxy
		allow_insecure = false, -- Allow insecure server connections
		timeout = 30000, -- Timeout in milliseconds
		temperature = 0.75,
		max_tokens = 20480,
	},
	auto_suggestions_provider = nil,
	cursor_applying_provider = "copilot",
	memory_summary_provider = "copilot",
	web_search_engine = {
		provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
		proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
	},
	behaviour = {
		auto_focus_sidebar = true,
		auto_suggestions = false, -- Experimental stage
		auto_suggestions_respect_ignore = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = true,
		jump_result_buffer_on_finish = true,
		support_paste_from_clipboard = false,
		minimize_diff = true,
		enable_token_counting = true,
        enable_cursor_planning_mode = true,
		use_cwd_as_project_root = false,
		auto_focus_on_diff_view = false,
	},
	hints = {
		enabled = true,
	},
	mappings = {
        ask = "<D-i>",
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
            suggestion = "<leader>aS"
		},
	},
}
