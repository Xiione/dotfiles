local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
    return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
    disable_netrw = true,
    open_on_setup = true,
    open_on_setup_file = true,
    update_focused_file = {
        enable = true,
        update_root = false,
        -- ignore_list = {"help"}
    },
    sync_root_with_cwd = true,
    actions = {
        file_popup = {
            open_win_config = {
                border = "rounded",
            },
        },
    },
    renderer = {
        root_folder_modifier = ":~",
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_open = " ",
                    arrow_closed = " ",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "",
                    staged = "",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "",
                    deleted = "✖",
                    ignored = "",
                },
            },
        },
        indent_width = 1,
        indent_markers = {
            enable = true,
            inline_arrows = false,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    view = {
        width = 40,
        side = "left",
        mappings = {
            list = {
                { key = "l", cb = tree_cb("edit") },
                { key = ".", cb = tree_cb("cd") },
                { key = "h", cb = tree_cb("close_node") },
                { key = "v", cb = tree_cb("vsplit") },
                { key = "K", cb = tree_cb("toggle_file_info") },
            },
        },
    },
})
