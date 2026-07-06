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
		local colors = require("user.cfg.colors")
		local icons = require("user.cfg.icons")
		local scratch = require("user.lib.scratch")
		local nord = require("lualine.themes.nord")
		local uv = vim.uv
		local scratch_icon = Snacks.util.icon("markdown", "filetype") or icons.lsp_kind.File
		local scratch_cache = {
			count = 0,
			expires_at = 0,
		}

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
					statusline = sidebars.sidebar_types,
				},
			},
			sections = {
				lualine_a = { { "mode", padding = 1 } },
				lualine_b = { diagnostics },
				lualine_c = { "grapple", render_scratch_count },
				lualine_x = { "filetype" },
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
	end,
}
