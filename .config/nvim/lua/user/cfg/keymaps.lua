local utils = require("user.lib.utils")
local sidebars = require("user.lib.sidebars")
local term = require("user.lib.term")
local map = utils.map
local unmap = utils.unmap

local dap = require("dap")
local dapui = require("dapui")
local pbreakpoints = require("persistent-breakpoints.api")
local supermaven = require("supermaven-nvim.api")

local M = {}

local silent = { silent = true }
local remap = { remap = true }

--Remap space as leader key
map("", "<Space>", "<Nop>", silent)
vim.g.mapleader = " "

-- normal_mode = "n",
-- insert_mode = "i",
-- visual_mode = "v",
-- visual_block_mode = "x",
-- term_mode = "t",
-- command_mode = "c",

-- Editing maps

-- stole from william - delete a word at a time
map({ "i", "c" }, "<M-bs>", "<C-w>", { remap = true })

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
map("n", "<leader>wq", "<cmd>Bdelete!<CR><C-w>q", silent)
-- <leader>ws: shade.nvim toggle (in shade.lua)
--
-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize -2<CR>", silent)
map("n", "<C-Down>", "<cmd>resize +2<CR>", silent)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", silent)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", silent)

-- cmd-A select all
map("n", "<M-a>", "ggVG", { remap = true })

-- No overwrite paste and system clipboard paste
map("x", "<leader>p", '"_dP', silent)

map("n", "<leader>y", '"+y', silent)
map("v", "<leader>y", '"+y', silent)
map("n", "<leader>Y", '"+Y', silent)

map("n", "<leader>d", '"_d', silent)
map("v", "<leader>d", '"_d', silent)

-- Stay in indent mode
map("v", "<", "<gv", silent)
map("v", ">", ">gv", silent)

-- Center screen when C-u C-d
map("n", "<C-d>", "<C-d>zz", silent)
map("n", "<C-u>", "<C-u>zz", silent)

-- qf navigation
map("n", "<leader>k", "<cmd>cprev<CR>zz")
map("n", "<leader>j", "<cmd>cnext<CR>zz")
-- close quickfix
map("n", "<leader>q", "<cmd>cclose<CR>", silent)

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
-- map("t", "<esc>", "<C-\\><C-n>", silent)
map("t", "<C-h>", "<C-\\><C-n><C-W>h", silent)
map("t", "<C-j>", "<C-\\><C-n><C-W>j", silent)
map("t", "<C-k>", "<C-\\><C-n><C-W>k", silent)
map("t", "<C-l>", "<C-\\><C-n><C-W>l", silent)

-- lsp formatter
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", silent)

-- Plugins

-- NvimTree/NeoTree
map("n", "<leader>e", function()
	sidebars.toggle("nvimtree")
end, silent)

-- Telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files({hidden=true})<CR>", silent)
map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').live_grep()<CR>", silent)
map("n", "<leader>fT", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", silent)
map("n", "<leader>fp", "<cmd>Telescope<CR>", silent)
-- map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", silent)
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", silent)

map("n", "<leader>o", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", silent)
map("n", "<leader>O", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", silent)

-- Git
map("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", silent)
map("n", "<leader>gs", "<cmd>Gitsigns toggle_signs<CR>", silent)

-- Comment
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", silent)
map("x", "<leader>/", '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
map("n", "<F5>", function()
	dap.continue()
end)
map("n", "<F4>", function()
	sidebars.toggle("dapui")
end)
map("n", "<M-b>", pbreakpoints.toggle_breakpoint)
map("n", "<M-S-b>", function()
	local condition = vim.fn.input(" Breakpoint condition: ")
	if condition then
		pbreakpoints.set_conditional_breakpoint(condition)
	end
end)
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

-- Undotree
map("n", "<leader>u", function()
	sidebars.toggle("undotree")
end, silent)

-- Harpoon/Grapple
map("n", "<leader>a", require("grapple").toggle)
-- function()
-- local marks = require("harpoon").get_mark_config().marks
-- local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
-- local ct_before = #marks
-- require("harpoon.mark").add_file()
-- if #marks ~= ct_before then
-- 	vim.api.nvim_echo({ { ('"%s" successfully marked with index %d'):format(bufname, #marks) } }, false, {})
-- end
-- end, silent)

map("n", "<leader>m", require("grapple").toggle_tags)
-- function()
-- require("harpoon.ui").toggle_quick_menu()
-- end, silent)

for i = 1, 9 do
	map("n", string.format("<leader>%d", i), function()
		require("grapple").select({ index = i })
		-- require("harpoon.ui").nav_file(i)
	end, silent)
end

-- Alpha
map("n", "<leader>A", "<cmd>Alpha<CR>", silent)

-- Symbols outline
-- replaced with telescope picker

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
map("i", "<C-i>", "<cmd>Inspect<CR>", silent)

-- ufo
map("n", "zR", require("ufo").openAllFolds)
map("n", "zM", require("ufo").closeAllFolds)

-- move it here, no harm done
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
M.lsp_keymaps = function(bufnr, client)
	local opts = { noremap = true, silent = true }
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts, bufnr)
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts, bufnr)
	map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts, bufnr)
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, bufnr)
	map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, bufnr)

	if client.name ~= "texlab" then
		map("n", "<leader>li", "<cmd>LspInfo<CR>", opts, bufnr)
		-- map("n", "<leader>lI", "<cmd>LspInstallInfo<CR>", opts, bufnr)
		map("n", "<leader>lI", "<cmd>Mason<CR>", opts, bufnr)
		map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, bufnr)
		map("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts, bufnr)
		map("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts, bufnr)
		map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, bufnr)
		map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, bufnr)
		map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts, bufnr)

		map("n", "<leader>llR", "<cmd>LspRestart<CR>", opts, bufnr)
	end

	if client.name == "tailwindcss" then
		map("n", "<leader>tf", "<cmd>TailwindSort<CR>", opts, bufnr)
		-- map("v", "<leader>tf", "<cmd>TailwindSortSelection<CR>", opts, bufnr)

		map("n", "<leader>tt", "<cmd>TailwindConcealToggle<CR>", opts, bufnr)
		map("n", "<leader>tc", "<cmd>TailwindConcealEnable<CR>", opts, bufnr)
		map("n", "<leader>to", "<cmd>TailwindConcealDisable<CR>", opts, bufnr)
	end

	if client.name == "metals" then
		map("n", "<leader>fc", "<cmd>lua require('telescope').extensions.metals.commands()<CR>", opts, bufnr)
	end
