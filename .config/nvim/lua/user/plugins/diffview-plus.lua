local icons = require("user.cfg.icons")

local function apply_diffview_highlights()
	local colors = require("user.cfg.colors")

	vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { fg = "NONE", bg = colors.diff.delete_bg })
	vim.api.nvim_set_hl(0, "DiffviewDiffAddInline", { fg = "NONE", bg = colors.diff.add_inline_bg })
	vim.api.nvim_set_hl(0, "DiffviewDiffTextInline", { fg = "NONE", bg = colors.diff.change_inline_bg })
	vim.api.nvim_set_hl(
		0,
		"DiffviewDiffDeleteDim",
		{ fg = colors.diff.filler_fg, ctermfg = 8, bg = colors.diff.delete_bg }
	)
	vim.api.nvim_set_hl(0, "DiffviewDim1", { link = "Comment" })
	vim.api.nvim_set_hl(0, "DiffviewDiffCursorLine", {
		bg = colors.diff.cursorline_bg,
		sp = colors.diff.cursorline_sp,
		underline = true,
	})
	vim.api.nvim_set_hl(0, "DiffviewDiffCursorColumn", {
		bg = colors.diff.cursorline_bg,
		sp = "NONE",
	})
end

local function open_file_history_options()
	-- Wrapping the action keeps the mapping without rendering Diffview's persistent hint row.
	require("diffview.config").actions.options()
end

local function set_window_highlight(winid, value)
	local source = value:match("^[^:]+")
	local winhighlight = vim.wo[winid].winhighlight
	local highlights = {}

	for item in winhighlight:gmatch("[^,]+") do
		if item:match("^[^:]+") ~= source then
			table.insert(highlights, item)
		end
	end

	table.insert(highlights, value)
	vim.wo[winid].winhighlight = table.concat(highlights, ",")
end

local function set_window_fillchar(winid, name, value)
	local fillchars = {}

	for item in vim.wo[winid].fillchars:gmatch("[^,]+") do
		if item:match("^[^:]+") ~= name then
			table.insert(fillchars, item)
		end
	end

	table.insert(fillchars, name .. ":" .. value)
	vim.wo[winid].fillchars = table.concat(fillchars, ",")
end

local function apply_diffview_window_highlights(winid)
	local highlights = {
		"CursorLine:DiffviewDiffCursorLine",
		"CursorLineSign:DiffviewDiffCursorColumn",
		"CursorLineNr:DiffviewDiffCursorColumn",
		"CursorLineFold:DiffviewDiffCursorColumn",
		"FoldColumn:Normal",
		"Folded:Comment",
	}

	for _, highlight in ipairs(highlights) do
		set_window_highlight(winid, highlight)
	end

	-- Reserve the indentation columns for Snacks guides instead of covering the fold summary.
	vim.wo[winid].foldtext = "repeat(' ', indent(v:foldstart)) .. foldtext()"
	vim.wo[winid].cursorlineopt = "both"
	set_window_fillchar(winid, "diff", "╲")
end

local function use_basename_file_icons()
	local highlights = require("diffview.hl")
	if not rawget(highlights, "_user_full_filename_icons") then
		local get_file_icon = highlights.get_file_icon
		highlights.get_file_icon = function(name, _, ...)
			return get_file_icon(name, nil, ...)
		end
		rawset(highlights, "_user_full_filename_icons", true)
	end

	-- File-history rows hardcode the icon before the parent path.
	local component = require("diffview.renderer").RenderComponent
	if rawget(component, "_user_basename_file_icons") then
		return
	end

	local add_text = component.add_text
	component.add_text = function(self, text, highlight, ...)
		local pending_icon = rawget(self, "_user_pending_file_icon")

		if text ~= "" and highlight and highlight:match("^DevIcon") then
			rawset(self, "_user_pending_file_icon", { text, highlight })
			return
		end

		if pending_icon and highlight ~= "DiffviewFilePanelPath" then
			add_text(self, pending_icon[1], pending_icon[2])
			rawset(self, "_user_pending_file_icon", nil)
		end

		return add_text(self, text, highlight, ...)
	end
	rawset(component, "_user_basename_file_icons", true)
end

local function use_stat_glyphs()
	-- Diffview does not expose its stat prefixes or separators as configuration.
	local renderer = require("diffview.renderer")
	local component = renderer.RenderComponent
	if rawget(component, "_user_stat_glyphs") then
		return
	end

	local add_text = component.add_text
	component.add_text = function(self, text, highlight, ...)
		if highlight == "DiffviewNonText" then
			if text == " | " then
				text = " │ "
			elseif text == " |" then
				text = " │"
			end
		elseif text:match("^%d+$") then
			if highlight == "DiffviewFilePanelInsertions" then
				text = "+" .. text
			elseif highlight == "DiffviewFilePanelDeletions" then
				text = "-" .. text
			end
		end

		return add_text(self, text, highlight, ...)
	end
	rawset(component, "_user_stat_glyphs", true)
end

return {
	"dlyongemallo/diffview-plus.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>rr",
			function()
				require("user.lib.sidebars").toggle("diffview")
			end,
			desc = "Toggle Diffview",
		},
		{
			"<leader>rh",
			function()
				require("user.lib.sidebars").toggle("diffview_history")
			end,
			desc = "Toggle Diffview history",
		},
	},
	cmd = {
		"DiffviewOpen",
		"DiffviewToggle",
		"DiffviewFileHistory",
		"DiffviewDiffFiles",
		"DiffviewClose",
	},
	opts = {
		enhanced_diff_hl = true,
		show_help_hints = false,
		use_icons = true,
		status_icons = {
			["A"] = icons.git.added,
			["?"] = icons.git.untracked,
			["M"] = icons.git.unstaged,
			["R"] = icons.git.renamed,
			["C"] = icons.git.copied,
			["T"] = icons.git.type_changed,
			["U"] = icons.git.unmerged,
			["X"] = icons.diagnostic.error,
			["D"] = icons.git.deleted,
			["B"] = icons.diagnostic.error,
			["!"] = icons.git.ignored,
		},
		signs = {
			fold_closed = icons.ui.collapsed,
			fold_open = icons.ui.expanded,
			done = icons.status.success,
		},
		file_panel = {
			win_config = {
				width = 45,
			},
		},
		file_history_panel = {
			stat_style = "bar",
			subject_highlight = "merge_aware",
		},
		keymaps = {
			file_history_panel = {
				{ "n", "g!", open_file_history_options, { desc = "Open option panel" } },
			},
		},
		hooks = {
			diff_buf_read = function(bufnr)
				apply_diffview_highlights()
			end,
			diff_buf_win_enter = function(bufnr, winid)
				apply_diffview_highlights()
				apply_diffview_window_highlights(winid)
			end,
		},
	},
	config = function(_, opts)
		require("diffview").setup(opts)
		-- use_basename_file_icons()
		use_stat_glyphs()
		apply_diffview_highlights()
	end,
}
