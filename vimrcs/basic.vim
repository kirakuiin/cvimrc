" A set of basic configuration about vim
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
set background=light

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

    " Set background and font color
    highlight Normal guibg=White guifg=Black
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

" Tabs, windows, statusline {{{
" Always show the status line
set laststatus=2

" Format the status line
set statusline=%<%f%h%m%r%y%=%b\ 0x%B\ \ %l/%L,%c\ %P
" }}} Fold, tabs, windows, statusline
" }}} Features setting

" Basic initialization {{{
augroup basic_initialization
    au!
    if has('win32') && has('gui_running')
        " Full screen when open vim
        autocmd GUIEnter * simalt ~x
    endif
augroup END
" }}} Basic initialization

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
nnoremap <left> :bprevious<CR>
nnoremap <right> :bnext<CR>

" Quickfix move shortcut
nnoremap <up> :cprevious<CR>
nnoremap <down> :cnext<CR>

" Open .vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" Source .vimrc file
nnoremap <leader>sv :source $MYVIMRC<CR>

" Search the string that save in the @* register
nnoremap <leader>/ :execute "normal! /\\v" . expand(@*). "\r"<CR>

" Stop highlighting for search result
nnoremap <leader>nh :nohlsearch<CR>

" Set shortcut for switch window
nnoremap <leader><leader> <c-w>

" Hex editing
nnoremap <leader>he :%!xxd<CR>

" Quit hex editing
nnoremap <leader>hr :%!xxd -r<CR>

" Format the total file
nnoremap <leader>s :call <SID>FormatTotalFile()<CR>

" Clean the buffer that is not nerd and current buffer
nnoremap <leader>bc :call <SID>CleanUnusedBuffer()<CR>

" Shortcut for search string
nnoremap <leader>g :set operatorfunc=<SID>VimgrepOperator<CR>g@
vnoremap <leader>g :<c-u>call <SID>VimgrepOperator(visualmode())<CR>
" }}} Basic key mapping

" Basic custom command {{{
" Change pwd to current work dir
command! -nargs=0 Cwd :execute ':cd '. expand('%:p:h')

" Search pattern in current work dir
command! -nargs=1 -complete=customlist,<SID>SearchComplete Search
            \ call <SID>SearchInFiles('<args>')
" }}} Basic custom command

" Utility functions {{{
" Search pattern for all the files that under cwd(use vim regexp) {{{
function! s:SearchInFiles(pattern)
    let findpath = getcwd(). '/**' " Search files recursively
    silent! execute 'vimgrep! /'. a:pattern. '/j '. findpath
    copen " show result in quickfix
endfunction
" }}} s:SearchInFiles

" Search command complete func {{{
function! s:SearchComplete(A, L, P)
    return ['\v', '\C', '\v\C']
endfunction
" }}} s:SearchComplete

" Custom grep {{{
function! s:VimgrepOperator(type)
    let saved_unnamed_register = @"

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let pattern = shellescape(@")[1:-2]
    call <SID>SearchInFiles(pattern)

    copen " show result in quickfix
    let @" = saved_unnamed_register
endfunction
" }}} s:VimgrepOperator

" Format current file {{{
function! s:FormatTotalFile()
    "消除^M字符
    silent! execute '%s/\r//g'

    "清除末尾空格符
    silent! execute '%s/\v\s+$//g'

    "tab替换为空格符
    retab
endfunction
" }}} s:FormatTotalFile

" Clear all buffer execpt nerdtree and current {{{
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
" }}} s:CleanUnusedBuffer
" }}} Utility functions
" vim: set et sts=2 ts=4 sw=4 tw=78 fdm=marker foldlevel=0:
