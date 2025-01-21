local status_ok, supermaven = pcall(require, "supermaven-nvim")
if not status_ok then
    return
end

supermaven.setup({
    ignore_filetypes = require("user.lib.sidebars").sidebar_types,
    log_level = "off",
    disable_inline_completion = true,
    disable_keymaps = true,
})
