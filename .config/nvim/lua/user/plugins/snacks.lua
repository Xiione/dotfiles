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

local function toggle_scratch()
	scratch.enable_nested_branches()
	scratch.notify_changed()
	Snacks.scratch()
	vim.schedule(scratch.notify_changed)
end

local function select_scratch()
	scratch.enable_nested_branches()
	Snacks.picker.scratch({
		on_close = scratch.notify_changed,
	})
end

local hide_lazygit_command =
	[[nvim --server "$NVIM" --remote-expr 'luaeval("(function() local buffer = vim.api.nvim_get_current_buf(); for _, terminal in ipairs(Snacks.terminal.list()) do if terminal.buf == buffer then terminal:hide(); break end end return 0 end)()")' >/dev/null]]

local function build_lazygit_edit_command(path_template, line_template)
	local command = hide_lazygit_command .. [[; nvim --server "$NVIM" --remote ]] .. path_template
	if line_template then
		command = command .. [[; nvim --server "$NVIM" --remote-send ":]] .. line_template .. [[<CR>"]]
	end
	return command
end

local lazygit_filename_aliases = {
	[".srcinfo"] = ".SRCINFO",
	[".xauthority"] = ".Xauthority",
	[".xresources"] = ".Xresources",
	["authors"] = "AUTHORS",
	["authors.txt"] = "AUTHORS.txt",
	["brewfile"] = "Brewfile",
	["cmakelists.txt"] = "CMakeLists.txt",
	["containerfile"] = "Containerfile",
	["directory.build.props"] = "Directory.Build.props",
	["directory.build.targets"] = "Directory.Build.targets",
	["directory.packages.props"] = "Directory.Packages.props",
	["dockerfile"] = "Dockerfile",
	["freecad.conf"] = "FreeCAD.conf",
	["gemfile"] = "Gemfile",
	["gnumakefile"] = "GNUmakefile",
	["jenkinsfile"] = "Jenkinsfile",
	["justfile"] = "Justfile",
	["makefile"] = "Makefile",
	["pkgbuild"] = "PKGBUILD",
	["procfile"] = "Procfile",
	["prusaslicer.ini"] = "PrusaSlicer.ini",
	["prusaslicergcodeviewer.ini"] = "PrusaSlicerGcodeViewer.ini",
	["qtproject.conf"] = "QtProject.conf",
	["rakefile"] = "Rakefile",
	["vagrantfile"] = "Vagrantfile",
}

local function build_lazygit_icons()
	local devicons = require("nvim-web-devicons")
	local filenames = {}
	local extensions = {}

	for filename in pairs(devicons.get_icons_by_filename()) do
		local icon, color = devicons.get_icon_colors(filename, nil, { strict = true })
		local config = { icon = icon, color = color }
		filenames[filename] = config

		local alias = lazygit_filename_aliases[filename]
		if alias then
			filenames[alias] = config
		end
	end

	for extension in pairs(devicons.get_icons_by_extension()) do
		local icon, color = devicons.get_icon_colors(nil, extension, { strict = true })
		extensions["." .. extension] = { icon = icon, color = color }
	end

	return {
		filenames = filenames,
		extensions = extensions,
	}
end

local function open_lazygit()
	Snacks.lazygit({
		config = {
			gui = { customIcons = build_lazygit_icons() },
		},
	})
end

local function match_picker_preview_signcolumn(opts)
	local on_show = opts.on_show
	opts.on_show = function(picker)
		if on_show then
			on_show(picker)
		end

		local preview = picker.preview
		if preview.main or not preview.win:valid() then
			return
		end

		local win = preview.win.win
		local winhighlight = Snacks.util.winhl(preview.winhl, {
			SignColumn = "SnacksPickerPreview",
		})
		preview.winhl = winhighlight
		preview.win.opts.wo.winhighlight = winhighlight
		Snacks.util.wo(win, { winhighlight = winhighlight })
	end
end

local function should_show_indent(buf, win)
	if vim.g.snacks_indent == false or vim.b[buf].snacks_indent == false then
		return false
	end

	local buftype = vim.bo[buf].buftype
	if buftype == "" then
		return true
	end

	return buftype == "nowrite" and vim.wo[win].diff and vim.startswith(vim.api.nvim_buf_get_name(buf), "diffview://")
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
			"<leader>fh",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>gg",
			open_lazygit,
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
		bigfile = {
			enabled = true,
		},
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
						action = open_lazygit,
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
			float = {
				backdrop = false,
			},
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
			filter = should_show_indent,
			animate = {
				enabled = false,
			},
			indent = {
				char = "▏",
			},
			scope = {
				char = "▏",
			},
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
				os = {
					editPreset = "nvim-remote",
					edit = build_lazygit_edit_command("{{filename}}"),
					editAtLine = build_lazygit_edit_command("{{filename}}", "{{line}}"),
					openDirInEditor = build_lazygit_edit_command("{{dir}}"),
				},
				gui = { nerdFontsVersion = "3" },
			},
			win = {
				border = "solid",
				keys = {
					["<C-q>"] = { "hide", mode = { "n", "t" } },
				},
			},
		},
		picker = {
			enabled = true,
			config = match_picker_preview_signcolumn,
			win = {
				input = {
					keys = {
						["<Esc>"] = { "close", mode = { "n", "i" } },
					},
				},
			},
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
		quickfile = {
			enabled = true,
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
		words = {
			enabled = false,
			modes = { "n" },
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		Snacks.keymap.set("n", "q", "<Cmd>close<CR>", {
			ft = { "help", "lspinfo", "man", "qf" },
			desc = "Close window",
		})
	end,
}
