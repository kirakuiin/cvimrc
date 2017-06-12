"while c++ file open. loading following map and func

"引入python模块

"自动补全各种符号
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap [ []<Left>
inoremap { {}<Left><CR><CR><Up><Tab>

"添加单行注释
nnoremap <buffer><localleader>c I//<esc>

"添加块注释
vnoremap <buffer><localleader>* <esc>`<i/*<esc>`>a*/<esc>

"添加宏条件编译
nnoremap <buffer><localleader># :call CppPlugin#GenerateDef()<cr>

"添加头文件框架
nnoremap <buffer><localleader>mf :call CppPlugin#MakeHeaderFrame()<cr>

"使用gcc编译文件
nnoremap <buffer><F7> :w<cr>:AsyncRun g++ -std=c++11 -g -Wall % -o %<<cr>

"执行文件
nnoremap <buffer><F5> :w<cr>:AsyncRun %<<cr>

"生成头文件注释
inoreabbrev <buffer> ghc /***************************************************************************************************<cr><backspace><backspace><backspace>%fname%:<cr><tab>Copyright (c) Eisoo Software, Inc.(2004 - 2016), All rights reserved.<cr>Purpose:<cr><cr>Author:<cr><tab>wang.zhuowei@eisoo.com<cr><cr><backspace><backspace>Creating Time:<cr><tab>%ctime%<cr><bs>***************************************************************************************************/

"生成类注释
inoreabbrev <buffer> gcc ////////////////////////////////////////////////////////////////////////////////////////////////////<cr>class %fname:h%<cr>

"生成trace
inoreabbrev <buffer> gtr %cpp_trace%

"生成函数注释
inoreabbrev <buffer> /** /**<cr>purpose :<cr><cr>param :<cr><cr>return :<cr><cr>other :<cr><cr><bs><bs><bs>**/

"生成类文件
inoreabbrev <buffer> gcb class %fname:h%<cr>{<cr><bs>public:<cr>%fname:h%();<cr>virtual ~%fname:h%();<cr><cr>%fname:h%(const %fname:h%&);<cr><cr>%fname:h%& operator=(const %fname:h%&);<cr><cr>private:<cr>};

"条件编译信息生成函数
function! CppPlugin#GenerateDef()
	let wordList = split(expand("%s"), '\v\.') 
	let prefix = split(wordList[0], '\v[A-Z]\zs')

	"将前一个字符串的最后一个大写字母移到下个字符串的开头, 并去掉空字符串
	let iter = 0
	let listlen = len(prefix)
	while iter < listlen-1
		let tmp = prefix[iter][-1:]
		let prefix[iter] = prefix[iter][:-2]
		let prefix[iter+1] = tmp . prefix[iter+1]
		let iter += 1
	endwhile
	call filter(prefix, 'v:val !=# ""')

	let marcoName = add(prefix, wordList[1])
	let marcoName = join(marcoName, "_")
	let marcoName = "__" . toupper(marcoName) . "__"

	execute 'normal! I#ifndef ' . marcoName . "\r"
	execute 'normal! I#define ' . marcoName . "\r"
	execute 'normal! Go#endif // ' . marcoName . "\r"
	
	execute 'normal! gg/' . marcoName . "\r"
	execute 'set nohlsearch'

endfunction

" 在一个头文件里创建通用框架
function! CppPlugin#MakeHeaderFrame()
	let filename = split(expand("%s"), '\v\.')

	if filename[1] !~? '\vh.*'
		echom 'Only .h file can create header frame' 
		return
	endif

	if line("$") ==# 1
		normal ggdGgg
		normal Ighc 
		normal o
		normal G\#
		normal jo
		normal jIgcc 
		normal o
		normal 0d$
		normal o
		normal Igcb
		normal o
		normal ,s
		" 创建一个同名cpp文件
		execute 'silent !echo \#include "' . expand("%s") . '">' . filename[0] . ".cpp"
	else
		call CppPlugin#WriteFuncDef()
	endif

endfunction

" 去除字符串前后空格符
function! CppPlugin#Trim(str)

	let bindex = match(a:str, '\v\S.*$')
	let eindex = match(a:str, '\v\s*$')
	return a:str[bindex:eindex-1]

endfunction

" 在一个字符串中获得一个函数的原型, 忽略返回值
function! CppPlugin#GetFuncPrototype(funcdef)
	let index = match(a:funcdef, '\v::')
	if index ==? -1
		let index = match(a:funcdef, '\v\S+\(.*\)\s*(const|)\s*(\=\s*0|);')
		let eindex = match(a:funcdef, '\v\s*\=\s*0;')
		return a:funcdef[index: eindex-1]
	else
		let index = index + 2
		return a:funcdef[index:-1]
	endif
endfunction

" 移除virtual和static关键字, 并给函数原型加上域操作符
" 函数将转化为 return_type#class::func(argv)
function! CppPlugin#ChangeFuncDef(funcdef)
	let remove_list		= ['static ', 'virtual ', 'inline ', ' = 0']
	let result 			= a:funcdef
	for i in remove_list
		let index = match(result, i)
		let ilen = len(i)
		if index ==# -1
			let result = result
		elseif index ==# 0
			let result = result[index+ilen:]
		else
			let result = result[:index-1] . result[index+ilen:]
		endif
	endfor

	let result = CppPlugin#Trim(result)
	let index = match(result, '\v\s+\S+\(.*\)')

	if	index ==# -1 
		let result ='#' . '%fname:h%::' . result[:-2]
	else
		let result = result[:index-1] . '#' . '%fname:h%::' . result[index+1:-2]
	endif

	return result
endfunction


" 将h文件里声明的函数在同名cpp文件中定义, 已经存在的定义不会被覆盖
" 注意: 此函数必须要在头文件里使用
function! CppPlugin#WriteFuncDef()
	let bufname 		= split(expand("%s"), '\v\.')[0] . ".cpp"
	let file_content 	= getline(1, "$")
	let buf_content		= readfile(bufname)
	let new_content 	= []
	
	let regexp_h		= "v:val =~? " . '"\\v\\w+\\(.*\\)\\s*(const|)\\s*(\\=\\s*0|);"'
	call filter(file_content, regexp_h)

	let regexp_cpp		= "v:val =~? " . '"\\v\\w+::.+\\(.*\\)\\s*(const|)"'
	call filter(buf_content, regexp_cpp)

	for i in file_content
		let hp = CppPlugin#Trim(i)
		let h_func = CppPlugin#GetFuncPrototype(hp)
		let isWrite = v:true

		let j = 0
		while j < len(buf_content)
			let cp = CppPlugin#Trim(buf_content[j])
			let cpp_func = CppPlugin#GetFuncPrototype(cp)
			if h_func ==# cpp_func
				let isWrite = v:false
				call remove(buf_content, j)
				break
			endif
			let j += 1
		endwhile


		if isWrite
			let funcdef = CppPlugin#ChangeFuncDef(i)
			let result = split(funcdef, "#")
			for i in result
				call add(new_content, i)
			endfor
			call add(new_content, "{")
			call add(new_content, '    NC_PROFILE_POINT();')
			call add(new_content, '    %cpp_trace%')
			call add(new_content, "}")
			call add(new_content, " ")
		endif
	endfor

	call writefile(new_content, bufname, "a")
endfunction
