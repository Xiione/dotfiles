return {
	"gaoDean/autolist.nvim",
	ft = { "markdown" },
	config = function()
		require("autolist").setup()

		local function map_markdown_enter(buf)
			if vim.bo[buf].filetype ~= "markdown" then
				return
			end

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
			end, { buffer = buf, expr = true, replace_keycodes = true })
		end

		map_markdown_enter(0)
		vim.api.nvim_create_autocmd("InsertEnter", {
			group = vim.api.nvim_create_augroup("AutolistMarkdownMappings", { clear = true }),
			callback = function(args)
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(args.buf) then
						map_markdown_enter(args.buf)
					end
				end)
			end,
		})

		vim.keymap.set("i", "<Tab>", "<cmd>AutolistTab<cr>")
		vim.keymap.set("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>")
		-- vim.keymap.set("i", "<C-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
		vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
		vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
		vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
		vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

		-- cycle list types with dot-repeat
		vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
		vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

		-- if you don't want dot-repeat
		-- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
		-- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

		-- functions to recalculate list on edit
		vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
		vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
		vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
		vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
	end,
}
