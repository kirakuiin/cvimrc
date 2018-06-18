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

    " Set background and font color
    highlight Normal guibg=Black guifg=White
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
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<CR>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<CR>
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
    retab
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

" Plugin config {{{
" Only activate in gui mode
if !has('gui_running')
    finish
endif

" Vundle setting {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vimfiles/bundle')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Easy way to manipulate surroundings
Plugin 'tpope/vim-surround'
" Repeat plugin commands
Plugin 'tpope/vim-repeat'
" Plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" NERD-Tree allow you explore your filesystem and to open or edit them
Plugin 'scrooloose/nerdtree'
" Vim plugin for intensely orgasmic commenting
Plugin 'scrooloose/nerdcommenter'
" Provide an easy way to browse the tags of the current file
Plugin 'majutsushi/tagbar'
" A statusline mamanger
Plugin 'bling/vim-airline'
" Async run shell command
Plugin 'skywind3000/asyncrun.vim'
" Rainbow parenthesss
Plugin 'kien/rainbow_parentheses.vim'
" A Lint engine
Plugin 'w0rp/ale'
" Color scheme solarized
Plugin 'altercation/vim-colors-solarized'
" Visually indent
Plugin 'nathanaelkane/vim-indent-guides'
" New indent object
Plugin 'michaeljsmith/vim-indent-object'
" Multiple selection for vim
Plugin 'terryma/vim-multiple-cursors'

if has('osx')
    " Dash plugin for mac
    Plugin 'rizzatti/dash.vim'
endif

call vundle#end()            " required
filetype plugin indent on    " required
" }}} Vundle setting

" NERD-Tree setting {{{
" Features setting {{{
" 显示增强
let NERDChristmasTree=1
" 自动调整焦点
let NERDTreeAutoCenter=1
" 鼠标模式:目录单击,文件双击
let NERDTreeMouseMode=2
" 打开文件后自动关闭
let NERDTreeQuitOnOpen=0
" 显示文件
let NERDTreeShowFiles=1
" 显示隐藏文件
let NERDTreeShowHidden=1
" 高亮显示当前文件或目录
let NERDTreeHightCursorline=1
" 显示行号
let NERDTreeShowLineNumbers=1
" 窗口位置
let NERDTreeWinPos='left'
" 窗口宽度
if has('win32')
    let NERDTreeWinSize=38
else
    let NERDTreeWinSize=25
endif
" 不显示'Bookmarks' label 'Press ? for help'
let NERDTreeMinimalUI=1
" 显示书签
let NERDTreeShowBookmarks=1
" 设置忽略文件
if has('mac')
    let NERDTreeIgnore=['\.DS_Store$[[file]]']
endif
" 设置当文件被改动时自动载入
set autoread
" }}} Features setting

" Mapping setting {{{
" 打开或关闭目录树
nnoremap <silent> <F2> :NERDTreeToggle<CR>
" }}} Mapping setting

" Autocmd setting {{{
augroup nerdtree_group
    au!
    "只剩 NERDTree时自动关闭
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    "打开新的buffer时自动清除所有旧的nerdbuffer，保留一个最新的
    autocmd bufadd * call <SID>AutoCloseOldNerdBuf()
augroup END
" }}} Autocmd setting

" Utility functions {{{
" 自动关闭未使用的NERD buffer
function! s:AutoCloseOldNerdBuf()
    let isNew = 1

    let last = bufnr('$')
    while last >= 1
        let curBufName = bufname(last)

        if (curBufName =~? "NERD_tree_*") && isNew
            let isNew = 0
        elseif curBufName =~? "NERD_tree_*"
            silent! execute 'bw ' . curBufName
        endif

        let last = last - 1
    endwhile
endfunction
" }}} Utility functions
" }}} NERD-Tree setting

" Tagbar setting {{{
" Features setting {{{
" ctags 程序路径
let g:tagbar_ctags_bin='ctags'
" 窗口宽度
if has('win32')
    let g:tagbar_width=30
else
    let g:tagbar_width=25
endif
" 自动聚焦
let g:tagbar_autofocus=1
" 自动关闭
let g:tagbar_autoclose=1
" }}} Features setting

" Mapping setting {{{
nnoremap <F4> :Tagbar<CR>
" }}} Mapping setting

" Autocmd setting {{{
augroup tagbar_group
    au!
    autocmd BufNewFile,BufReadPost lvimrc.txt let b:tagbar_ignore = 1
augroup END
" }}} Autocmd setting
" }}} Tagbar setting

