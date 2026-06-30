local utils = require("user.lib.utils")
local sidebars = require("user.lib.sidebars")
local term = require("user.lib.term")
local map = utils.map
local unmap = utils.unmap

local M = {}

local silent = { silent = true }
local remap = { remap = true }

-- Use capital modifier names: `<C-l>`, `<M-b>`, `<D-i>`, `<S-Tab>`.
-- Use canonical named keys: `<Tab>`, `<BS>`, `<CR>`, `<Esc>`, `<Up>`, `<ScrollWheelDown>`.
-- Keep `<leader>` lowercase.
-- Spell shifted modified letter chords explicitly when shift is part of the chord: `<M-S-q>` instead of `<M-Q>`.
-- Preserve intentional letter case after `<leader>` and in plain Vim keys, like `<leader>O`, `gD`, or `zR`.
-- In RHS command strings, use `<Cmd>`, `<CR>`, `<Esc>`, and `<Bar>`.

-- stolen from lazy.vim: https://github.com/LazyVim/LazyVim/blob/83d90f339defdb109a6ede333865a66ffc7ef6aa/lua/lazyvim/config/keymaps.lua#L124
local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end

-- move it here, no harm done
map("n", "K", function()
	vim.lsp.buf.hover({ border = utils.window_border })
end, { noremap = true, silent = true })

local function restart_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return
	end

	local names = {}
	for _, client in ipairs(clients) do
		local name = client.config and client.config.name or client.name
		if name then
			names[name] = true
		end
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		for name, _ in pairs(names) do
			vim.lsp.enable(name, false)
			vim.lsp.enable(name, true)
		end
	end, 100)
end

local function toggle_virtual_lines()
	local config = vim.diagnostic.config()
	vim.diagnostic.config({
		virtual_lines = not config.virtual_lines,
	})
end

M.lsp_keymaps = function(bufnr, client)
	local opts = { noremap = true, silent = true }
	map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts, bufnr)
	map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, bufnr)
	map("n", "gl", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts, bufnr)

	if client.name ~= "texlab" then
		map("n", "<leader>li", "<Cmd>LspInfo<CR>", opts, bufnr)
		-- map("n", "<leader>lI", "<Cmd>LspInstallInfo<CR>", opts, bufnr)
		map("n", "<leader>lI", "<Cmd>Mason<CR>", opts, bufnr)
		map("n", "]e", diagnostic_goto(true, "ERROR"), opts, bufnr)
		map("n", "[e", diagnostic_goto(false, "ERROR"), opts, bufnr)
		map("n", "]w", diagnostic_goto(true, "WARN"), opts, bufnr)
		map("n", "[w", diagnostic_goto(false, "WARN"), opts, bufnr)
		map("n", "<leader>ls", function()
			vim.lsp.buf.signature_help({ border = utils.window_border })
		end, opts, bufnr)
		map("n", "<leader>lq", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts, bufnr)
		map("n", "<leader>lv", toggle_virtual_lines, opts, bufnr)

		map("n", "<leader>lR", function()
			restart_lsp(bufnr)
		end, opts, bufnr)
	end

	if client.name == "tailwindcss" then
		map("n", "<leader>tf", "<Cmd>TailwindSort<CR>", opts, bufnr)
		-- map("v", "<leader>tf", "<Cmd>TailwindSortSelection<CR>", opts, bufnr)

		map("n", "<leader>tt", "<Cmd>TailwindConcealToggle<CR>", opts, bufnr)
		map("n", "<leader>tc", "<Cmd>TailwindConcealEnable<CR>", opts, bufnr)
		map("n", "<leader>to", "<Cmd>TailwindConcealDisable<CR>", opts, bufnr)
	end

	if client.name == "metals" then
		map("n", "<leader>fc", "<Cmd>lua require('telescope').extensions.metals.commands()<CR>", opts, bufnr)
	end

	if client.name == "rust-analyzer" then
		map({ "n", "x" }, "gra", function()
			vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
			-- or vim.lsp.buf.codeAction() if you don't want grouping.
		end, opts, bufnr)
		map("n", "K", function()
			vim.cmd.RustLsp({ "hover", "actions" }) -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
		end, opts, bufnr)
	end

	if client.name == "gopls" then
		-- Go DAP Testing
		-- To debug the closest method above the cursor, use:
		--   :lua require('dap-go').debug_test()
		-- Keymap: <leader>dt
		map("n", "<F6>", function()
			require("dap-go").debug_test()
		end, { noremap = true, silent = true, desc = "Debug nearest test (Go)" }, bufnr)

		-- Once a test was run, you can simply run it again from anywhere:
		--   :lua require('dap-go').debug_last_test()
		-- Keymap: <leader>dl
		map("n", "<F7>", function()
			require("dap-go").debug_last_test()
		end, { noremap = true, silent = true, desc = "Debug last test (Go)" }, bufnr)
	end
