"特性设置{{{1
setlocal fdm=marker
setlocal foldlevel=0
"}}}
"映射绑定{{{1
"自动补全各种符号
inoremap <buffer>( ()<Left>
inoremap <buffer>" ""<Left>
inoremap <buffer>' ''<Left>
inoremap <buffer>[ []<Left>
inoremap <buffer>{ {}<Left>

"添加单行注释
nnoremap <buffer><localleader>c I"<esc>

"执行文件
nnoremap <buffer><F6> :w<cr>:source %<cr>
"}}}
