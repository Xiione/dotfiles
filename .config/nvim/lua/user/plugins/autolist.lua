return {
	"gaoDean/autolist.nvim",
	ft = { "markdown" },
	config = function()
		require("autolist").setup()

		local function map_markdown_buffer(buf)
			if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "markdown" then
				return
			end

			local buffer = { buffer = buf }

			vim.keymap.set("i", "<CR>", function()
				local cmp = package.loaded["cmp"]
				if cmp and cmp.visible() then
					vim.schedule(function()
						if cmp.visible() then
							cmp.confirm({ select = true })
						end
					end)
					return ""
				end

				return "<CR><Cmd>AutolistNewBullet<CR>"
			end, vim.tbl_extend("force", buffer, { expr = true, replace_keycodes = true }))
			vim.keymap.set("i", "<Tab>", "<cmd>AutolistTab<cr>", buffer)
			vim.keymap.set("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>", buffer)
			-- vim.keymap.set("i", "<C-t>", "<c-t><cmd>AutolistRecalculate<cr>", buffer) -- an example of using <c-t> to indent
			vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>", buffer)
			vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", buffer)
			vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", buffer)

			-- cycle list types with dot-repeat
			vim.keymap.set(
				"n",
				"<leader>cn",
				require("autolist").cycle_next_dr,
				vim.tbl_extend("force", buffer, { expr = true })
			)
			vim.keymap.set(
				"n",
				"<leader>cp",
				require("autolist").cycle_prev_dr,
				vim.tbl_extend("force", buffer, { expr = true })
			)

			-- if you don't want dot-repeat
			-- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>", buffer)
			-- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>", buffer)

			-- functions to recalculate list on edit
			vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", buffer)
			vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", buffer)
			vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", buffer)
			vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>", buffer)
		end

		map_markdown_buffer(0)
		vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
			group = vim.api.nvim_create_augroup("AutolistMarkdownMappings", { clear = true }),
			callback = function(args)
				map_markdown_buffer(args.buf)
			end,
		})
	end,
}
