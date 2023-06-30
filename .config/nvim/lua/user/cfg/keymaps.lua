local utils = require("user.lib.utils")
local map = utils.map

local silent = { silent = true }
local silent_nore = { silent = true, remap = false }

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

-- adjustments in insert
map("i", "<C-h>", "<Left>", silent)
map("i", "<C-j>", "<Down>", silent)
map("i", "<C-k>", "<Up>", silent)
map("i", "<C-l>", "<Right>", silent)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)
map("n", "<C-q>", "<CMD>Bdelete!<CR><C-w>q", silent)
--
-- Resize with arrows
map("n", "<C-Up>", "<CMD>resize -2<CR>", silent)
map("n", "<C-Down>", "<CMD>resize +2<CR>", silent)
map("n", "<C-Left>", "<CMD>vertical resize -2<CR>", silent)
map("n", "<C-Right>", "<CMD>vertical resize +2<CR>", silent)

-- CMD-A select all
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



-- Plugins

-- NvimTree/NeoTree
map(
	"n",
	"<leader>e",
	"<CMD>lua require'dapui'.close()<CR>" .. "<CMD>lua require('nvim-tree.api').tree.toggle()<CR>",
	silent
)

-- Telescope
map("n", "<leader>ff", "<CMD>lua require('telescope.builtin').find_files({hidden=true})<CR>", silent)
map("n", "<leader>ft", "<CMD>lua require('telescope.builtin').live_grep()<CR>", silent)
map("n", "<leader>fp", "<CMD>lua require('telescope').extensions.projects.projects()<CR>", silent)
map("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>", silent)
map("n", "<leader>fr", "<CMD>lua require('telescope.builtin').oldfiles()<CR>", silent)

-- Git
map("n", "<leader>gg", "<CMD>lua _LAZYGIT_TOGGLE()<CR>", silent)
map("n", "<leader>gs", "<CMD>Gitsigns toggle_signs<CR>", silent)

-- Comment
map("n", "<leader>/", "<CMD>lua require('Comment.api').toggle.linewise.current()<CR>", silent)
map("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

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

-- undotree
map("n", "<leader>u", "<CMD>UndotreeToggle<CR>", silent)

-- easier leave term
-- map("t", "<esc>", "<C-\\><C-n>", silent)
map("t", "<C-h>", "<C-\\><C-n><C-W>h", silent)
map("t", "<C-j>", "<C-\\><C-n><C-W>j", silent)
map("t", "<C-k>", "<C-\\><C-n><C-W>k", silent)
map("t", "<C-l>", "<C-\\><C-n><C-W>l", silent)

-- lsp formatter
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", silent)

map("n", "<leader>a", function()
	local marks = require("harpoon").get_mark_config().marks
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    local ct_before = #marks
	require("harpoon.mark").add_file()
    if #marks ~= ct_before then
        vim.api.nvim_echo({{('"%s" successfully marked with index %d'):format(bufname, #marks)}}, false, {})
    end
end, silent)

-- Harpoon
map("n", "<leader>m", function()
	require("harpoon.ui").toggle_quick_menu()
end, silent)

for i = 1, 9 do
	map("n", string.format("<leader>%d", i), function()
		require("harpoon.ui").nav_file(i)
	end, silent)
end

