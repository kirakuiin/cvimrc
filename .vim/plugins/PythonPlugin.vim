"while python file open. loading following map and func
"映射绑定{{{1
"自动补全各种符号
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap [ []<Left>
inoremap { {}<Left>

"添加单行注释
nnoremap <buffer><localleader>c I#<esc>

"添加块注释
vnoremap <buffer><localleader>* <esc>`<i"""<esc>`>a"""<esc>

"执行文件
nnoremap <buffer><F5> :w<cr>:AsyncRun python %<cr>
"}}}