" Airline setting {{{
" Features setting {{{
" 开启ale扩展
let g:airline#extensions#ale#enable = 1
" 开启tagbar扩展
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#tagbar#flags = 's'
let g:airline#extensions#tagbar#flags = 'p'
" 开启bufferline扩展
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
" 开启virtualenv扩展
let g:airline#extensions#virtualenv#enabled = 1
" }}} Features setting

" Mapping setting {{{
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
" }}} Mapping setting
" }}} Airline setting

" AsyncRun setting {{{
" Features setting {{{
if has('win32')
    let g:asyncrun_encs = 'cp936'
elseif has('mac')
    let g:asyncrun_encs = 'utf-8'
else
    let g:asyncrun_encs = 'utf-8'
endif
" }}} Features setting

" Mapping setting {{{
nnoremap <F3> :call asyncrun#quickfix_toggle(8)<CR>
" }}} Mapping setting
" }}} AsyncRun setting

" Dash setting {{{
" Mapping setting {{{
" 映射dash only for macos
if has('mac')
    nnoremap <leader>d :Dash<CR>
endif
" }}} Mapping setting
" }}} Dash setting

" Raindow parentheses setting {{{
" Features setting {{{
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" }}} Features setting
" }}} Raindow parentheses setting

" Ale setting {{{
" Features setting {{{
" 仅当保存文件时启用linter
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" 始终启用符号栏
"let g:ale_sign_column_always = 1

" 关闭loclist
let g:ale_set_loclist = 0

" 开启quickfix
let g:ale_set_quickfix = 1

" 设置ale错误标识
let g:ale_sign_error = 'e'

" 设置ale警报标识
let g:ale_sign_warning = 'w'

" 语言使用插件设置
let g:ale_linters = {
    \'cpp': ['cpplint'],
    \'python': ['pylint'],
    \}

" cpplint设置
let g:ale_cpp_cpplint_executable = expand('~'). '/.vim/pyscript/cpplint.py'
let g:ale_cpp_cpplint_options = '--verbose=5 --filter=-build/header_guard'

" pylint设置
let g:ale_python_pylint_executable = expand('~'). '/.vim/pyscript/pylint'
let g:ale_python_pylint_options = '--rcfile '. expand('~'). '/.pylintrc'
" The virtualenv detection needs to be disabled.
let g:ale_python_pylint_use_global = 1
" }}} Features setting
" }}} Ale setting

" Solarized setting {{{
" Features setting {{{
" 设置颜色模式
if has('gui_running')
    set background=light
else
    set background=dark
endif
colorscheme solarized

" 关闭菜单
let g:solarized_menu=0
" }}} Features setting
" }}} Solarized setting

" Nerdcommenter setting {{{
" Features setting {{{
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Disable default mapping
let g:NERDCreateDefaultMappings = 0
" }}} Features setting

" Mapping setting {{{
" Comment out the current line or text selected in visual mode.
map <localleader>c <plug>NERDCommenterComment
" Same as cc but forces nesting.
map <localleader>cn <plug>NERDCommenterNested
" Toggles the comment state of the selected line(s).
map <localleader>c<space> <plug>NERDCommenterToggle
" Comments the given lines using only one set of multipart delimiters.
map <localleader>cm <plug>NERDCommenterMinimal
" Toggles the comment state of the selected line(s) individually.
map <localleader>ci <plug>NERDCommenterInvert
" Comments out the selected lines with a pretty block formatted layout.
map <localleader>cs <plug>NERDCommenterSexy
" Comments the current line from the cursor to the end of line.
map <localleader>c$ <plug>NERDCommenterToEOL
" Adds comment delimiters to the end of line
map <localleader>cA <plug>NERDCommenterAppend
" Switches to the alternative set of delimiters.
map <localleader>ca <plug>NERDCommenterAltDelims
" Uncomments the selected line(s).
map <localleader>cu <plug>NERDCommenterUncomment
" }}} Mapping setting
" }}} Nerdcommenter setting

" Indent guide setting {{{
" Features setting {{{
let g:indent_guides_enable_on_vim_startup = 0
" }}}

" Mapping setting {{{
map <leader>ig :IndentGuidesToggle<CR>
" }}} Mapping setting
" }}} Indent guide setting

" Multiple cursors {{{
" Features setting {{{
" Disable default mapping
let g:multi_cursor_use_default_mapping = 0
" }}}

" Mapping setting {{{
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<C-a>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
" }}} Mapping setting
" }}} Multiple cursors
" }}} Plugin config
" vim: set et sts=2 ts=4 sw=4 tw=78 fdm=marker foldlevel=0:
