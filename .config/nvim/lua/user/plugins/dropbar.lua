local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colors")

local file_icon_highlights = {}

local function set_background(name, source)
	local highlight = vim.api.nvim_get_hl(0, { name = source or name, link = false })
	highlight.bg = colors.nord18
	vim.api.nvim_set_hl(0, name, highlight)
end

local function file_icon_highlight(source)
	if source == nil or source:match("^DropBar") then
		return source
	end

	local name = file_icon_highlights[source]
	if name == nil then
		name = "DropBar" .. source:gsub("[^%w]", "")
		file_icon_highlights[source] = name
	end

	set_background(name, source)
	return name
end

local function apply_dropbar_background()
	for name in pairs(vim.api.nvim_get_hl(0, {})) do
		local is_bar_highlight = not name:match("NC$")
			and (
				name:match("^DropBarIconKind")
				or name:match("^DropBarKind")
				or name == "DropBarIconUIPickPivot"
				or name == "DropBarIconUISeparator"
			)
		if is_bar_highlight then
			set_background(name)
		end
	end

	for source, name in pairs(file_icon_highlights) do
		set_background(name, source)
	end
end

local function escape_statusline(text)
	return text:gsub("%%", "%%%%")
end

local function render_modified_symbol(symbol, plain)
	local marker = " [+]"
	if plain then
		return symbol.icon .. symbol.name .. marker
	end

	local bar_utils = require("dropbar.utils").bar
	local rendered = bar_utils.hl(escape_statusline(symbol.icon), symbol.icon_hl)
		.. bar_utils.hl(escape_statusline(symbol.name), symbol.name_hl)
		.. bar_utils.hl(marker, "DropBarModified")

	if symbol.on_click and symbol.bar_idx then
		return bar_utils.make_clickable(
			rendered,
			("v:lua.dropbar.callbacks.buf%s.win%s.fn%s"):format(symbol.bar.buf, symbol.bar.win, symbol.callback_idx)
		)
	end

	return rendered
end

local function add_modified_marker(symbol)
	return symbol:merge({ cat = render_modified_symbol })
end

local function enable_bar(bufnr, winid)
	bufnr = vim._resolve_bufnr(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then
		return false
	end

	if
		sidebars.sidebar_types_set[vim.bo[bufnr].filetype]
		or vim.fn.win_gettype(winid) ~= ""
		or vim.api.nvim_win_get_config(winid).relative ~= ""
		or vim.wo[winid].winbar ~= ""
	then
		return false
	end

	local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
	return stat == nil or stat.size <= 1024 * 1024
end

return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick winbar symbol",
		},
		{
			"[;",
			function()
				require("dropbar.api").goto_context_start()
			end,
			desc = "Go to context start",
		},
		{
			"];",
			function()
				require("dropbar.api").select_next_context()
			end,
			desc = "Select next context",
		},
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	opts = function()
		local bar = require("dropbar.bar")
		local configs = require("dropbar.configs")
		local sources = require("dropbar.sources")
		local source_utils = require("dropbar.utils").source
		local default_file_icon = configs.opts.icons.kinds.file_icon

		local buffer_label = {
			get_symbols = function(bufnr, winid, cursor)
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local is_virtual = bufname == "" or vim.bo[bufnr].buftype ~= "" or bufname:match("^%S+://")
				if not is_virtual then
					return sources.path.get_symbols(bufnr, winid, cursor)
				end

				local label
				local icon
				local icon_hl
				if bufname == "" then
					label = "[No Name]"
					icon = configs.opts.icons.kinds.symbols.File
					icon_hl = "DropBarIconKindFile"
				else
					local path = bufname:gsub("^%S+://", "", 1)
					label = vim.fs.basename(path)
					if label == "" then
						label = bufname
					end
					icon, icon_hl = configs.eval(configs.opts.icons.kinds.file_icon, bufname)
				end

				local symbol = bar.dropbar_symbol_t:new({
					buf = bufnr,
					win = winid,
					name = label,
					name_hl = "DropBarKindFile",
					icon = icon,
					icon_hl = icon_hl,
					on_click = false,
				})

				return { vim.bo[bufnr].modified and add_modified_marker(symbol) or symbol }
			end,
		}

		return {
			bar = {
				enable = enable_bar,
				hover = false,
				sources = function(bufnr)
					if vim.bo[bufnr].buftype == "terminal" then
						return { sources.terminal }
					end

					local context = vim.bo[bufnr].filetype == "markdown" and sources.markdown
						or source_utils.fallback({ sources.lsp, sources.treesitter })
					return { buffer_label, context }
				end,
			},
			icons = {
				kinds = {
					file_icon = function(path)
						local icon, highlight = configs.eval(default_file_icon, path)
						return icon, file_icon_highlight(highlight)
					end,
				},
				ui = {
					bar = {
						extends = "",
						separator = "  ",
					},
				},
			},
			menu = {
				hover = false,
			},
			sources = {
				path = {
					max_depth = 1,
					modified = function(symbol)
						return symbol and add_modified_marker(symbol) or nil
					end,
				},
				lsp = {
					max_depth = 4,
				},
				treesitter = {
					max_depth = 4,
				},
				markdown = {
					max_depth = 4,
				},
			},
		}
	end,
	config = function(_, opts)
		require("dropbar").setup(opts)
		apply_dropbar_background()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("UserDropbarHighlights", { clear = true }),
			callback = apply_dropbar_background,
		})
	end,
}
