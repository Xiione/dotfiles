local status_ok, smoothcursor = pcall(require, "smoothcursor")
if not status_ok then
	return
end

local sidebars = require("user.lib.sidebars")

smoothcursor.setup({
    autostart = true,
    cursor = "",              -- cursor shape (need nerd font)
    texthl = "SmoothCursor",   -- highlight group, default is { bg = nil, fg = "#FFD400" }
    linehl = nil,              -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
    type = "default",          -- define cursor movement calculate function, "default" or "exp" (exponential).
    fancy = {
        enable = true,        -- enable fancy mode
        head = { cursor = "", texthl = "SmoothCursor", linehl = nil },
        body = {
            { cursor = "", texthl = "SmoothCursor9" },
            { cursor = "󰝥", texthl = "SmoothCursor3" },
            { cursor = "󰝥", texthl = "SmoothCursor3" },
            { cursor = "", texthl = "SmoothCursor2" },
            { cursor = "•", texthl = "SmoothCursor2" },
            { cursor = "󰧟", texthl = "SmoothCursor1" },
            { cursor = "󰧟", texthl = "SmoothCursor0" },
            -- { cursor = "󰝥", texthl = "SmoothCursorRed" },
            -- { cursor = "󰻂", texthl = "SmoothCursorOrange" },
            -- { cursor = "", texthl = "SmoothCursorYellow" },
            -- { cursor = "", texthl = "SmoothCursorGreen" },
            -- { cursor = "", texthl = "SmoothCursorAqua" },
            -- { cursor = "", texthl = "SmoothCursorBlue" },
            -- { cursor = "•", texthl = "SmoothCursorPurple" },
            -- ●󰝥󰧟
        },
        tail = { cursor = nil, texthl = "SmoothCursor" }
    },
    flyin_effect = nil,        -- "bottom" or "top"
    speed = 25,                -- max is 100 to stick to your current position
    intervals = 35,            -- tick interval
    priority = 10,             -- set marker priority
    timeout = 3000,            -- timout for animation
    threshold = 3,             -- animate if threshold lines jump
    disable_float_win = true, -- disable on float window
    disabled_filetypes = sidebars.sidebar_types,  -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
})
