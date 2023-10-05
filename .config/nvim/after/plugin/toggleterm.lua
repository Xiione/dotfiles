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
        -- if term:is_open() then
        --     return
        -- end

        local str = data[1]
        if (str:match(utils.flag_build_success)) then
            print("Build success")
        elseif (str:match(utils.flag_build_fail)) then
            term:open()
        elseif (str:match(utils.flag_ready_debug)) then
            if (term:is_open()) then
                term:close()
            end
            dap.continue()
        end
    end,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end
