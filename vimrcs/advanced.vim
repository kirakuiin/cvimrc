" A set of plugins which are useful for programmers
" Last Change: 2018 June 24
" Maintainer: Wang Zhuowei <wang.zhuowei@foxmail.com>
" License:This file is placed in the public domain.

" Common Constant {{{
let s:runtime_path = simplify(g:vimrc_rtp. 'runtime/')
let s:tags_path = simplify(s:runtime_path. 'tagsdir/')
let s:bundle_path = simplify(g:vimrc_rtp. 'bundle/')
let s:vundle_path = simplify(s:bundle_path. 'Vundle.vim/')
" }}} Common Constant

" Utility functions {{{
" Format current file {{{
function! s:FormatTotalFile()
    " Remove ^M charactor
    silent! execute '%s/\r//g'

    " Remove tailing space
    silent! execute '%s/\v\s+$//g'

    " Replace tab with space
    retab
endfunction
" }}} s:FormatTotalFile()

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
" Custom Search command complete {{{
function! s:SearchComplete(A, L, P)
    return [expand('<cword>'), @/, @*]
endfunction
" }}} s:SearchComplete(A, L, P) -> list
" Search pattern for all the files that under cwd(use vim regexp) {{{
function! s:SearchInFiles(pattern)
    let findpath = getcwd(). '/**' " Search files recursively
    silent! execute 'vimgrep! /'. a:pattern. '/j '. findpath
    copen " show result in quickfix
endfunction
" }}} s:SearchInFiles(pattern: str)

" A very simple string hash algorithm {{{
function! s:SimpleHash(str)
    let i = 0
    let result = 1
    while i < len(a:str)
        let result = result*31 + char2nr(a:str[i])
        let i += 1
    endwhile
    return string(result)
endfunction
" }}} s:SimpleHash(str: string) -> string
" Generate tags and save it {{{
function! s:GeneTagsAndSaveit(dir)
    if a:dir ==# ''
        let cwdname = resolve(getcwd())
    else
        let save_cwd = resolve(getcwd())
        silent! execute 'cd '. a:dir
        let cwdname = resolve(getcwd())
        silent! execute 'cd '. save_cwd
    endif

    if exepath('ctags') !=# ''
        let tags_dir = simplify(s:tags_path. s:SimpleHash(cwdname). '/')
        let tags_name = simplify(tags_dir. 'tags')
        silent! execute 'call mkdir("'. tags_dir. '", "p")'
        silent! execute 'AsyncRun ctags --tag-relative=yes -R -o '. tags_name.
                    \' '. cwdname
    endif
endfunction
" }}} s:GeneTagsAndSaveit(dir: string = getcwd())
" Clear all cache content {{{
function! s:DeleteAllCache()
    silent execute 'call delete("'. s:runtime_path. '", "rf")'
endfunction
" }}} s:DeleteAllCache()

" Reset cwd and reload Nerdtree {{{
function! s:ReloadNerd()
    let cur_bufnr = bufnr('%')
    silent! execute ':Cwd'
    silent! execute ':NERDTree'
    silent! execute bufwinnr(cur_bufnr).'wincmd w'
endfunction
" }}} s:ReloadNerd
" Auto close unused Nerd buffer {{{
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
" }}} s:AutoCloseOldNerdBuf
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

" Advanced initialization {{{
if exepath('ctags') !=# ''
    " Auto load ctags file in rumtime path
    execute 'set tags+='. s:tags_path. '**/tags'
endif

augroup advanced_group
    autocmd!
augroup END
" }}} Advanced initialization

" Advanced custom command {{{
" :Search [\v|\C]pattern {Search pattern in current work dir} {{{
if !exists(':Search')
    command -nargs=1 -complete=customlist,<SID>SearchComplete Search
                \ call <SID>SearchInFiles('<args>')
endif
" }}} :Search

" :Cwd {Change pwd to current work dir} {{{
if !exists(':Cwd')
    command -nargs=0 Cwd :execute ':cd '. expand('%:p:h')
endif
" }}} :Cwd

" :GeneTag [dir] {Gene tags in dir, if not gene current dir by default} {{{
if !exists(':GeneTag')
    command -nargs=? -complete=dir GeneTag
                \ call <SID>GeneTagsAndSaveit('<args>')
endif
" }}} :GeneTag
" }}} Advanced custom command

