local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

local filetypes = {
    { "NvimTree",          "פּ" },
    { "neo-tree",          "פּ" },
    { "dapui_scopes",      "" },
    { "dapui_breakpoints", "" },
    { "dapui_stacks",      "" },
    { "dapui_watches",     "" },
    { "undotree",          "" },
    { "toggleterm",        "" },
}

local opts = {
    color_icons = true,
    show_buffer_icons = true,
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    offsets = {},
    separator_style = { "", "" }, -- | "thick" | "thin" | { 'any', 'any' },
    indicator = {
        style = "underline",
    },
    modified_icon = "",
    hover = {
        enabled = false,
        delay = 50,
        reveal = { "close" },
    },
    show_close_icon = false,
    show_buffer_close_icons = false,
}

for _, type in pairs(filetypes) do
    table.insert(opts.offsets, {
        filetype = type[1],
        -- text = type[2],
        text = "",
        text_align = "center",
        padding = 0,
        separator = "█",
    })
end

local highlights = require("nord").bufferline.highlights({
    italic = true,
    bold = true,
})

bufferline.setup({ options = opts, highlights = highlights })