end

-- spectre-nvim, from default config
-- vim.keymap.set("n", "<leader>S", '<Cmd>lua require("spectre").toggle()<CR>', {
-- 	desc = "Toggle Spectre",
-- })
-- vim.keymap.set("n", "<leader>Sw", '<Cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
-- 	desc = "Search current word",
-- })
-- vim.keymap.set("v", "<leader>Sw", '<Esc><Cmd>lua require("spectre").open_visual()<CR>', {
-- 	desc = "Search current word",
-- })
-- vim.keymap.set("n", "<leader>Sp", '<Cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
-- 	desc = "Search on current file",
-- })

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
	unmap("n", "<M-S-q>")
	unmap("n", "<M-2>")
	unmap("n", "<M-S-w>")
	unmap("n", "<M-3>")
	unmap("n", "<M-4>")
end

M.setup_dap_maps = function()
	M.push_map({ "n", "v" }, "K", require("dapui").eval)
	map("n", "<M-1>", require("dap").continue)
	map("n", "<M-S-q>", require("dap").run_to_cursor)
	map("n", "<M-2>", require("dap").step_over)
	map("n", "<M-S-w>", require("dap").step_into)
	map("n", "<M-3>", require("dap").terminate)
	map("n", "<M-4>", require("dap").run_last)
end

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
map("n", "<leader>wq", "<Cmd>Bdelete!<CR><C-w>q", silent)
-- <leader>ws: shade.nvim toggle (in shade.lua)
--
-- Resize with arrows
map("n", "<C-Up>", "<Cmd>resize -2<CR>", silent)
map("n", "<C-Down>", "<Cmd>resize +2<CR>", silent)
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", silent)
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", silent)

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

-- lint/format
map("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "<leader>lF", function()
	require("conform").format({ async = false, timeout_ms = 3000, lsp_format = "fallback" })
end, { desc = "Format buffer synchronously" })
map("n", "<leader>ll", function()
	require("user.lsp.lint").try_lint()
end, { desc = "Lint buffer" })
map("n", "<leader>lL", function()
	require("user.lsp.lint").try_all()
end, { desc = "Lint buffer with all configured linters" })

-- Plugins

-- Dropbar
map("n", "<leader>;", function()
	require("dropbar.api").pick()
end, { desc = "Pick winbar symbol" })
map("n", "[;", function()
	require("dropbar.api").goto_context_start()
end, { desc = "Go to context start" })
map("n", "];", function()
	require("dropbar.api").select_next_context()
end, { desc = "Select next context" })

-- NvimTree/NeoTree
map("n", "<leader>e", function()
	sidebars.toggle("nvimtree")
end, silent)

