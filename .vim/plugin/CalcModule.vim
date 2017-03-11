"this module is design for calc math expression in the buffer
inoremap <buffer>=? <esc>B"vyW:call CalcModule#EvalArithmeticExp()<cr>
command! -nargs=* EnumFmt call CalcModule#EnumeratorFormat(<args>)

function! CalcModule#EvalArithmeticExp()
	let value = string(eval((@v[:-1])))
	execute "normal A=" . value
endfunction

function! CalcModule#EnumeratorFormat(format, range_begin, range_end)
	let begin = a:range_begin
	while begin <= a:range_end
		let value = printf(a:format, begin)
		execute "normal GA" . value
		let begin += 1
	endwhile
endfunction
