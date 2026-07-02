return {
	"numToStr/Comment.nvim",
	lazy = false,
	keys = {
		{
			"<leader>/",
			"<Cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
			desc = "Toggle line comment",
			silent = true,
		},
		{
			"<leader>/",
			'<Esc><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
			mode = "x",
			desc = "Toggle line comment",
		},
		{
			"<leader>?",
			'<Esc><Cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>',
			mode = "x",
			desc = "Toggle block comment",
		},
	},
	opts = {
		pre_hook = function(ctx)
			-- Only calculate commentstring for tsx filetypes
			if vim.bo.filetype == "typescriptreact" then
				local U = require("Comment.utils")

				-- Determine whether to use linewise or blockwise commentstring
				local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

				-- Determine the location where to calculate commentstring from
				local location = nil
				if ctx.ctype == U.ctype.blockwise then
					location = require("ts_context_commentstring.utils").get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
					location = require("ts_context_commentstring.utils").get_visual_start_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring({
					key = type,
					location = location,
				})
			end
		end,
	},
}
