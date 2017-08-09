"utilmod have some useful operation
"映射绑定{{{1
"替换字符常量为相应的值
nnoremap <leader>s :call UtilModule#SubstitudeFlag()<cr>

"打开此文件的新buffer
nnoremap <leader>nb :call UtilModule#OpenNewBufferForCurrentFile()<cr>

"清理未使用的buffer
nnoremap <leader>bc :call UtilModule#CleanUnusedBuffer()<cr>

"映射grep操作
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

"}}}
"自定义命令{{{1
"插件集合管理命令
command! -nargs=0 InstallLvimrc call UtilModule#InstallLvimrc()
command! -nargs=0 UpdateLvimrc call UtilModule#UpdateLvimrc()
command! -nargs=0 UninstallLvimrc call UtilModule#UninstallLvimrc()
"加载插入模式求值器
command! LoadCalcMod source $HOME/.vim/plugins/CalcModule.vim
"}}}
"全局变量{{{1
if has('win32')
    let g:newline = '\r\n'
    let g:asyncrun_encs = 'cp936'
elseif has('mac')
    let g:newline = '\r'
    let g:asyncrun_encs = 'utf-8'
else
    let g:newline = '\n'
    let g:asyncrun_encs = 'utf-8'
endif

"}}}
"函数定义{{{1
"替换标志为相应实体{{{2
function! UtilModule#SubstitudeFlag()

    "全局配置
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
    "个人邮件:%email%
    let emailstr = "549676201@qq.com"
    silent! execute '%s/%email%/' . emailstr . '/g'

    "当前文件trace(cpp)
    let g:cpptrace = 'NC_DO_MODULE_TRACE(_T("%s () ------ begin"), __AB_FUNC_NAME__);'
                \ . g:newline . '\tNC_DO_MODULE_TRACE(_T("%s () ------ end"), __AB_FUNC_NAME__);'
    silent! execute '%s/%cpp_trace%/' . g:cpptrace . '/g'

    "消除^M字符
    silent! execute '%s/\r//g'

    "清除末尾空格符
    silent! execute '%s/\v\s+$//g'

    "tab替换为空格符
    retab!

    "cpp 文件自动设为bom格式
    if &filetype ==# 'cpp'
        set bomb
    endif

    "保存修改
    write
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
    execute 'helptags ++t ../doc'
    " 更新插件
    execute 'PluginUpdate'
    " 清理插件
    execute 'PluginClean'
    q
endfunction
"}}}
"卸载插件函数{{{2
function! UtilModule#UninstallLvimrc()
    if has('unix')
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/vimfiles'
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/.vim'
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/.vimrc'
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/README.MD'
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/.git'
        silent execute 'AsyncRun rm -rf ' . expand($HOME) .'/.gitignore'
    else
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\vimfiles'
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\.vim'
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\.vimrc'
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\README.MD'
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\.git'
        silent execute 'AsyncRun del /Q ' . expand($HOME) .'\.gitignore'
    endif
endfunction
"}}}
"清理bufferlist{{{2
function! UtilModule#CleanUnusedBuffer()
    let current_number = bufnr('%')
    let last_number = bufnr('$')
    let nerd_number = bufnr('NERD*')
    let i = 1

    while i <= last_number
        if (i != current_number) && (i != nerd_number)
            silent! execute 'bw ' . string(i)
        endif
        let i = i + 1
    endwhile
endfunction
"}}}
"}}}
