"Vundle插件列表{{{1
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin('$HOME/.vimfiles/bundle')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" NERD-Tree allow you explore your filesystem and to open or edit them
Plugin 'The-NERD-tree'
" Provide an easy way to browse the tags of the current file
Plugin 'majutsushi/tagbar'
" A statusline mamanger
Plugin 'bling/vim-airline'
" Color scheme
Plugin 'molokai'
" Async run shell command
Plugin 'skywind3000/asyncrun.vim'

if has('mac')
" Dash plugin for mac
Plugin 'rizzatti/dash.vim'
endif

call vundle#end()            " required
filetype plugin indent on    " required
"}}}
"NERD-Tree设置 {{{1
"特性设置 {{{2
"显示增强
let NERDChristmasTree=1
"自动调整焦点
let NERDTreeAutoCenter=1
"鼠标模式:目录单击,文件双击
let NERDTreeMouseMode=2
"打开文件后自动关闭
let NERDTreeQuitOnOpen=0
"显示文件
let NERDTreeShowFiles=1
"显示隐藏文件
let NERDTreeShowHidden=1
"高亮显示当前文件或目录
let NERDTreeHightCursorline=1
"显示行号
let NERDTreeShowLineNumbers=1
"窗口位置
let NERDTreeWinPos='left'
"窗口宽度
if has('win32')
    let NERDTreeWinSize=38
else
    let NERDTreeWinSize=25
endif
"不显示'Bookmarks' label 'Press ? for help'
let NERDTreeMinimalUI=1
"显示书签
let NERDTreeShowBookmarks=1
"设置忽略文件
if has('mac')
    let NERDTreeIgnore=['\.DS_Store$[[file]]']
endif
" 设置当文件被改动时自动载入
set autoread
"}}}
"映射绑定 {{{2
nnoremap <silent> <F2> :NERDTreeToggle<CR>
"}}}
"自动加载 {{{2
augroup nerdtree_group
    "清除组命令
    au!
    "只剩 NERDTree时自动关闭
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    "打开新的buffer时自动清除所有旧的nerdbuffer，保留一个最新的
    autocmd bufadd * call <SID>AutoCloseOldNerdBuf()
augroup END
"}}}
"函数定义{{{2
function! s:AutoCloseOldNerdBuf()
    let isNew = v:true

    let last = bufnr('$')
    while last >= 1
        let curBufName = bufname(last)

        if (curBufName =~? "NERD*") && isNew
            let isNew = v:false
        elseif curBufName =~? "NERD*"
            silent! execute 'bw ' . curBufName
        endif

        let last = last - 1
    endwhile
endfunction
"}}}
"}}}
"tagbar设置{{{1
"特性设置{{{2
"ctags 程序路径
let g:tagbar_ctags_bin='ctags'
"窗口宽度
if has('win32')
    let g:tagbar_width=30
else
    let g:tagbar_width=25
endif
"自动聚焦
let g:tagbar_autofocus=1
"自动关闭
let g:tagbar_autoclose=1
"}}}
"映射绑定{{{2
nnoremap <F4> :Tagbar<cr>
"}}}
"自动加载{{{2
augroup tagbar_group
    au!
    autocmd BufNewFile,BufReadPost lvimrc.txt let b:tagbar_ignore = 1
augroup END
"}}}
"}}}
"molokai设置{{{1
"特性设置{{{2
"设置颜色策略所在路径
set rtp+=~/vimfiles/bundle/molokai
"设置颜色模式
colorscheme molokai
"}}}
"}}}
"airline设置{{{1
"特性设置{{{2
"开启syntastic整合
""let g:airline#extensions#syntastic#enabled = 1
"开启tagbar整合
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#tagbar#flags = 's'
let g:airline#extensions#tagbar#flags = 'p'
"开启bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
"}}}
"映射绑定{{{2
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
"}}}
"函数定义{{{2
function! s:AutoCloseOldNerdBuf()
    let isNew = v:true

    let last = bufnr('$')
    while last >= 1
        let curBufName = bufname(last)

        if (curBufName =~? "NERD*") && isNew
            let isNew = v:false
        elseif curBufName =~? "NERD*"
            silent! execute 'bw ' . curBufName
        endif

        let last = last - 1
    endwhile
endfunction
"}}}
"}}}
"AsyncRun设置{{{1
"映射绑定{{{2
nnoremap <F3> :call asyncrun#quickfix_toggle(8)<cr>
"}}}
"}}}
"Dash设置{{{1
"映射绑定{{{2
"映射dash only for macos
if has('mac')
    nnoremap <leader>d :Dash<cr>
endif
"}}}
"}}}
