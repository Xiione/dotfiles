local utils = require("user.lib.utils")
local term = require("user.lib.term")
local map = utils.map

local silent = { silent = true }
local remap = { remap = true }

-- Use capital modifier names: `<C-l>`, `<M-b>`, `<D-i>`, `<S-Tab>`.
-- Use canonical named keys: `<Tab>`, `<BS>`, `<CR>`, `<Esc>`, `<Up>`, `<ScrollWheelDown>`.
-- Keep `<leader>` lowercase.
-- Spell shifted modified letter chords explicitly when shift is part of the chord: `<M-S-q>` instead of `<M-Q>`.
-- Preserve intentional letter case after `<leader>` and in plain Vim keys, like `<leader>O`, `gD`, or `zR`.
-- In RHS command strings, use `<Cmd>`, `<CR>`, `<Esc>`, and `<Bar>`.

-- move it here, no harm done
map("n", "K", function()
	vim.lsp.buf.hover({ border = utils.window_border })
end, { noremap = true, silent = true })

--Remap space as leader key
map("", "<Space>", "<Nop>", silent)

-- normal_mode = "n",
-- insert_mode = "i",
-- visual_mode = "v",
-- visual_block_mode = "x",
-- term_mode = "t",
-- command_mode = "c",

-- Editing maps

-- stole from william - delete a word at a time
map({ "i", "c" }, "<M-BS>", "<C-w>", { remap = true })

