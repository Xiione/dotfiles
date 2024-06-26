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
    dashboard.button("p", " " .. " Restore session", "<CMD>lua require('persistence').load()<CR>"),
    dashboard.button("e", "󰙅 " .. " Browse files", "<CMD>lua require('nvim-tree.api').tree.toggle()<CR>"),
    dashboard.button("f", "󰮗 " .. " Find file", "<CMD>lua require('telescope.builtin').find_files({hidden=true})<CR>"),
    dashboard.button("n", " " .. " New file", "<CMD>ene <BAR> startinsert <CR>"),
    dashboard.button("r", " " .. " Recent files", "<CMD>lua require('telescope.builtin').oldfiles()<CR>"),
    dashboard.button("t", "󱩾 " .. " Find text", "<CMD>lua require('telescope.builtin').live_grep()<CR>"),
    dashboard.button("g", "󰊢 " .. " Open Lazygit", "<CMD>lua _LAZYGIT_TOGGLE()<CR>"),
    -- dashboard.button("s", " " .. " Create packer snapshot", "<CMD>lua require('user.lib.utils').create_packer_snapshot()<CR>"),
    dashboard.button("q", " " .. " Quit", "<CMD>qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
