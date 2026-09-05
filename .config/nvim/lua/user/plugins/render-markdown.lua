local utils = require("user.lib.utils")
local icons = require("user.cfg.icons")

local heading_signs = vim.tbl_map(function(icon)
	return icon .. " "
end, icons.markdown_heading)
local hidden_heading_icons = vim.tbl_map(function()
	return ""
end, icons.markdown_heading)

local function combine_math_highlights(buf)
	local namespace = vim.api.nvim_get_namespaces()["render-markdown.nvim"]
	if not namespace then
		return
	end

	for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(buf, namespace, 0, -1, { details = true })) do
		local details = mark[4]
		local has_math = details
			and details.virt_text_pos == "inline"
			and details.virt_text
			and vim.iter(details.virt_text):any(function(chunk)
				return chunk[2] == "RenderMarkdownMath"
			end)

		if has_math then
			local options = vim.tbl_extend("force", {}, details, {
				id = mark[1],
				hl_mode = "combine",
			})
			options.ns_id = nil
			options.priority = nil
			options.right_gravity = nil
			options.end_right_gravity = nil

			vim.api.nvim_buf_set_extmark(buf, namespace, mark[2], mark[3], options)
		end
	end
end

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "Avante" },
	opts = {
		file_types = { "markdown", "Avante" },
		latex = { enabled = true },
		win_options = { conceallevel = { rendered = 2 } },
		code = {
			border = "none",
			language_border = "",
		},
		heading = {
			icons = hidden_heading_icons,
			signs = heading_signs,
		},
		on = {
			attach = function()
				-- nabla
				vim.keymap.set("n", "K", function()
					require("nabla").popup({
						border = utils.window_border,
					})
				end, { buffer = 0, silent = true })
			end,
			render = function(ctx)
				-- render-markdown has no LaTeX hl_mode option; combine rendered
				-- math with the heading background only in the rendered view.
				combine_math_highlights(ctx.buf)
			end,
		},
	},
}