end

-- neogurt
if vim.g.neogurt then
	-- all modes
	local mode = { "", "!", "t", "l" }
	map(mode, "<D-l>", "<cmd>Neogurt session_prev<CR>")
	map(mode, "<D-m>", "<cmd>Neogurt session_select sort=time<CR>")

	map(mode, "<D-=>", "<cmd>Neogurt font_size_change 1 all=false<cr>")
	map(mode, "<D-->", "<cmd>Neogurt font_size_change -1 all=false<cr>")
	map(mode, "<D-0>", "<cmd>Neogurt font_size_reset all=false<cr>")

	M.neogurt_open_session_finder = function(init)
		local cmd = [[
            echo "$(begin;
              echo ~/;
              echo ~/dotfiles;
              find ~/code -mindepth 0 -maxdepth 2 -type d;
            end;)"
        ]]
		local output = vim.fn.system(cmd)

		local dirs = {}
		for dir in string.gmatch(output, "([^\n]+)") do
			table.insert(dirs, dir)
		end

		vim.ui.select(dirs, {
			prompt = "Create a session",
			-- format_item = function(item)
			--   return "(" .. item.id .. ") - " .. item.name
			-- end
		}, function(choice)
			if choice == nil then
				return
			end
			local dir = choice
			local fmod = vim.fn.fnamemodify
			local name = fmod(fmod(dir, ":h"), ":t") .. "/" .. fmod(dir, ":t")

			if init then
				local currId = vim.g.neogurt_cmd("session_info").id
				vim.g.neogurt_cmd("session_new", { dir = dir, name = name })
				vim.g.neogurt_cmd("session_kill", { id = currId })
			else
				vim.g.neogurt_cmd("session_new", { dir = dir, name = name })
			end
		end)
	end

	map(mode, "<D-s>", function()
		M.neogurt_open_session_finder(false)
	end)

	map({ "n", "v" }, "<D-v>", '"+p', silent)
	map({ "i", "c" }, "<D-v>", "<C-r>+", silent)
	map("t", "<D-v>", "<C-\\><C-N><D-v>i", remap)
	-- map({ "i", "c", "t" }, "<D-bs>", "<C-u>")

	vim.g.neogurt_startup = function()
		M.neogurt_open_session_finder(true)
	end
end

-- supermaven/copilot
map("n", "<leader>C", "<cmd>SupermavenToggle<CR>")
-- map("n", "<leader>c", function ()
--     vim.cmd("SupermavenStop")
-- 	-- vim.notify("Supermaven off")
-- end)
-- map("n", "<leader>C", function ()
--     vim.cmd("SupermavenStart")
-- 	-- vim.notify("Supermaven on")
-- end)

-- spectre-nvim, from default config
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

local original_mappings = {}
M.push_map = function(mode, key, new_mapping, bufnr)
	original_mappings[key] = { mapping = vim.fn.maparg(key, "n"), new_mode = mode }
	unmap("n", key, bufnr)
	map(mode, key, new_mapping, silent, bufnr)
end

M.pop_map = function(key)
	if original_mappings[key] then
		unmap(original_mappings[key].new_mode, key)
		map("n", key, original_mappings[key].mapping, silent)
		original_mappings[key] = nil
	end
end

M.remove_dap_maps = function()
	M.pop_map("K")
	unmap("n", "<M-1>")
	unmap("n", "<M-S-1>")
	unmap("n", "<M-2>")
	unmap("n", "<M-S-2>")
	unmap("n", "<M-3>")
	unmap("n", "<M-4>")
end

M.setup_dap_maps = function()
	M.push_map({ "n", "v" }, "K", dapui.eval)
	map("n", "<M-1>", dap.continue)
	map("n", "<M-Q>", dap.run_to_cursor)
	map("n", "<M-2>", dap.step_over)
	map("n", "<M-W>", dap.step_into)
	map("n", "<M-3>", dap.terminate)
	map("n", "<M-4>", dap.run_last)
end

return M
