"utilmod have some useful operation
"映射绑定{{{1
"替换字符常量为相应的值
nnoremap <leader>s :call UtilModule#SubstitudeFlag()<cr>

"打开此文件的新buffer
nnoremap <leader>nb :call UtilModule#OpenNewBufferForCurrentFile()<cr>

"设置查找邮件未定操作符(motion)
onoremap in@ :<c-u>execute "normal! /\\w\\+\\([-+.]\\w\\+\\)*@\\w\\+\\([-.]\\w\\+\\)*\\.\\w\\+\\([-.]\\w\\+\\)*\r:nohlsearch\rvg_"<cr><cr>

"高亮结尾空格
nnoremap <leader>w :<c-u>execute ":match Error " . '/\v +$/'<cr>

"清除高亮空格
nnoremap <leader>W :<c-u>execute ":match none"<cr>

nnoremap <F3> :call asyncrun#quickfix_toggle(8)<cr>

"映射cnext
nnoremap <leader>> :cnext<cr>

"映射cprevious
nnoremap <leader>< :cprevious<cr>

"映射grep操作
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

"映射dash only for macos
if has('mac')
    nnoremap <leader>d :Dash<cr>
endif
"}}}
"自定义命令{{{1
command! -nargs=0 InstallLvimrc :call UtilModule#InstallVim()<cr>
command! -nargs=0 UpdateLvimrc :call UtilModule#UpdateLvimrc()<cr>
command! -nargs=0 UninstallLvimrc :call UtilModule#UninstallLvimrc()<cr>
"}}}
"函数定义{{{1
"替换标志为相应实体{{{2
function! UtilModule#SubstitudeFlag()

	" 全局配置
	"当前文件名:%fname%
	let fnamestr = expand("%")
	silent! execute '%s/%fname%/' . fnamestr . '/g'
	"当前文件名头:%fname:h%
	let fnamehstr = expand("%:r")
	silent! execute '%s/%fname:h%/' . fnamehstr . '/g'
	"当前行数:%fline%
	let flinestr = string(line("."))
	silent! execute '%s/%fline%/' . flinestr . '/g'
	"当前时间:%ctime%
	let ctimestr = substitute(strftime("%Y-%b-%d"), "月", "", "")
	silent! execute '%s/%ctime%/' . ctimestr . '/g'
	"个人邮件:%email%"
	let emailstr = "549676201@qq.com"
	silent! execute '%s/%email%/' . emailstr . '/g'

	" 特化配置
	
	"当前文件trace(cpp)
	let g:um_cpptrace = 'NC_DO_MODULE_TRACE(_T("%s () ------ begin"), __AB_FUNC_NAME__);'
	silent! execute '%s/%cpp_trace%/' . g:um_cpptrace . '/g'

	"消除^M字符
	silent! execute '%s/\r//g'
endfunction
"}}}
"重新创建一个GVIM来打开此文件{{{2
function! UtilModule#OpenNewBufferForCurrentFile()
	let fnamestr = expand("%")
	silent! execute '!start gvim ' . fnamestr
endfunction
"}}}
"使用系统grep来查找指定字符串{{{2
function! s:GrepOperator(type)
	let saved_unnamed_register = @"

    if has('win32')
        let l:slash = "\\"
    else
        let l:slash = "\/"
    endif

	if a:type ==# 'v'
		normal! `<v`>y
	elseif a:type ==# 'char'
		normal! `[v`]y
	else
		return
	endif

    let findpath = getcwd()

    if (has("win32"))
        silent execute "grep! /S " . shellescape(@") . " " . findpath . l:slash . "*"
    else
        silent execute "grep! -R " . shellescape(@") . " " . findpath . l:slash . "*"
    endif

	copen

	let @" = saved_unnamed_register
endfunction
"}}}
"安装插件函数{{{2
function! UtilModule#InstallLvimrc()
    "安装插件
    PluginInstall
endfunction
"}}}
"更新插件函数{{{2
function! UtilModule#UpdateLvimrc()
    " 更新插件
    PluginUpdate
    " 清理插件
    PluginClean
endfunction
"}}}
"卸载插件函数{{{2
function! UtilModule#UninstallLvimrc()
    if has('unix')
        silent execute '!rm -rf ' . expand($HOME) .'/vimfiles'
        silent execute '!rm -rf ' . expand($HOME) .'/.vim'
        silent execute '!rm -rf ' . expand($HOME) .'/vimfiles'
        silent execute '!rm -rf ' . expand($HOME) .'/.vimrc'
        silent execute '!rm -rf ' . expand($HOME) .'/README.MD'
        silent execute '!rm -rf ' . expand($HOME) .'/.git'
        silent execute '!rm -rf ' . expand($HOME) .'/.gitignore'
    else
    endif
endfunction
"}}}
"}}}