" Advanced key mapping {{{
" Map Impl {{{
nnoremap <silent> <Plug>ReloadNerd :call <SID>ReloadNerd()<CR>
nnoremap <silent> <Plug>DeleteAllCache :call <SID>DeleteAllCache()<CR>
nnoremap <silent> <Plug>FormatTotalFile :call <SID>FormatTotalFile()<CR>
nnoremap <silent> <Plug>CleanUnusedBuffer :call <SID>CleanUnusedBuffer()<CR>
nnoremap <silent> <Plug>IndentGuides :IndentGuidesToggle<CR>
nnoremap <silent> <Plug>VimgrepOperator :set operatorfunc=<SID>VimgrepOperator<CR>g@
vnoremap <silent> <Plug>VimgrepOperator :<c-u>call <SID>VimgrepOperator(visualmode())<CR>
nnoremap <silent> <Plug>ShowNerdTree :NERDTreeToggle<CR>
nnoremap <silent> <Plug>ShowTagBar :Tagbar<CR>
nnoremap <silent> <Plug>ShowQuickFix :call asyncrun#quickfix_toggle(8)<CR>
" }}} Map Impl

" Map Interface {{{
if !exists('g:loaded_cvimrc_advanced_mapping')
    if !hasmapto('<Plug>ReloadNerd')
        map <unique> <Leader>nr <Plug>ReloadNerd
    endif
    if !hasmapto('<Plug>DeleteAllCache')
        map <unique> <Leader>dc <Plug>DeleteAllCache
    endif
    if !hasmapto('<Plug>FormatTotalFile')
        map <unique> <Leader>ft <Plug>FormatTotalFile
    endif
    if !hasmapto('<Plug>CleanUnusedBuffer')
        map <unique> <Leader>bc <Plug>CleanUnusedBuffer
    endif
    if !hasmapto('<Plug>IndentGuides')
        map <unique> <Leader>ig <Plug>IndentGuides
    endif
    if !hasmapto('<Plug>VimgrepOperator')
        map <Leader>g <Plug>VimgrepOperator
        " vmap <Leader>g <Plug>VimgrepOperator
    endif
    if !hasmapto('<Plug>ShowNerdTree')
        map <unique> <F2> <Plug>ShowNerdTree
    endif
    if !hasmapto('<Plug>ShowQuickFix')
        map <unique> <F3> <Plug>ShowQuickFix
    endif
    if !hasmapto('<Plug>ShowTagBar')
        map <unique> <F4> <Plug>ShowTagBar
    endif
    if !hasmapto('<Plug>AirlineSelectTab1')
        map <unique> <Leader>1 <Plug>AirlineSelectTab1
        map <unique> <Leader>2 <Plug>AirlineSelectTab2
        map <unique> <Leader>3 <Plug>AirlineSelectTab3
        map <unique> <Leader>4 <Plug>AirlineSelectTab4
        map <unique> <Leader>5 <Plug>AirlineSelectTab5
        map <unique> <Leader>6 <Plug>AirlineSelectTab6
        map <unique> <Leader>7 <Plug>AirlineSelectTab7
        map <unique> <Leader>8 <Plug>AirlineSelectTab8
        map <unique> <Leader>9 <Plug>AirlineSelectTab9
    endif
    if !hasmapto('<Plug>NERDCommenterComment')
        map <unique> <Leader>c <Plug>NERDCommenterComment
        map <unique> <Leader>cn <Plug>NERDCommenterNested
        map <unique> <Leader>c<space> <Plug>NERDCommenterToggle
        map <unique> <Leader>cm <Plug>NERDCommenterMinimal
        map <unique> <Leader>ci <Plug>NERDCommenterInvert
        map <unique> <Leader>cs <Plug>NERDCommenterSexy
        map <unique> <Leader>c$ <Plug>NERDCommenterToEOL
        map <unique> <Leader>cA <Plug>NERDCommenterAppend
        map <unique> <Leader>ca <Plug>NERDCommenterAltDelims
        map <unique> <Leader>cu <Plug>NERDCommenterUncomment
    endif
    if !hasmapto('<Plug>DashSearch') && has('mac')
        map <unique> <Leader>df <Plug>DashSearch
        map <unique> <Leader>dg <Plug>DashGlobalSearch
    endif
endif
" }}} Map Interface
" }}} Advanced key mapping

