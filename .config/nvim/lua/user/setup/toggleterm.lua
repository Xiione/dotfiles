local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

local dap = require("dap")

local utils = require("user.lib.utils")

toggleterm.setup({
	size = 13,
	open_mapping = [[<C-\>]],
	hide_numbers = true,
	start_in_insert = true,
	persist_size = false,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	auto_scroll = true,
	float_opts = {
		border = "solid",
        -- winblend = 5
	},
	highlights = {
        Normal = {
            link = "NormalFloat",
            sp = "None"
        },
        NormalFloat = {
            link = "NormalFloat",
            sp = "None"
        },
		FloatBorder = {
            link = "FloatBorder",
            sp = "None"
		},
	},
    on_stdout = function(term, job, data, name)
        if term:is_open() then
            return
        end

        local str = data[1]
        if (str:match(utils.flag_build_success)) then
            print("Build success")
        elseif (str:match(utils.flag_build_fail)) then
            term:open()
        elseif (str:match(utils.flag_ready_debug)) then
            dap.continue()
        end
    end,
})

-- function _G.set_terminal_keymaps()
-- 	local opts = { noremap = true }
-- 	-- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
-- end
--
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
--
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end
