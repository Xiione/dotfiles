vim.opt.backup = false                          -- creates a backup file
-- vim.opt.clipboard = "unnamed"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
-- vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
-- vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                         -- always show tabs
-- vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undodir = vim.fn.expand("~/.vim/undodir");
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 50                         -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.laststatus = 3                          -- only the last window will always have a status line
vim.opt.showcmd = true                         -- hide (partial) command in the last line of the screen (for performance)
vim.opt.ruler = false                           -- hide the line and column number of the cursor position
vim.opt.numberwidth = 4                         -- minimal number of columns to use for the line number {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.fillchars.eob=" "                       -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.shortmess:append "c"                    -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.iskeyword:append("-")                   -- treats words with `-` as single words
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- This is a sequence of letters which describes how automatic formatting is to be done
vim.opt.linebreak = true

vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.softtabstop = 4
vim.opt.incsearch = true
vim.opt.colorcolumn = ""
vim.opt.autoindent = true
vim.opt.scroll = 5
vim.opt.mousemoveevent = false

vim.opt.fillchars = {
    horiz = '─',
    horizup = '⠓',
    horizdown = '⡤',
    vert = '▏',
    vertright = '',
    vertleft = '▏',
    verthoriz = '',
    eob = ' '
}

-- no netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- undotree cfg
vim.g["undotree_SplitWidth"] = 40
vim.g["undotree_WindowLayout"] = 3
vim.g["undotree_HelpLine"] = 0
vim.g["Undotree_CustomMap"] = function ()
    vim.cmd("nmap <buffer>l <plug>UndotreeEnter")
end
vim.g["undotree_TreeNodeShape"] = "◍"
vim.g["undotree_TreeReturnShape"] = "╲"
vim.g["undotree_TreeVertShape"] = "▕"
vim.g["undotree_TreeSplitShape"] = "╱"
