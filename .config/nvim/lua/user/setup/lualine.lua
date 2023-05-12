local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local utils = require("user.lib.utils")

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = true,
    symbols = { added = " ", modified = "󰏫 ", removed = "󰇾 " }, -- changes diff symbols
    cond = hide_in_width,
}
local filetype = {
    "filetype",
    icons_enabled = true,
}

local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local colors = {
    -- nord0 = "#2E3440", -- i think the nord nvim theme makes all bgs with the nord0 color "none"
    nord0 = "#2E3441",
    nord1 = "#3B4252",
    nord2 = "#434C5E",
    nord3 = "#4C566A",
    nord4 = "#D8DEE9",
    nord5 = "#E5E9F0",
    nord6 = "#ECEFF4",
    nord7 = "#8FBCBB",
    nord8 = "#88C0D0",
    nord9 = "#81A1C1",
    nord10 = "#5E81AC",
    nord11 = "#BF616A",
    nord12 = "#D08770",
    nord13 = "#EBCB8B",
    nord14 = "#A3BE8C",
    nord15 = "#B48EAD",
}

local mynord = require("lualine.themes.nord")

local c = { fg = colors.nord4, bg = colors.nord0 }
local afg = colors.nord0
local bbg = colors.nord1

mynord.normal = {
    a = {
        fg = afg,
        bg = colors.nord4,
        gui = "bold",
    },
    b = {
        fg = colors.nord4,
        bg = bbg,
    },
    c = c,
}
mynord.insert = {
    a = {
        fg = afg,
        bg = colors.nord14,
        gui = "bold",
    },
    b = {
        fg = colors.nord14,
        bg = bbg,
    },
    c = c,
}
mynord.visual = {
    a = {
        fg = afg,
        bg = colors.nord7,
        gui = "bold",
    },
    b = {
        fg = colors.nord7,
        bg = bbg,
    },
    c = c,
}
mynord.replace = {
    a = {
        fg = afg,
        bg = colors.nord13,
        gui = "bold",
    },
    b = {
        fg = colors.nord13,
        bg = bbg,
    },
    c = c,
}
mynord.command = {
    a = {
        fg = afg,
        bg = colors.nord12,
        gui = "bold",
    },
    b = {
        fg = colors.nord12,
        bg = bbg,
    },
    c = c,
}

mynord.terminal = {
    a = {
        fg = afg,
        bg = colors.nord15,
        gui = "bold",
    },
    b = {
        fg = colors.nord15,
        bg = bbg,
    },
    c = c,
}
mynord.select = {
    a = {
        fg = afg,
        bg = colors.nord10,
        gui = "bold",
    },
    b = {
        fg = colors.nord10,
        bg = bbg,
    },
    c = c,
}
mynord.inactive = {
    c = {
        fg = colors.nord3,
        bg = colors.nord0,
    },
}

lualine.setup({
    options = {
        globalstatus = false,
        icons_enabled = true,
        theme = mynord,
        component_separators = "",
        section_separators = "",
        ignore_focus = utils.sidebar_types,
        disabled_filetypes = {
            "alpha",
            -- "dap-repl",
            -- "dapui_breakpoints",
            -- "dapui_scopes",
            -- "dapui_stacks",
            -- "dapui_watches",
            -- "NvimTree",
            -- "undotree",
            -- "qf",
        },
    },
    sections = {
        lualine_a = { { "mode", padding = 1 } },
        lualine_b = { diagnostics },
        lualine_c = { diff },
        lualine_x = {
            "filetype" },
        lualine_y = { { "progress", padding = 1 } },
        lualine_z = { { "location", padding = 1 } },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
})
