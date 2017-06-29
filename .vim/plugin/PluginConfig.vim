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
" 设置当文件被改动时自动载入
set autoread
"}}}
"映射绑定 {{{2
nnoremap <silent> <F2> :NERDTreeToggle<CR>
"}}}
"自动加载 {{{2
"只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
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
"当时c或者cpp文件时自动打开
"autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
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
"Syntastic设置{{{1
"特性设置{{{2
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"
"let g:syntastic_mode_map = {
"    \ "mode": "active",
"    \ "active_filetypes": ['cpp'],
"    \ "passive_filetypes": ['cpp'] }
"
"
"if exists('$CPPCHECK') && has('win32')
"    let g:syntastic_cpp_cppcheck_exec = expand('$CPPCHECK') . '\cppcheck.exe'
"    let g:syntastic_cpp_checkers = ['cppcheck']
"endif
"}}}
"映射绑定{{{2
"nnoremap <F6> :SyntasticCheck<cr>
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
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
"}}}
"映射绑定{{{2
nnoremap <PageUp> :bp<cr>
nnoremap <PageDown> :bn<cr>
"}}}
"}}}
