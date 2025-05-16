local status_ok, supermaven = pcall(require, "supermaven-nvim")
if not status_ok then
    return
end

local utils = require("user.lib.utils")
local map = utils.map

supermaven.setup({
    ignore_filetypes = require("user.lib.sidebars").sidebar_types,
    log_level = "off",
    disable_inline_completion = true,
    disable_keymaps = true,
})

-- supermaven/copilot
map("n", "<leader>C", "<cmd>SupermavenToggle<CR>", silent)
