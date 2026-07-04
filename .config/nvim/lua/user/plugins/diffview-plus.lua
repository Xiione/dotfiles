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

	vim.wo[winid].cursorlineopt = "both"
	set_window_fillchar(winid, "diff", "╲")
end

local function disable_indent_guides(bufnr)
	local ok, ibl = pcall(require, "ibl")
	if ok then
		ibl.setup_buffer(bufnr, { enabled = false })
	end
end

local function use_full_filename_icons()
	local highlights = require("diffview.hl")
	if rawget(highlights, "_user_full_filename_icons") then
		return
	end

	local get_file_icon = highlights.get_file_icon
	highlights.get_file_icon = function(name, _, ...)
		return get_file_icon(name, nil, ...)
	end
	rawset(highlights, "_user_full_filename_icons", true)
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
		use_icons = true,
		file_panel = {
			win_config = {
				width = 45,
			},
		},
		hooks = {
			diff_buf_read = function(bufnr)
				apply_diffview_highlights()
				disable_indent_guides(bufnr)
			end,
			diff_buf_win_enter = function(bufnr, winid)
				apply_diffview_highlights()
				disable_indent_guides(bufnr)
				apply_diffview_window_highlights(winid)
			end,
		},
	},
	config = function(_, opts)
		require("diffview").setup(opts)
		use_full_filename_icons()
		apply_diffview_highlights()
	end,
}
