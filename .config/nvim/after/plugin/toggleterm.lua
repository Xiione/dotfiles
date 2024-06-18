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
	auto_scroll = false,
	float_opts = {
		border = "solid",
		-- winblend = 5
	},
	highlights = {
		Normal = {
			link = "NormalFloat",
			sp = "None",
		},
		NormalFloat = {
			link = "NormalFloat",
			sp = "None",
		},
		FloatBorder = {
			link = "FloatBorder",
			sp = "None",
		},
	},
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end
