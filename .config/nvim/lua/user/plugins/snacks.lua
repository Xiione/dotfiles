local sidebars = require("user.lib.sidebars")
local utils = require("user.lib.utils")

local ignored_names = {
	".git",
	".DS_Store",
	"node_modules",
	".next",
	"dist",
	"build",
}

local function remote_api()
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

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{
			"<leader>ff",
			function()
				local remote = remote_api()
				if remote then
					remote.find_files()
				else
					Snacks.picker.files()
				end
			end,
			desc = "Find files",
		},
		{
			"<leader>ft",
			function()
				local remote = remote_api()
				if remote then
					remote.live_grep()
				else
					Snacks.picker.grep()
				end
			end,
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
			function()
				Snacks.picker.recent()
			end,
			desc = "Find recent files",
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
