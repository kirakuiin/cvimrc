"while idl file open. loading following map and func
"映射绑定{{{1
"自动补全各种符号
inoremap <buffer>( ()<Left>
inoremap <buffer>" ""<Left>
inoremap <buffer>' ''<Left>
inoremap <buffer>[ []<Left>
inoremap <buffer>{ {}<Left><CR><CR><Up><Tab>

"添加文件框架
nnoremap <buffer><localleader>mf :call IdlPlugin#MakeHeaderFrame()<cr>
"}}}
"缩写设置{{{1
"生成头文件注释
inoreabbrev <buffer> ghc /***************************************************************************************************<cr><bs>%fname%:<cr><tab>Copyright (c) Eisoo Software, Inc.(2004 - 2016), All rights reserved.<cr>Purpose:<cr><cr>Author:<cr><tab>wang.zhuowei@eisoo.com<cr><cr><backspace><backspace>Creating Time:<cr><tab>%ctime%<cr><bs>***************************************************************************************************/

"生成函数注释
inoreabbrev <buffer> /** /**<cr>*<cr>* @param<cr>* @throw<cr>* @return<cr>*<cr>**/
"}}}
"函数定义{{{1
" 在一个头文件里创建通用框架{{{2
function! IdlPlugin#MakeHeaderFrame()
    if line("$") ==# 1
        normal! :w
        normal! ggdGgg
        normal Ighc
        normal! 2o
        normal! I#include "nsISupports.idl"
        normal! 2o
        normal! I%{ C++
        normal! o
        normal! I%};
        normal! 2o
        normal! :sleep 100ms
        normal ,s
    endif
endfunction
"}}}
"}}}
call CalcModule#EvalArithmeticExp()
