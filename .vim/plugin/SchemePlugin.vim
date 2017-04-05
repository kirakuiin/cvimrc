"while open scheme file. loading follwoing map and func etc

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap<buffer> <localleader>c I;;<esc>
nnoremap<buffer> <F5> :AsyncRun raco test %<CR>
inoremap<buffer> <CR> <CR><TAB>
nnoremap<buffer> o o<TAB>
