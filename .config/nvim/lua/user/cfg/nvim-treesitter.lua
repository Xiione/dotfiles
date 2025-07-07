local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    auto_install = true,
    ignore_install = { "latex" }, -- List of parsers to ignore installing
    sync_install = false,      -- install languages synchronously (only applied to `ensure_installed`)

    highlight = {
        enable = true,          -- false will disable the whole extension
        disable = { "css", "latex" }, -- list of language that will be disabled
    },
    autopairs = {
        enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            scope_incremental = "<CR>",
            node_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
        },
    },
    modules = {},
})
