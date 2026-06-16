return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local logos = require("user.lib.logos")

		dashboard.section.header.val = logos["random"]
		dashboard.section.buttons.val = {
			dashboard.button("p", " " .. " Restore session", "<Cmd>lua require('persistence').load()<CR>"),
			dashboard.button(
				"<leader>e",
				"󰙅 " .. " Browse files",
				"<Cmd>lua require('nvim-tree.api').tree.toggle()<CR>"
			),
			dashboard.button(
				"<leader>ff",
				"󰮗 " .. " Find file",
				"<Cmd>lua require('telescope.builtin').find_files({hidden=true})<CR>"
			),
			dashboard.button(
				"<leader>fr",
				" " .. " Recent files",
				"<Cmd>lua require('telescope.builtin').oldfiles()<CR>"
			),
			dashboard.button(
				"<leader>gg",
				"󰊢 " .. " Open Lazygit",
				"<Cmd>lua require('user.lib.term').toggle_lazygit()<CR>"
			),
			dashboard.button("n", " " .. " New file", "<Cmd>ene <Bar> startinsert <CR>"),
			dashboard.button("q", " " .. " Quit", "<Cmd>qa<CR>"),
		}

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"
		dashboard.opts.opts.noautocmd = true

		alpha.setup(dashboard.opts)
	end,
}
