-- Shorten function name
local utils = require("user.lib.utils")
local map = utils.map

-- Silent map option
local opts = { silent = true }

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-q>", "<C-w>q", opts)
--
-- Resize with arrows
map("n", "<C-Up>", "<CMD>resize -2<CR>", opts)
map("n", "<C-Down>", "<CMD>resize +2<CR>", opts)
map("n", "<C-Left>", "<CMD>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<CMD>vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<C-S-l>", "<CMD>BufferLineCycleNext<CR>", opts)
map("n", "<C-S-h>", "<CMD>BufferLineCyclePrev<CR>", opts)

-- Close buffers
map("n", "<C-S-w>", "<CMD>Bdelete!<CR>", opts)
map("n", "<leader>bq", "<CMD>BufferLineCloseLeft<CR>", opts)
map("n", "<leader>be", "<CMD>BufferLineCloseRight<CR>", opts)

-- Better paste
map("x", "<leader>p", '"_dP', opts)

map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+Y', opts)

map("n", "<leader>d", '"_d', opts)
map("v", "<leader>d", '"_d', opts)

-- Clear highlights
-- map("n", "<leader>h", "<CMD>nohlsearch<CR>", opts)

-- Insert --
-- Press jk fast to enter
-- map("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
-- map("v", "<", "<gv", opts)
-- map("v", ">", ">gv", opts)

-- Plugins --

-- NvimTree/NeoTree
map("n", "<leader>e", "<CMD>lua require'dapui'.close()<CR>" .. "<CMD>lua require('nvim-tree.api').tree.toggle()<CR>", opts)
-- map("n", "<leader>e", "<CMD>NeoTreeShowToggle<CR>", opts)

-- Telescope
map("n", "<leader>ff", "<CMD>lua require('telescope.builtin').find_files({hidden=true})<CR>", opts)
map("n", "<leader>ft", "<CMD>lua require('telescope.builtin').live_grep()<CR>", opts)
map("n", "<leader>fp", "<CMD>lua require('telescope').extensions.projects.projects()<CR>", opts)
map("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>", opts)
map("n", "<leader>fr", "<CMD>lua require('telescope.builtin').oldfiles()<CR>", opts)

-- Git
map("n", "<leader>gg", "<CMD>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
map("n", "<leader>/", "<CMD>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
map("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
-- map("n", "<leader>db", "<CMD>lua require'dap'.toggle_breakpoint()<CR>", opts)
-- map("n", "<leader>dB", "<CMD>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
-- map("n", "<leader>dc", "<CMD>lua require'dap'.continue()<CR>", opts)
-- map("n", "<leader>di", "<CMD>lua require'dap'.step_into()<CR>", opts)
-- map("n", "<leader>do", "<CMD>lua require'dap'.step_over()<CR>", opts)
-- map("n", "<leader>dO", "<CMD>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<leader>dr", "<CMD>lua require'dap'.repl.toggle()<CR>", opts)
-- map("n", "<leader>dl", "<CMD>lua require'dap'.run_last()<CR>", opts)
-- map("n", "<leader>du", "<CMD>lua require'dapui'.toggle()<CR>" .. "<CMD>NvimTreeClose<CR>", opts)
-- map("n", "<leader>dt", "<CMD>lua require'dap'.terminate()<CR>", opts)
-- map("n", "<leader>dS", function ()
--     utils.toggle_scope_types()
-- end, opts)
--
-- map("n", "<C-d>", "<C-d>", opts)
-- map("n", "<C-u>", "<C-u>", opts)

map("i", "<C-h>", "<Left>", opts)
map("i", "<C-j>", "<Down>", opts)
map("i", "<C-k>", "<Up>", opts)
map("i", "<C-l>", "<Right>", opts)

-- qf navigation
-- map("n", "<C-k>", "<cmd>cprev<CR>zz")
-- map("n", "<C-j>", "<cmd>cnext<CR>zz")
map("n", "<leader>k", "<cmd>cprev<CR>zz")
map("n", "<leader>j", "<cmd>cnext<CR>zz")

-- fixing that stupid typo when trying to [save]exit
vim.cmd([[
    cnoreabbrev <expr> W     ((getcmdtype()  is# ':' && getcmdline() is# 'W')?('w'):('W'))
    cnoreabbrev <expr> Q     ((getcmdtype()  is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
    cnoreabbrev <expr> WQ    ((getcmdtype()  is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
    cnoreabbrev <expr> Wq    ((getcmdtype()  is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
    cnoreabbrev <expr> Qa    ((getcmdtype()  is# ':' && getcmdline() is# 'Qa')?('qa'):('Qa'))
    cnoreabbrev <expr> QA    ((getcmdtype()  is# ':' && getcmdline() is# 'QA')?('qa'):('QA'))
]])

-- theprimeagen replace thingie
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- undotree
map("n", "<leader>u", "<CMD>UndotreeToggle<CR>", opts)

-- easier leave term
map("t", "<esc>", "<C-\\><C-n>", opts)
map("t", "<C-h>", "<C-\\><C-n><C-W>h", opts)
map("t", "<C-j>", "<C-\\><C-n><C-W>j", opts)
map("t", "<C-k>", "<C-\\><C-n><C-W>k", opts)
map("t", "<C-l>", "<C-\\><C-n><C-W>l", opts)

-- works better here? idk
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)


-- vimtex 
map("n", "<leader>ti", "<plug>(vimtex-info)", opts)
map("n", "<leader>tI", "<plug>(vimtex-info-full)", opts)
map("n", "<leader>tt", "<plug>(vimtex-toc-open)", opts)
map("n", "<leader>tT", "<plug>(vimtex-toc-toggle)", opts)
map("n", "<leader>tv", "<plug>(vimtex-view)", opts)
map("n", "<leader>tr", "<plug>(vimtex-reverse-search)", opts)
map("n", "<leader>tb", "<plug>(vimtex-compile)", opts)
map("n", "<leader>tk", "<plug>(vimtex-stop", opts)
map("n", "<leader>tK", "<plug>(vimtex-stop-all)", opts)
map("n", "<leader>te", "<plug>(vimtex-errors)", opts)
map("n", "<leader>to", "<plug>(vimtex-compile-output)", opts)
map("n", "<leader>tg", "<plug>(vimtex-status)", opts)
map("n", "<leader>tG", "<plug>(vimtex-status-all)", opts)
map("n", "<leader>tc", "<plug>(vimtex-clean)", opts)
map("n", "<leader>tC", "<plug>(vimtex-clean-full)", opts)
map("n", "<leader>tm", "<plug>(vimtex-imaps-list)", opts)
map("n", "<leader>tx", "<plug>(vimtex-reload)", opts)
map("n", "<leader>ts", "<plug>(vimtex-toggle-main)", opts)