-- adjustments in insert and cmd
map("i", "<C-h>", "<Left>", silent)
map("i", "<C-l>", "<Right>", silent)
map("c", "<C-h>", "<Left>", { remap = true })
map("c", "<C-l>", "<Right>", { remap = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)
map("n", "<leader>wq", function()
	Snacks.bufdelete({ force = true })
	vim.cmd.quit()
end, silent)
--
-- Resize with arrows
local function resize_window(command, step)
	return function()
		vim.cmd(("%s %+d"):format(command, step * vim.v.count1))
	end
end

map("n", "<C-Up>", resize_window("resize", -1), silent)
map("n", "<C-Down>", resize_window("resize", 1), silent)
map("n", "<C-Left>", resize_window("vertical resize", -1), silent)
map("n", "<C-Right>", resize_window("vertical resize", 1), silent)

-- cmd-A select all
map("n", "<D-a>", "ggVG", { remap = true })

-- No overwrite paste and system clipboard paste
map("x", "<leader>p", '"_dP', silent)

map("n", "<leader>y", '"+y', silent)
map("v", "<leader>y", '"+y', silent)
map("n", "<leader>Y", '"+Y', { remap = true })

map("n", "<leader>d", '"_d', silent)
map("v", "<leader>d", '"_d', silent)

-- Stay in indent mode
map("v", "<", "<gv", silent)
map("v", ">", ">gv", silent)

-- Center screen when C-u C-d
map("n", "<C-d>", "<C-d>zz", silent)
map("n", "<C-u>", "<C-u>zz", silent)

-- qf navigation
map("n", "<leader>k", "<Cmd>cprev<CR>zz")
map("n", "<leader>j", "<Cmd>cnext<CR>zz")
-- close quickfix
map("n", "<leader>q", "<Cmd>cclose<CR>", silent)

-- fixing that stupid typo when trying to [save]exit
vim.cmd([[
    cnoreabbrev <expr> W     ((getcmdtype()  is# ':' && getcmdline() is# 'W')?('w'):('W'))
    cnoreabbrev <expr> Q     ((getcmdtype()  is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
    cnoreabbrev <expr> WQ    ((getcmdtype()  is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
    cnoreabbrev <expr> Wq    ((getcmdtype()  is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
    cnoreabbrev <expr> Qa    ((getcmdtype()  is# ':' && getcmdline() is# 'Qa')?('qa'):('Qa'))
    cnoreabbrev <expr> QA    ((getcmdtype()  is# ':' && getcmdline() is# 'QA')?('qa'):('QA'))
]])

-- theprimeagen replace thingie - inner word text obj
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- same as above using visual selection
-- https://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text
map("v", "<leader>s", '"hy:%s/<C-r>h//gc<Left><Left><Left>')

-- easier leave term
-- map("t", "<Esc>", "<C-\\><C-n>", silent)
-- map("t", "<C-h>", "<C-\\><C-n><C-w>h", silent)
-- map("t", "<C-j>", "<C-\\><C-n><C-w>j", silent)
-- map("t", "<C-k>", "<C-\\><C-n><C-w>k", silent)
-- map("t", "<C-l>", "<C-\\><C-n><C-w>l", silent)

-- alt-tab between recent spaces
map("n", "<leader><Tab>", "<C-6>", { remap = true })

term.set_global_build_cmd("<M-c>", "make build")
term.set_global_debug_cmd("<M-d>", "make build")
term.set_global_term_cmd("<M-r>", "make run")

-- newcpprob
map("n", "<M-o>", function()
	vim.cmd("cd ..")
	vim.notify(vim.fn.getcwd())
end)
map("n", "<M-p>", function()
	local probname = vim.fn.input(" Enter problem name (ESC to cancel): ")
	if not probname:match("^%s*$") then
		vim.fn.system("newcpprob " .. probname)
		vim.fn.chdir(probname)
		term.kill_term()
		vim.cmd("edit " .. probname .. ".cpp")
	end
end)

-- Alpha
-- map("n", "<leader>A", "<Cmd>Alpha<CR>", silent)

-- Symbols outline
-- replaced with Snacks picker

-- map("n", "<leader>o", function()
-- 	sidebars.toggle("symbols_outline")
-- end, silent)

-- Change trackpad scroll to move window instead of cursor
map("n", "<Up>", "<C-y>", silent)
map("n", "<Down>", "<C-e>", silent)
-- I'm pretty sure you can't use the trackpad for left and right anyways
map("n", "<Left>", "zh", silent)
map("n", "<Right>", "zl", silent)

-- Add :Inspect to insert mode for weird customization case for lsp_signature
map("i", "<C-i>", "<Cmd>Inspect<CR>", silent)

-- ufo
-- map("n", "zR", require("ufo").openAllFolds)
-- map("n", "zM", require("ufo").closeAllFolds)

--[[ map("n", "<leader>APM", function()
    require("vim-apm"):toggle_monitor()
end) ]]

-- map("n", "<leader>c", function ()
--     vim.cmd("SupermavenStop")
-- 	-- vim.notify("Supermaven off")
-- end)
-- map("n", "<leader>C", function ()
--     vim.cmd("SupermavenStart")
-- 	-- vim.notify("Supermaven on")
-- end)

-- map("n", "<leader>c", function()
-- 	require("copilot.suggestion").toggle_auto_trigger()
-- end, silent)

-- avante
-- map("v", "<D-i>", "<Cmd>AvanteAsk<CR><Esc><Cmd>AvanteFocus<CR>", { remap = true })
-- -- clear selected code
-- map("n", "<leader>aD", "<Cmd>AvanteToggle<CR><Cmd>AvanteToggle<CR>", silent)
-- -- lazy load avante
-- map("n", "<leader>aa", function()
-- 	require("avante.api").ask()
-- end, silent)

-- worktrees
-- map("n", "<leader>wc", function()
-- 	require("user.lib.worktrees").new()
-- end)

-- cd root
map("n", "<leader>.", "<Cmd>cd .<CR>")

-- shadow the built-in "move to bottom of screen" command
map("n", "L", "<Nop>", silent)

-- throttle trackpad scroll spam
local function throttled(keys, interval_ms)
	local last = 0
	local interval_ns = interval_ms * 1000000

	return function()
		local now = vim.uv.hrtime()
		if now - last < interval_ns then
			return
		end
		last = now
		vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
	end
end
map("n", "<ScrollWheelDown>", throttled("2<C-e>", 1), silent)
map("n", "<ScrollWheelUp>", throttled("2<C-y>", 1), silent)

return {}
