"while open scheme file. loading follwoing map and func etc
"特性设置{{{1
"setlocal tabstop=2
"setlocal shiftwidth=2
"setlocal softtabstop=2
"}}}
"映射绑定{{{1
nnoremap<buffer> <localleader>c I;;<esc>
nnoremap<buffer> <F5> :AsyncRun raco test %<CR>
inoremap<buffer> <CR> <CR><TAB>
nnoremap<buffer> o o<TAB>
"}}}
