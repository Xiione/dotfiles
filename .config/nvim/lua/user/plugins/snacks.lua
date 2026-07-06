local sidebars = require("user.lib.sidebars")
local utils = require("user.lib.utils")
local icons = require("user.cfg.icons")
local logos = require("user.lib.logos")
local neogurt = require("user.lib.neogurt")
local scratch = require("user.lib.scratch")

local ignored_names = {
	".git",
	".DS_Store",
	"node_modules",
	".next",
	"dist",
	"build",
}

local function load_remote_api()
	local connections_ok, connections = pcall(require, "remote-sshfs.connections")
	if not connections_ok then
		return nil
	end

	local status_ok, is_connected = pcall(connections.is_connected)
	if not status_ok or not is_connected then
		return nil
	end

	local api_ok, api = pcall(require, "remote-sshfs.api")
	return api_ok and api or nil
end

local function find_files()
	local remote = load_remote_api()
	if remote then
		remote.find_files()
	else
		Snacks.picker.files()
	end
end

local function live_grep()
	local remote = load_remote_api()
	if remote then
		remote.live_grep()
	else
		Snacks.picker.grep()
	end
end

local function pick_recent_files()
	Snacks.picker.recent()
end

local function build_recent_section()
	local cwd = assert(vim.uv.cwd())
	return {
		{
			icon = icons.lsp_kind.Folder .. " ",
			title = vim.fn.fnamemodify(cwd, ":~"),
			label = neogurt.session_name(cwd),
			padding = 1,
		},
		{
			section = "recent_files",
			cwd = true,
			limit = 5,
			indent = 2,
		},
	}
end

local function notify_scratch_changed()
	vim.api.nvim_exec_autocmds("User", {
		pattern = "SnacksScratchChanged",
		modeline = false,
	})
end

local function toggle_scratch()
	scratch.enable_nested_branches()
	notify_scratch_changed()
	Snacks.scratch()
	vim.schedule(notify_scratch_changed)
end

local function select_scratch()
	scratch.enable_nested_branches()
	Snacks.picker.scratch({
		on_close = notify_scratch_changed,
	})
end

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{
			"<leader>ff",
			find_files,
			desc = "Find files",
		},
		{
			"<leader>ft",
			live_grep,
			desc = "Live grep",
		},
		{
			"<leader>fT",
			function()
				Snacks.picker.lines()
			end,
			desc = "Fuzzy find in buffer",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker()
			end,
			desc = "Open Snacks pickers",
		},
		{
			"<leader>fr",
			pick_recent_files,
			desc = "Find recent files",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Toggle Lazygit",
		},
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub issues (all)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub pull requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub pull requests (all)",
		},
		{
			"<leader>go",
			function()
				Snacks.gitbrowse({ what = "permalink" })
			end,
			desc = "Open Git permalink",
			mode = { "n", "v" },
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Show Git line history",
		},
		{
			"<leader>x",
			toggle_scratch,
			desc = "Toggle scratch buffer",
		},
		{
			"<leader>X",
			select_scratch,
			desc = "Select scratch buffer",
		},
		{
			"<leader>o",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Find document symbols",
		},
		{
			"<leader>O",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Find workspace symbols",
		},
	},
	opts = {
		dashboard = {
			preset = {
				header = table.concat(logos.random, "\n"),
				keys = {
					{ icon = " ", key = "p", desc = "Restore session", section = "session" },
					{
						icon = "󰙅 ",
						key = "<leader>e",
						desc = "Browse files",
						action = function()
							require("user.lib.sidebars").toggle("nvimtree")
						end,
					},
					{ icon = "󰮗 ", key = "<leader>ff", desc = "Find file", action = find_files },
					{ icon = " ", key = "<leader>fr", desc = "Recent files", action = pick_recent_files },
					{
						icon = "󰊢 ",
						key = "<leader>gg",
						desc = "Open Lazygit",
						action = function()
							Snacks.lazygit()
						end,
					},
					{ icon = icons.git.untracked .. " ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", padding = 1 },
				build_recent_section,
				{ section = "startup" },
			},
		},
		styles = {
			input = {
				border = utils.window_border,
				relative = "cursor",
				wo = {
					winhighlight = sidebars.float_winhl,
					cursorline = false,
				},
			},
		},
		input = {
			enabled = true,
		},
		indent = {
			enabled = true,
		},
		gh = {
			icons = {
				file = icons.lsp_kind.File .. " ",
				checkmark = icons.status.success .. " ",
				crossmark = icons.diagnostic.error .. " ",
				checks = {
					pending = icons.diagnostic.warn .. " ",
					success = icons.status.success .. " ",
					failure = icons.diagnostic.error .. " ",
					skipped = icons.git.ignored .. " ",
				},
				review = {
					approved = icons.status.success .. " ",
					changes_requested = icons.diagnostic.error .. " ",
					dismissed = icons.diagnostic.warn .. " ",
					pending = icons.diagnostic.warn .. " ",
				},
				merge_status = {
					clean = icons.status.success .. " ",
					dirty = icons.diagnostic.error .. " ",
					blocked = icons.diagnostic.error .. " ",
					unstable = icons.diagnostic.warn .. " ",
				},
			},
		},
		gitbrowse = {
			config = function(opts)
				table.insert(opts.remote_patterns, 1, {
					"^git@github%.com%-personal:(.+)$",
					"https://github.com/%1",
				})
			end,
		},
		lazygit = {
			configure = true,
			config = {
				os = { editPreset = "nvim-remote" },
				gui = { nerdFontsVersion = "3" },
			},
			win = {
				keys = {
					["<C-q>"] = { "hide", mode = { "n", "t" } },
				},
			},
		},
		picker = {
			enabled = true,
			icons = {
				git = {
					staged = icons.git.staged,
					added = icons.git.added,
					deleted = icons.git.deleted,
					ignored = icons.git.ignored,
					modified = icons.git.unstaged,
					renamed = icons.git.renamed,
					copied = icons.git.copied,
					unmerged = icons.git.unmerged,
					untracked = icons.git.untracked,
				},
			},
			sources = {
				files = {
					hidden = true,
					exclude = ignored_names,
				},
				grep = {
					hidden = true,
					exclude = ignored_names,
				},
				recent = {
					filter = { cwd = true },
				},
			},
		},
		scratch = {
			ft = "markdown",
			root = scratch.root,
			autowrite = true,
			filekey = {
				cwd = true,
				branch = true,
				count = true,
			},
		},
	},
}
