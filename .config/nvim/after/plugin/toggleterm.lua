local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 13,
	open_mapping = [[<C-]>]],
	hide_numbers = true,
	start_in_insert = true,
	persist_size = false,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	auto_scroll = false,
	float_opts = {
		border = "solid",
		winblend = 5,
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

local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	close_on_exit = true,
	on_open = function(term)
		vim.keymap.set({ "n", "t" }, "<C-q>", function()
			term:close()
		end, { buffer = term.bufnr, silent = true })
	end,
})

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end
