" A generic set of VIM plugin for programmers
" Last Change: 2018 June 15
" Maintainer: Wang Zhuowei <wang.zhuowei@foxmail.com>

" Features setting {{{
" VIM normal config {{{
" Activate extension of VIM
set nocompatible

" Sets how many lines of history VIM has to remember
set history=100

" Display line number
set number

" Highlight the line where the cursor is
set cursorline

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Turn on the Wild menu
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has('win32')
    set wildignore+=.git\*,.svn\*,.hg\\*
else
    set wildignore+=*/.git/*,*/.svn/*,*/.DS_Store
endif

" Configure backspace so it acts as it should act
set backspace=indent,eol,start

" Indicate keys that can move to the previous/next line by left/right
set whichwrap+=<,>,[,]

" For regular expressions turn magic on
set magic

" Ignore case when searching
set ignorecase
" Highlight search results
set hlsearch
" Make search act like search in modern browsers
set incsearch

" Set 7 lines to the cursor when moving vertically using j/k
set scrolloff=7

" Avoid garbled charaters in Chinese language windows OS
set langmenu=en

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=5     " This means 0.5s

" No annoying sound on errors
set noerrorbells
set novisualbell
set timeoutlen=500

" Bind unamed register to clipboard
set clipboard=unnamed

" Set runtime path for VIM
if has('osx')
    set rtp+=~/.vim
    silent execute '!rm -f ._'. expand('%:t')
elseif has('win32')
    set rtp+=~\.vim
else
    set rtp+=~/.vim
endif
" }}} VIM normal config

" Color and fonts {{{
" Enable syntax highlighting
syntax enable

" Set background color
set background=dark

" Set extra options when running in GUI mode
if has('gui_running')
    " Add a bit extra margin to the left
    set foldcolumn=1
    " Enable fold
    set foldenable
    " Set syntax fold
    set foldmethod=manual
    " Maximum the fold level
    set foldlevel=1
    " Automatic fold
    set foldclose=all

    " Don't show graphical user interface
    set guioptions=

    " Set fond style and size
    if has('osx')
        set guifont=Monaco:h18
    elseif has('win32')
        set guifont=consolas:h14
    endif
endif

" Set utf-8 as standard encoding and en_US as standard language
set encoding=utf-8
" Use the first codec as fileencoding, if error is detect, use next one.
set fileencodings=utf-8,ucs-bom,cp936
" Use Unix as the standard file type
set fileformats=unix,dos,mac
" }}} Color and fonts

" Backup and undo {{{
" Turn backup off, since most stuff in CVS
set nobackup
set nowritebackup
set noswapfile
set noundofile
set backupcopy=yes
" }}} Backup and undo

" Text, tab and indent relate {{{
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 120 characters
set linebreak
set textwidth=120

" Auto indent
set autoindent
" Smart indent
set smartindent
" Wrap lines
set nowrap

" Highlight the column that is at column 100
set colorcolumn=80
" }}} Text, tab and indent relate

" Tabs, windows, statusline {{{2
" Always show the status line
set laststatus=2

" Format the status line
set statusline=%<%f%h%m%r%y%=%b\ 0x%B\ \ %l/%L,%c\ %P
" }}} Fold, tabs, windows, statusline
" }}} Features setting

" Basic key mapping {{{
" Set leader key to comma
let mapleader = ','

" Set localleader key to back-slash
let maplocalleader = '\'

"Search in very magic mode
nnoremap / /\v
nnoremap ? ?\v

" Replace esc with jk in insert mode
inoremap jk <esc>

" Buffer switch shortcut
nnoremap <left> :bprevious<cr>
nnoremap <right> :bnext<cr>

" Quickfix move shortcut
nnoremap <up> :cprevious<cr>
nnoremap <down> :cnext<cr>

" Open .vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source .vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>

" Search the string that save in the @* register
nnoremap <leader>/ :execute "normal! /\\v" . expand(@*). "\r"<cr>

" Stop highlighting for search result
nnoremap <leader>nh :nohlsearch<cr>

" Set shortcut for switch window
nnoremap <leader><leader> <c-w>

" Hex editing
nnoremap <leader>he :%!xxd<cr>

" Quit hex editing
nnoremap <leader>hr :%!xxd -r<cr>

" Format the total file
nnoremap <leader>s :call <SID>FormatTotalFile()<cr>

" Clean the buffer that is not nerd and current buffer
nnoremap <leader>bc :call <SID>CleanUnusedBuffer()<cr>

" Shortcut for search string
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>
" }}} Basic key mapping

" Utility functions {{{
function! s:GrepOperator(type)
    let saved_unnamed_register = @"

    if has('win32')
        let l:slash = "\\"
    else
        let l:slash = "\/"
    endif

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let findpath = getcwd()

    if (has("win32"))
        silent execute "grep! /S " . shellescape(@") . " " . findpath . l:slash . "*"
    else
        silent execute "grep! -R " . shellescape(@") . " " . findpath . l:slash . "*"
    endif

    copen

    let @" = saved_unnamed_register
endfunction

function! s:FormatTotalFile()
    "消除^M字符
    silent! execute '%s/\r//g'

    "清除末尾空格符
    silent! execute '%s/\v\s+$//g'

    "tab替换为空格符
    retab!
endfunction

function! s:CleanUnusedBuffer()
    let current_number = bufnr('%')
    let last_number = bufnr('$')
    let nerd_number = bufnr('NERD*')
    let i = 1

    while i <= last_number
        if (i != current_number) && (i != nerd_number)
            silent! execute 'bw ' . string(i)
        endif
        let i = i + 1
    endwhile
endfunction
" }}} Utility functions

" source $HOME/.vim/plugins/PluginConfig.vim
" vim: set expandtab sts=2 ts=4 sw=4 tw=78 fdm=marker foldlevel=0:
