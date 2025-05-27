" VSCode Vim Configuration
" Basic Settings
set nobackup
set cmdheight=1
set encoding=utf-8
set mouse=a
set noshowmode
set smartindent
set noswapfile
set undofile
set expandtab
set shiftwidth=4
set tabstop=4
set number
set relativenumber
set noerrorbells
set incsearch
set nohlsearch
set hidden
set autoindent
set ignorecase
set smartcase
set scrolloff=8
set sidescrolloff=16
set nowrap
set iskeyword+=-

" Leader key
let mapleader = " "

" Clipboard settings
" Uncomment the following line to use system clipboard
" set clipboard=unnamed

" Search settings
set ignorecase
set smartcase
set incsearch
set nohlsearch

" Visual settings
set cursorline
set number
set relativenumber
set signcolumn=yes

" Performance
set updatetime=50
set timeoutlen=500

" Indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Insert and Command mode adjustments
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" Keymaps
" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Select all
nnoremap <M-a> ggVG

" Better pasting
xnoremap <leader>p "_dP

" System clipboard integration
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Stay in indent mode
vnoremap < <gv
vnoremap > >gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Quick fix navigation
nnoremap <leader>k :cprev<CR>zz
nnoremap <leader>j :cnext<CR>zz
nnoremap <leader>q :cclose<CR>

" Search and replace current word
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Search and replace visual selection
vnoremap <leader>s "hy:%s/<C-r>h//gc<Left><Left><Left>

" Fix common typos in command mode
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev Qa qa
cnoreabbrev QA qa

" VSCode-specific settings
" These should be configured in VSCode's settings.json instead:
" - vim.easymotion
" - vim.sneak
" - vim.surround
" - vim.highlightedyank
" - vim.camelCaseMotion
" - vim.useSystemClipboard
" - vim.handleKeys
" - vim.statusBarColorControl 