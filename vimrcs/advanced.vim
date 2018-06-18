" A set of plugins which are useful for programmers
" Last Change: 2018 June 15
" Maintainer: Wang Zhuowei <wang.zhuowei@foxmail.com>

" Plugin guard {{{
" Only activate when in gui mode
if !has('gui_running')
    finish
endif
" }}} Plugin guard

" Vundle setting {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
execute 'set rtp+='. g:vundle_rtp
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
" A fuzzy file search engine
Plugin 'ctrlpvim/ctrlp.vim'
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
" }}} Features setting

" Autocmd setting {{{
augroup rainbow_parentheses_group
    au!
    if exists(':RainbowParenthesesToggle')
        " Vim初始化完成后启用插件
        autocmd VimEnter * RainbowParenthesesToggle
        autocmd Syntax * RainbowParenthesesLoadRound
        autocmd Syntax * RainbowParenthesesLoadSquare
        autocmd Syntax * RainbowParenthesesLoadBraces
    endif
augroup END
" }}} Autocmd setting
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
let g:ale_cpp_cpplint_executable = 'cpplint.py'
let g:ale_cpp_cpplint_options = '--verbose=5 --filter=-build/header_guard'

" pylint设置
let g:ale_python_pylint_executable = 'pylint'
let g:ale_python_pylint_options = '--rcfile '. expand('~'). '/.pylintrc'
" The virtualenv detection needs to be disabled.
let g:ale_python_pylint_use_global = 1
" }}} Features setting
" }}} Ale setting

" Solarized setting {{{
" Features setting {{{
" 设置背景颜色
if has('gui_running')
    set background=light
else
    set background=dark
endif

" 设置颜色模式
try
    colorscheme solarized
catch
endtry

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

" Multiple cursors setting {{{
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
" }}} Multiple cursors setting

" Ctrlp setting {{{
" Features setting {{{
" Set the format of ctrlp's match window
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
" Use pwd
let g:ctrlp_working_path_mode = 'wr'
" }}}
" }}} Ctrlp setting
" vim: set et sts=2 ts=4 sw=4 tw=78 fdm=marker foldlevel=0:
