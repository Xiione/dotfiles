local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")

-- indent_blankline.setup({
--     exclude = {
--         buftypes = { "terminal", "nofile" },
--         filetypes = sidebars.sidebar_types
--     },
--     indent = {
--         char = "▏"
--     },
--     scope = {
--         show_start = false,
--         show_end = false
--     }
-- })
