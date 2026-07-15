local function apply_disabled_statusline_highlight()
	vim.api.nvim_set_hl(0, "lualine_transparent", { link = "lualine_c_normal" })
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- dependencies = { "AndreM222/copilot-lualine" },
	opts = function()
		local sidebars = require("user.lib.sidebars")
		local statusline_disabled_filetypes = vim.tbl_filter(function(filetype)
			return filetype ~= "qf"
		end, sidebars.sidebar_types)
		local colors = require("user.cfg.colors")
		local icons = require("user.cfg.icons")
		local scratch = require("user.lib.scratch")
		local nord = require("lualine.themes.nord")
		local uv = vim.uv
		local scratch_icon = ""
		local scratch_cache = {
			count = 0,
			expires_at = 0,
		}
		local focus_marker = ""
		local focus_padding = {}
		local focus_balance_pending = {}

		local function load_scratch_count()
			local now = uv.hrtime()
			if now < scratch_cache.expires_at then
				return scratch_cache.count
			end

			local context = scratch.context()
			local ok, scratches = pcall(Snacks.scratch.list)
			local count = 0
			if ok then
				for _, saved_scratch in ipairs(scratches) do
					if saved_scratch.cwd == context.cwd and saved_scratch.branch == context.branch then
						count = count + 1
					end
				end
			end

			scratch_cache.count = count
			scratch_cache.expires_at = now + 1e9
			return count
		end

		local function render_scratch_count()
			local count = load_scratch_count()
			return count > 0 and (scratch_icon .. " " .. count) or ""
		end

		local function invalidate_scratch_count()
			scratch_cache.expires_at = 0
			vim.schedule(function()
				pcall(vim.cmd.redrawstatus)
			end)
		end

		local scratch_count_group = vim.api.nvim_create_augroup("UserScratchCount", { clear = true })
		vim.api.nvim_create_autocmd("DirChanged", {
			group = scratch_count_group,
			callback = invalidate_scratch_count,
		})
		vim.api.nvim_create_autocmd("User", {
			group = scratch_count_group,
			pattern = { "GitSignsUpdate", "SnacksScratchChanged" },
			callback = invalidate_scratch_count,
		})
		vim.api.nvim_create_autocmd({ "BufHidden", "BufWritePost" }, {
			group = scratch_count_group,
			callback = function(ctx)
				local name = vim.api.nvim_buf_get_name(ctx.buf)
				if name ~= "" and vim.fs.dirname(vim.fs.normalize(name)) == scratch.root then
					invalidate_scratch_count()
				end
			end,
		})

		local mode_colors = {
			normal = colors.nord4,
			insert = colors.nord9,
			visual = colors.nord7,
			replace = colors.nord13,
			command = colors.nord12,
			terminal = colors.nord15,
			select = colors.nord10,
		}
		local mode_color_groups = {
			c = "command",
			i = "insert",
			r = "replace",
			R = "replace",
			rm = "command",
			["r?"] = "command",
			s = "visual",
			S = "visual",
			t = "terminal",
			v = "visual",
			V = "visual",
			["\19"] = "visual",
			["\22"] = "visual",
		}

		local function focus_marker_color()
			local mode = vim.api.nvim_get_mode().mode
			local group = mode_color_groups[mode] or mode_color_groups[mode:sub(1, 1)] or "normal"
			return { fg = mode_colors[group] }
		end

		local function statusline_window()
			local win = tonumber(vim.g.statusline_winid)
			return win and vim.api.nvim_win_is_valid(win) and win or vim.api.nvim_get_current_win()
		end

		local function render_focus_padding(side)
			local padding = focus_padding[statusline_window()]
			return padding and string.rep(" ", padding[side]) or ""
		end

		local function render_left_focus_padding()
			return render_focus_padding("left")
		end

		local function render_right_focus_padding()
			return render_focus_padding("right")
		end

		local function balance_focus_marker(win)
			if not vim.api.nvim_win_is_valid(win) then
				focus_padding[win] = nil
				focus_balance_pending[win] = nil
				return
			end

			local ok, statusline = pcall(vim.api.nvim_eval_statusline, vim.wo[win].statusline, {
				winid = win,
				maxwidth = vim.api.nvim_win_get_width(win),
			})
			if not ok then
				focus_balance_pending[win] = nil
				return
			end
			local marker_start = statusline.str:find(focus_marker, 1, true)
			if not marker_start then
				focus_balance_pending[win] = nil
				return
			end

			local padding = focus_padding[win] or { left = 0, right = 0 }
			local prefix_width = vim.fn.strdisplaywidth(statusline.str:sub(1, marker_start - 1))
			local marker_width = vim.fn.strdisplaywidth(focus_marker)
			local difference = 2 * prefix_width + marker_width - statusline.width
			if math.abs(difference) <= 1 then
				focus_balance_pending[win] = nil
				return
			end
			local base_difference = difference - padding.left + padding.right
			local balanced = {
				left = math.max(-base_difference, 0),
				right = math.max(base_difference, 0),
			}
			focus_balance_pending[win] = nil

			if padding.left == balanced.left and padding.right == balanced.right then
				return
			end

			focus_padding[win] = balanced
			vim.api.nvim_win_call(win, function()
				require("lualine").refresh({
					force = true,
					scope = "window",
					place = { "statusline" },
				})
			end)
		end

		local function render_focus_marker()
			local win = statusline_window()
			if not focus_balance_pending[win] then
				focus_balance_pending[win] = true
				vim.defer_fn(function()
					balance_focus_marker(win)
				end, 10)
			end
			return focus_marker
		end

		for mode, color in pairs(mode_colors) do
			nord[mode] = {
				a = { fg = colors.nord0, bg = color, gui = "bold" },
				b = { fg = color, bg = colors.nord1 },
				c = { fg = colors.nord4, bg = colors.nord0 },
			}
		end

		nord.inactive = {
			a = { fg = colors.nord2, bg = colors.nord2, gui = "bold" },
			b = { fg = colors.nord1, bg = colors.nord1 },
			c = { fg = colors.nord4, bg = colors.nord0 },
			y = { fg = colors.nord3, bg = colors.nord1 },
			z = { fg = colors.nord0, bg = colors.nord2, gui = "bold" },
		}

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = icons.diagnostic.error .. " ", warn = icons.diagnostic.warn .. " " },
			colored = false,
			always_visible = true,
		}

		return {
			options = {
				globalstatus = false,
				icons_enabled = true,
				theme = nord,
				component_separators = "",
				section_separators = "",
				disabled_filetypes = {
					statusline = statusline_disabled_filetypes,
				},
			},
			sections = {
				lualine_a = { { "mode", padding = 1 } },
				lualine_b = { diagnostics },
				lualine_c = {
					render_scratch_count,
					{ "grapple", inactive = " %s", padding = { left = 1, right = 0 } },
					{ render_left_focus_padding, padding = 0 },
					"%=",
					{ render_focus_marker, color = focus_marker_color, padding = 0 },
				},
				lualine_x = {
					{ render_right_focus_padding, padding = 0 },
					{ "filetype", padding = { left = 0, right = 1 } },
				},
				lualine_y = { { "progress", padding = 1 } },
				lualine_z = { { "location", padding = 1 } },
			},
			inactive_sections = {
				lualine_a = { { "mode", padding = 1 } },
				lualine_b = { diagnostics },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { { "progress", padding = 1 } },
				lualine_z = { { "location", padding = 1 } },
			},
		}
	end,
	config = function(_, opts)
		require("lualine").setup(opts)
		apply_disabled_statusline_highlight()

		local highlight_group = vim.api.nvim_create_augroup("UserLualineHighlights", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = highlight_group,
			callback = function()
				vim.schedule(apply_disabled_statusline_highlight)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("UserLualineGrapple", { clear = true }),
			pattern = { "GrappleUpdate", "GrappleScopeChanged" },
			callback = function()
				require("lualine").refresh({
					scope = "tabpage",
					place = { "statusline" },
				})
			end,
		})
	end,
}
