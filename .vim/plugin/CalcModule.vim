"this module is design for calc math expression in the buffer
"{{{1映射绑定
inoremap <buffer>=? <esc>B"vyW:call CalcModule#EvalArithmeticExp()<cr>
"}}}
"函数定义{{{1
"将表达式求值并输出到buffer上的=号之后{{{2
function! CalcModule#EvalArithmeticExp()
	let value = string(eval((@v[:-1])))
	execute "normal A=" . value
endfunction
"}}}
"}}}
