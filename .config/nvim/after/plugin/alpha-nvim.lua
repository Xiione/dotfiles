local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
local logos = require("user.lib.logos")
local function header()
	return logos["random"]
end

dashboard.section.header.val = header()
dashboard.section.buttons.val = {
	dashboard.button("p", " " .. " Restore session", "<cmd>lua require('persistence').load()<CR>"),
	dashboard.button("<leader>e", "󰙅 " .. " Browse files", "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>"),
	dashboard.button(
		"<leader>ff",
		"󰮗 " .. " Find file",
		"<cmd>lua require('telescope.builtin').find_files({hidden=true})<CR>"
	),
	dashboard.button("<leader>fr", " " .. " Recent files", "<cmd>lua require('telescope.builtin').oldfiles()<CR>"),
	dashboard.button("<leader>gg", "󰊢 " .. " Open Lazygit", "<cmd>lua _LAZYGIT_TOGGLE()<CR>"),
	dashboard.button("n", " " .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
	-- dashboard.button("t", "󱩾 " .. " Find text", "<cmd>lua require('telescope.builtin').live_grep()<CR>"),
	-- dashboard.button("s", " " .. " Create packer snapshot", "<cmd>lua require('user.lib.utils').create_packer_snapshot()<CR>"),
	dashboard.button("q", " " .. " Quit", "<cmd>qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