-- Telescope
map("n", "<leader>ff", function()
	if require("remote-sshfs.connections").is_connected() then
		require("remote-sshfs.api").find_files()
	else
		require("telescope.builtin").find_files()
	end
end, silent)
map("n", "<leader>ft", function()
	if require("remote-sshfs.connections").is_connected() then
		require("remote-sshfs.api").live_grep()
	else
		require("telescope.builtin").live_grep()
	end
end, silent)
map("n", "<leader>fT", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", silent)
map("n", "<leader>fp", "<Cmd>Telescope<CR>", silent)
-- map("n", "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers()<CR>", silent)
map("n", "<leader>fr", "<Cmd>lua require('telescope.builtinl).oldfiles()<CR>", silent)
map("n", "<leader>fw", "<Cmd>lua require('telescope').extensions.worktrees.list_worktrees()<CR>", silent)

map("n", "<leader>o", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", silent)
map("n", "<leader>O", function()
	require("telescope.builtin").lsp_workspace_symbols({ initial_mode = "normal" })
end, silent)

-- Git
map("n", "<leader>gg", function()
	term.toggle_lazygit()
end, silent)
map("n", "<leader>rr", function()
	sidebars.toggle("diffview")
end, { desc = "Diffview" })
map("n", "<leader>rh", function()
	sidebars.toggle("diffview_history")
end, { desc = "Diffview history" })
map("n", "<leader>gs", "<Cmd>Gitsigns toggle_signs<CR>", silent)

-- Comment
map("n", "<leader>/", "<Cmd>lua require('Comment.api').toggle.linewise.current()<CR>", silent)
map("x", "<leader>/", '<Esc><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')
map("x", "<leader>?", '<Esc><Cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>')

-- DAP
map("n", "<F5>", function()
	require("dap").continue()
end)
map("n", "<F4>", function()
	require("dap")
	sidebars.toggle("dapui")
end)
map("n", "<M-b>", function()
	require("dap").toggle_breakpoint()
end)
map("n", "<M-S-b>", function()
	local condition = vim.fn.input(" Breakpoint condition: ")
	if condition then
		require("dap").toggle_breakpoint(condition)
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
map("n", "<leader>M", function()
	require("grapple").toggle()
end)
-- function()
-- local marks = require("harpoon").get_mark_config().marks
-- local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
-- local ct_before = #marks
-- require("harpoon.mark").add_file()
-- if #marks ~= ct_before then
-- 	vim.api.nvim_echo({ { ('"%s" successfully marked with index %d'):format(bufname, #marks) } }, false, {})
-- end
-- end, silent)

map("n", "<leader>m", function()
	require("grapple").toggle_tags()
end)

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
-- map("n", "<leader>A", "<Cmd>Alpha<CR>", silent)

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

-- treesitter-context
map("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, silent)

-- avante
-- map("v", "<D-i>", "<Cmd>AvanteAsk<CR><Esc><Cmd>AvanteFocus<CR>", { remap = true })
-- -- clear selected code
-- map("n", "<leader>aD", "<Cmd>AvanteToggle<CR><Cmd>AvanteToggle<CR>", silent)
-- -- lazy load avante
-- map("n", "<leader>aa", function()
-- 	require("avante.api").ask()
-- end, silent)

-- sidekick
map("i", "<S-Tab>", function()
	-- if there is a next edit, jump to it, otherwise apply it if any
	if not require("sidekick").nes_jump_or_apply() then
		return "<S-Tab>" -- fallback to normal s-tab
	end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

map({ "n", "t", "i" }, "<D-i>", function()
	sidebars.open("sidekick", true)
	require("sidekick.cli").focus()
end, { desc = "Sidekick Focus" })

map("n", "<leader>aa", function()
	-- require("sidekick.cli").toggle()
	sidebars.toggle("sidekick")
end, { desc = "Sidekick Toggle CLI" })

map("n", "<leader>a?", function()
	require("sidekick.cli").select()
end, { desc = "Select CLI" })

map("n", "<leader>ad", function()
	require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })

map({ "x", "n" }, "<leader>at", function()
	sidebars.open("sidekick", true)
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

map("n", "<leader>ac", function()
	sidebars.open("sidekick", true)
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

map("x", "<D-i>", function()
	sidebars.open("sidekick", true)
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

map({ "n", "x" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

-- remote-sshfs
map("n", "<leader>rc", function()
	require("remote-sshfs.api").connect()
end)
map("n", "<leader>rd", function()
	require("remote-sshfs.api").disconnect()
end)
map("n", "<leader>re", function()
	require("remote-sshfs.api").edit()
end)

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

return M