" Plugin setting {{{
" Vundle setting {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
execute 'set rtp+='. s:vundle_path
call vundle#begin(s:bundle_path)

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Easy way to manipulate surroundings
Plugin 'tpope/vim-surround'
" Repeat plugin commands
Plugin 'tpope/vim-repeat'
" Plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Vim plugin for intensely orgasmic commenting
Plugin 'scrooloose/nerdcommenter'
" NERD-Tree allow you explore your filesystem and to open or edit them
Plugin 'scrooloose/nerdtree'
" A NERD-Tree plugin for show git status
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Provide an easy way to browse the tags of the current file
Plugin 'majutsushi/tagbar'
" A statusline mamanger
Plugin 'bling/vim-airline'
" Airline themes
Plugin 'vim-airline/vim-airline-themes'
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
" A collection of language packs for Vim
Plugin 'sheerun/vim-polyglot'
" Automatic closing of quotes, parenthesis, brackets, etc
Plugin 'raimondi/delimitmate'
if has('gui_running') && has('python')
    " A code-completion engine for vim
    Plugin 'valloric/youcompleteme'
endif
if has('mac')
    " Dash plugin for mac
    Plugin 'rizzatti/dash.vim'
endif
" Users custom plugins
if exists('g:cvimrc_custom_plugin')
    if filereadable(expand(g:cvimrc_custom_plugin))
        execute 'source '. g:cvimrc_custom_plugin
    endif
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
" }}} Features setting

" Autocmd setting {{{
augroup nerdtree_group
    autocmd!
    "只剩 NERDTree时自动关闭
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")) | q | endif
    "打开新的buffer时自动清除所有旧的nerdbuffer，保留一个最新的
    autocmd bufadd * call <SID>AutoCloseOldNerdBuf()
augroup END
" }}} Autocmd setting
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
" }}} Tagbar setting

" Airline setting {{{
" Features setting {{{
" 开启ale扩展
let g:airline#extensions#ale#enable = 1
" 开启tagbar扩展
let g:airline#extensions#tagbar#enabled = 0
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
" 设置主题
let g:airline_theme='cool'
" }}} Features setting
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
" }}} AsyncRun setting

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
    autocmd!
    " Vim初始化完成后启用插件
    autocmd VimEnter * silent! :RainbowParenthesesActivate
    autocmd Syntax * silent! :RainbowParenthesesLoadRound
    autocmd Syntax * silent! :RainbowParenthesesLoadSquare
    autocmd Syntax * silent! :RainbowParenthesesLoadBraces
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
" }}} Nerdcommenter setting

" Indent guide setting {{{
" Features setting {{{
let g:indent_guides_enable_on_vim_startup = 0
" }}}
" }}} Indent guide setting

" Multiple cursors setting {{{
" Features setting {{{
" Disable default mapping
let g:multi_cursor_use_default_mapping = 0

" Redefine new map
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<C-a>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
" }}}
" }}} Multiple cursors setting

" Ctrlp setting {{{
" Features setting {{{
" Set the format of ctrlp's match window
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
" Use git dir
let g:ctrlp_working_path_mode = 'r'
" Not clear cache
let g:ctrlp_clear_cache_on_exit = 0
" Set cache dir
let g:ctrlp_cache_dir = simplify(s:runtime_path. '.cache')
" Set ctrlp's extension
let g:ctrlp_extensions = ['dir', 'undo']
" Unlimit max files loaded
let g:ctrlp_max_files = 0
" Ignore these files
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v(deps|build|target|cmake|ui|setup|proxy|nginx|keepalived|db-cluster)$',
            \ }
" }}}
" }}} Ctrlp setting

" Delimitmate setting {{{
" Features setting {{{
let delimitMate_quotes="\" '"
let delimitMate_expand_space=1
let delimitMate_jump_expansion=1
let delimitMate_balance_matchpairs=1
let delimitMate_expand_inside_quotes=1
let delimitMate_nesting_quotes=[]
let delimitMate_expand_cr=0
" }}}

" Autocmd setting {{{
augroup delimitmate_group
    autocmd!
    autocmd filetype python let b:delimitMate_nesting_quotes=['"', "'"]
    autocmd filetype cpp let b:delimitMate_expand_cr=1
augroup END
" }}} Autocmd setting
" }}} Delimitmate setting

" YouCompleteMe setting {{{
" Features setting {{{
let g:ycm_python_binary_path = 'python'
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" }}}
" }}} YouCompleteMe setting
" }}} Plugin setting

" vim:et:sts=2:ts=4:sw=4:tw=78:fdm=marker:foldlevel=0:
