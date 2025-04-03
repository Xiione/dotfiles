local colors = require("user.cfg.colors")

vim.opt.backup = false -- creates a backup file
-- vim.opt.clipboard = "unnamed"                -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
-- vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
-- vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.pumheight = 5 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0 -- always show tabs
-- vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 50 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.cursorlineopt = "both"
vim.opt.number = true -- set numbered lines
vim.opt.laststatus = 3 -- only the last window will always have a status line
vim.opt.statusline = "" -- barbecue and lualine take care of statusline
vim.opt.showcmd = true -- hide (partial) command in the last line of the screen (for performance)
vim.opt.ruler = false -- hide the line and column number of the cursor position
vim.opt.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.mousescroll = { "ver:1", "hor:3" }
vim.opt.sidescrolloff = 16 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.iskeyword:append("-") -- treats words with `-` as single words
-- vim.opt.formatoptions:remove("c")            -- Moved to aucmds
-- vim.opt.formatoptions:remove("r")
-- vim.opt.formatoptions:remove("o")
vim.opt.linebreak = true
vim.opt.guicursor = "v-r-cr:hor15,i:ver20,a:blinkwait100-blinkoff700-blinkon700" -- Underscore visual select cursor

vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.softtabstop = 4
vim.opt.incsearch = true
vim.opt.colorcolumn = ""
vim.opt.autoindent = true
vim.opt.mousemoveevent = false
vim.opt.sessionoptions = "buffers,curdir,folds,help,winsize,terminal"

-- ufo
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.winblend = 5
vim.opt.winborder = "solid"
vim.opt.pumblend = 5

-- vim.opt.fillchars = {
--     horiz = '─',
--     horizup = '─',
--     horizdown = '─',
--     vert = '▏',
--     vertright = '',
--     vertleft = '▏',
--     verthoriz = '',
--     eob = ' '
-- }

vim.opt.fillchars = {
	-- horiz = '▄',
	horiz = "█",
	horizup = "█",
	horizdown = "█",
	vert = "█",
	vertright = "█",
	vertleft = "█",
	verthoriz = "█",
	eob = " ",
	fold = " ",
	foldopen = "",
	foldsep = " ",
	foldclose = "",
}

-- h as c
vim.g.c_syntax_for_h = 1

-- no netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- undotree cfg
vim.g["undotree_SplitWidth"] = 40
vim.g["undotree_WindowLayout"] = 3
vim.g["undotree_HelpLine"] = 0
vim.g["Undotree_CustomMap"] = function()
	vim.cmd("nmap <buffer>l <plug>UndotreeEnter")
end

vim.g["undotree_TreeNodeShape"] = "◍"
vim.g["undotree_TreeReturnShape"] = "╲"
vim.g["undotree_TreeVertShape"] = "▕"
vim.g["undotree_TreeSplitShape"] = "╱"

-- Some annoying plugin messages, they seem to work fine regardless
local ignore_messages = {
	-- lsp issue?
	"warning: multiple different client offset_encodings",
	-- dap messages
	"Debug adapter reported a frame at line",
	"Resolved locations:",
	"No configuration found for",
}
local notify = vim.notify
vim.notify = function(msg, ...)
	for _, value in ipairs(ignore_messages) do
		if msg:match(value) then
			return
		end
	end

	notify(msg, ...)
end

local command = vim.api.nvim_create_user_command
command("OP", "silent !open .", {})
command("Hitest", function()
	vim.cmd("silent so " .. vim.fn.expand("$VIMRUNTIME/syntax/hitest.vim"))
end, {})

-- replaces impatient.nvim
vim.loader.enable()

-- neogurt
if vim.g.neogurt then
	vim.g.neogurt_opts = {
		window = {
			vsync = true,
			high_dpi = true,
			borderless = true,
			blur = 20,
		},
		margins = {
			top = 0,
			bottom = 0,
			left = 0,
			right = 0,
		},
		multigrid = true,
		macos_option_is_meta = "both",
		cursor_idle_time = 10,
		scroll_speed = 1,

		bg_color = tonumber(colors.nord17:sub(2), 16),
		opacity = 1.00,
		max_fps = 60,
	}
end

-- filetypes
vim.filetype.add({
	extension = {
		vert = "glsl",
		frag = "glsl",
	},
})

vim.opt.guifont = "Meslo LG S,PingFang TC,MesloLGS Nerd Font,Apple Color Emoji:h12" -- the font used in graphical neovim applications
