
nnoremap <leader>mm :call <SID>EisooMakec(expand("%:p:h"), "")<cr><cr>
nnoremap <leader>mc :call <SID>EisooMakec(expand("%:p:h"), " clean")<cr><cr>
nnoremap <leader>mg :call <SID>EisooGenerateCML(expand("%:p:h"))<cr><cr>
nnoremap <leader>m> :silent! call <SID>ToErrorFile('next')<cr>
nnoremap <leader>m< :silent! call <SID>ToErrorFile('previous')<cr>

nnoremap <leader>mt :let g:target_name = ''<left>
nnoremap <leader>mv :let g:compile_version = 'x'<left>
nnoremap <leader>mp :let g:cmakelist_path = '\'<left>
nnoremap <leader>mw :let g:warn_level = g:warn_level + 1 == 3 ? 0 : g:warn_level + 1<cr>

nnoremap <leader>md :echo "version now is " . g:compile_version ."\n" .
			\ "relative path now is " . g:cmakelist_path . "\n" .
			\ "target name now is " . g:target_name . "\n" .
			\ "show_warning now is " . g:warn_level<cr>

nnoremap <F5> :silent execute "!start cmd /C \"C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\Microsoft Visual Studio 2008\\Microsoft Visual Studio 2008.lnk\""<cr>
nnoremap <F6> :silent execute "AsyncRun \"D:\\code\\5r\\cmake\\tools\\se.cmd\""<cr>

let g:compile_version = 'x64'   			"编译版本
let g:cmakelist_path = '\.'					"相对路径
let g:target_name = 'default_name'			"生成目标名
let g:error_list = []						"错误列表
let g:error_list_index = 0					"错误文件指针	
let g:is_frist_jump = 1						"是否第一次启动跳转
let g:warn_level = 0					    "警告级别，0:只显示错误，1:显示警告，2:显示全部信息

"调用eisoo makec.bat 生成目标文件
"参数为CMakeLists目录和是否清理的标志
function! s:EisooMakec(dir, isclean)
	let bdir = 'D:\code\5r\cmake\tools\abenv_wzw_ver.bat '
	let tdir = simplify(a:dir . g:cmakelist_path)
	echom "current dir is: " . tdir
	echom "compile version is" . g:compile_version
	silent execute "!" . bdir . g:compile_version . " \"" . tdir . "\""
				\ . a:isclean
	let index = bufwinnr("compile_res.txt")
	if index == -1 
	else
		silent execute string(index) . " wincmd w"
		q
	endif
		let filepath = tdir . '\compile_res.txt'
		silent execute "10sp " . filepath
		if g:warn_level != 2
			let newtext = GetErrorAndWarning(filepath)
			call writefile(newtext, filepath)
		endif
		wincmd p
endfunction

"生成CMakeLists文件
"参数为CMakeLists文件的地址
function! s:EisooGenerateCML(dir)
	let tdir = simplify(a:dir . g:cmakelist_path. "\\CMakeLists.txt")
	silent execute "!copy D:\\code\\5r\\cmake\\tools\\wzw_make_res\\CMakeLists.txt " . "\"" .
				\ tdir . "\""
	silent execute "1vs " . tdir
	silent execute '%s/\v\*target_name\*/' . g:target_name . '/g'
	wq
endfunction

"得到警告信息
"参数为生成的信息文件的路径
function! GetErrorAndWarning(filepath)
	let textlist = readfile(a:filepath)
	call reverse(textlist)
	for item in textlist
		if -1 != match(item, '\vNMAKE : fatal error')
			let have_error = 1
			break
		endif
		let have_error = 0
	endfor
	call reverse(textlist)

	if have_error
		call filter(textlist, 'v:val =~ "\\v.*(error|warning) \\w\\d+.*"')
		call filter(textlist, 'v:val !~ "\\v^NMAKE.*$"')
		if g:warn_level == 0
			call filter(textlist, 'v:val !~ ".*warning.*"')
		endif
		let flag = GetErrorList(textlist)
		if flag
			call add(textlist, "************************
						\ compile_error************************")
		else
			call add(textlist, "************************
						\ other_error************************")
		endif
	else
		call filter(textlist, 'v:val =~ "\\v(^\\[\\d.+\\%\\].*)|(.*warning.*)"')
		call GetErrorList(textlist)
		call add(textlist, "************************
					\ compile_success************************")
	endif
	return textlist
endfunction

"生成错误列表，列表的结构为[[filepath, errorline], ...]
"参数是之前的警告信息文件
"如果是编译错误返回1，如果是其他错误返回0
function! GetErrorList(filelist)
	let filelist = deepcopy(a:filelist)
	let g:error_list = []
	let g:error_list_index = 0
	let g:is_frist_jump = 1
	call filter(filelist, 'v:val =~ "\\v.*\\(\\d+\\) : .*"')
	if len(filelist) == 0
		return 0
	endif
	for item in filelist
		let filelocation = split(item, " : ")[0]
		let linenum = split(split(filelocation, '(')[-1], ')')[0]
		let lenofnum = len(linenum)
		let filepath = filelocation[0:len(filelocation)-1-lenofnum-2]
		call add(g:error_list, [filepath, linenum])
	endfor
	return 1
endfunction

"跳转到错误文件，并且将当前目录加到error_list中方便回到当前目录
"参数 next代表下一个 previous代表前一个
"注意 采用环形访问，所以没有尽头，每次打开新的错误文件当前目录会被强制保存
function! s:ToErrorFile(flag)
	if g:is_frist_jump == 1
		let curfilepath = expand("%:p")
		let curlinenum = string(line('.'))
		call insert(g:error_list, [curfilepath, curlinenum])
		let g:is_frist_jump = 0
	endif

	if a:flag ==# 'previous'
		let g:error_list_index = g:error_list_index-1 == -1 ? len(g:error_list)-1 : g:error_list_index-1
	else
		let g:error_list_index = g:error_list_index+1 == len(g:error_list) ? 0 : g:error_list_index+1
	endif
	write!
	call ShowCursor()
	call SwitchFile(g:compile_version, g:cmakelist_path, g:target_name, g:error_list, g:error_list_index, g:is_frist_jump)

endfunction

"因为在切换缓存的时候全局变量会丢失，所以令此函数保存context,同时切换buffer
"因为切换后会继续调用此函数，会造成函数使用中的重定义，所以采用silent!调用
"来忽略错误
"参数 6个全局变量
function! SwitchFile(a, b, c, d, e, f)
	silent execute "vs " .  a:d[a:e][0]
	wincmd p
	q
	let g:compile_version = a:a
	let g:cmakelist_path = a:b
	let g:target_name = a:c
	let g:error_list = a:d
	let g:error_list_index = a:e
	let g:is_frist_jump = a:f
	silent execute a:d[a:e][1]
endfunction

"在编译窗口里显示当前的错误光标 用<------来指示
function! ShowCursor()
	let index = winnr()
	let i = 4
	wincmd t
	while i != 0
		wincmd l
		let i = i - 1
	endwhile
	execute ':%s/\v\t+\<------$//g'
	if 0 != g:error_list_index 
		silent execute string(g:error_list_index)				
		normal! A		<------
	endif
	write!
	"silent execute string(index) . "wincmd w"
	wincmd b
endfunction 
