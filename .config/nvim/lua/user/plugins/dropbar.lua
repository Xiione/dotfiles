local sidebars = require("user.lib.sidebars")

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
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	opts = function()
		local bar = require("dropbar.bar")
		local configs = require("dropbar.configs")
		local sources = require("dropbar.sources")
		local source_utils = require("dropbar.utils").source

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

				if vim.bo[bufnr].modified then
					label = label .. " [+]"
				end

				return {
					bar.dropbar_symbol_t:new({
						buf = bufnr,
						win = winid,
						name = label,
						name_hl = "DropBarKindFile",
						icon = icon,
						icon_hl = icon_hl,
						on_click = false,
					}),
				}
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
						if symbol == nil then
							return nil
						end
						return symbol:merge({ name = symbol.name .. " [+]" })
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
}
