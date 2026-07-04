local sidebars = require("user.lib.sidebars")
local colors = require("user.cfg.colors")
local icons = require("user.cfg.icons")

local winbar_highlights = {}

local function set_background(name, source)
	local highlight = {}
	if source and vim.fn.hlexists(source) == 1 then
		highlight = vim.api.nvim_get_hl(0, { name = source, link = false })
	end
	highlight.bg = colors.nord18
	vim.api.nvim_set_hl(0, name, highlight)
end

local function get_winbar_highlight(source)
	if source == nil or source == "" then
		return source
	end
	if source == "DropBarIconUIPickPivot" then
		return source
	end

	local name = winbar_highlights[source]
	if name == nil then
		name = "DropBarWinBar" .. source:gsub("[^%w]", "")
		winbar_highlights[source] = name
	end

	set_background(name, source)
	return name
end

local function clear_background(name)
	local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
	highlight.bg = nil
	vim.api.nvim_set_hl(0, name, highlight)
end

local function apply_dropbar_highlights()
	for name in pairs(vim.api.nvim_get_hl(0, {})) do
		local is_shared_symbol = not name:match("NC$")
			and (name:match("^DropBarIconKind") or name:match("^DropBarKind") or name:match("^DropBarDevIcon"))
		if is_shared_symbol then
			clear_background(name)
		end
	end

	for source, name in pairs(winbar_highlights) do
		set_background(name, source)
	end
end

local function escape_statusline(text)
	return text:gsub("%%", "%%%%")
end

local function render_bar_symbol(symbol, plain)
	local marker = symbol.is_modified and " [+]" or ""
	if plain then
		return symbol.icon .. symbol.name .. marker
	end

	local bar_utils = require("dropbar.utils").bar
	local rendered = bar_utils.hl(escape_statusline(symbol.icon), get_winbar_highlight(symbol.icon_hl))
		.. bar_utils.hl(escape_statusline(symbol.name), get_winbar_highlight(symbol.name_hl))
	if marker ~= "" then
		rendered = rendered .. bar_utils.hl(marker, "DropBarModified")
	end

	if symbol.on_click and symbol.bar_idx then
		return bar_utils.make_clickable(
			rendered,
			("v:lua.dropbar.callbacks.buf%s.win%s.fn%s"):format(symbol.bar.buf, symbol.bar.win, symbol.callback_idx)
		)
	end

	return rendered
end

local function merge_symbol(symbol, opts)
	local merged = symbol:merge(opts)
	-- Dropbar's click handler reads sibling and child state from the original options.
	merged.opts = symbol.opts
	return merged
end

local function mark_modified(symbol)
	return merge_symbol(symbol, { is_modified = true })
end

local function decorate_symbol(symbol)
	return merge_symbol(symbol, { cat = render_bar_symbol })
end

local function decorate_source(source)
	return {
		get_symbols = function(...)
			return vim.tbl_map(decorate_symbol, source.get_symbols(...))
		end,
	}
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
		local devicons = require("nvim-web-devicons")
		local kind_symbols = {}
		for kind, icon in pairs(icons.lsp_kind) do
			kind_symbols[kind] = icon .. " "
		end
		for level, icon in ipairs(icons.markdown_heading) do
			kind_symbols["MarkdownH" .. level] = icon .. " "
		end

		local function resolve_file_icon(path)
			local icon, highlight = devicons.get_icon(vim.fs.basename(path), nil, { default = true })
			if icon == nil then
				return icons.lsp_kind.File .. " ", "DropBarIconKindFile"
			end

			return icon .. " ", highlight
		end

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

				return { vim.bo[bufnr].modified and mark_modified(symbol) or symbol }
			end,
		}

		return {
			bar = {
				enable = enable_bar,
				hover = false,
				sources = function(bufnr)
					if vim.bo[bufnr].buftype == "terminal" then
						return { decorate_source(sources.terminal) }
					end

					local context = vim.bo[bufnr].filetype == "markdown" and sources.markdown
						or source_utils.fallback({ sources.lsp, sources.treesitter })
					return { decorate_source(buffer_label), decorate_source(context) }
				end,
			},
			icons = {
				kinds = {
					file_icon = resolve_file_icon,
					symbols = kind_symbols,
				},
				ui = {
					bar = {
						extends = "",
						separator = " " .. icons.ui.collapsed .. " ",
					},
				},
			},
			menu = {
				hover = false,
				win_configs = {
					border = "none",
				},
			},
			sources = {
				path = {
					max_depth = 1,
					modified = function(symbol)
						return symbol and mark_modified(symbol) or nil
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
		apply_dropbar_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("UserDropbarHighlights", { clear = true }),
			callback = apply_dropbar_highlights,
		})
	end,
}
