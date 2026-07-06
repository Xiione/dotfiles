local sidebars = require("user.lib.sidebars")
local utils = require("user.lib.utils")
local icons = require("user.cfg.icons")
local logos = require("user.lib.logos")
local neogurt = require("user.lib.neogurt")

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
	},
}
