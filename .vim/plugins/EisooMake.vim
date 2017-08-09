"Eisoo cmake vim插件
"特性设置{{{1
setlocal noautochdir
"}}}
"映射绑定{{{1
nnoremap <LocalLeader>md :call <SID>EisooMakec('d')<cr>
nnoremap <LocalLeader>mdc :call <SID>EisooMakec('dc')<cr>
nnoremap <LocalLeader>mr :call <SID>EisooMakec('r')<cr>
nnoremap <LocalLeader>mrc :call <SID>EisooMakec('rc')<cr>
nnoremap <LocalLeader>ml :call <SID>EisooMakec('l')<cr>
"}}}
"命令设置{{{1
command! -complete=customlist,s:ListBitnum -nargs=1
    \ SetEisooEnv call s:LoadEisooConfig('<args>')
"}}}
"函数定义{{{1
"SetEisooEnv命令补全函数{{{2
function! s:ListBitnum(A, L, P)
    return ['x86', 'x64']
endfunction
"}}}
"Eisoo makec封装{{{2
function! s:EisooMakec(option)
    if a:option ==# 'r'
        let compile_cmd = 'release'
    elseif a:option ==# 'rc'
        let compile_cmd = 'release cleanall'
    elseif a:option ==# 'd'
        let compile_cmd = ''
    elseif a:option ==# 'dc'
        let compile_cmd = 'cleanall'
    elseif a:option ==# 'l'
        if has('win32')
            execute 'AsyncRun dir'
        else
            execute 'AsyncRun ls -al'
        endif
        return
    endif

    execute 'AsyncRun makec ' . compile_cmd
endfunction
"}}}
"加载$HOME/eisoo.config文件{{{2
function! s:LoadEisooConfig(bitnum)

    let s:config_path = expand($HOME) .'/eisoo.config'
    if !filereadable(s:config_path)
        echoerr  "not found config file! gene it at $HOME/eisoo.config"
        call GenerateConfigFile();
        return
    endif

    if has('win32')
        let s:fileContent = readfile(s:config_path)
        call filter(s:fileContent, 'v:val =~? "WIN32"')
    elseif has('unix')
        echo 'nop'
    else
        throw 'not support this system'
    endif

    " 获得脚本所在目录
    let s:eisoo_tools = s:fileContent[match(s:fileContent, 'EISOO_TOOLS')]
    let s:eisoo_tools = split(s:eisoo_tools, '=')[-1]

    " 获得当前文件路径
    let s:currentFile = expand('%:p')

    execute 'cd ' . expand(s:eisoo_tools)

    if has('win32')
        let s:fileContent = readfile('./abenv.bat', 'b')
        let s:writeFileName = './eisoo_make.bat'
    elseif has('unix')
        let s:fileContent = readfile('./abenv.sh', 'b')
        let s:writeFileName = './eisoo_make.sh'
    endif

    call add(s:fileContent, 'start gvim "+LoadEisooMake" ' . s:currentFile )
    call add(s:fileContent, 'exit')
    if  !filewritable(s:writeFileName)
        execute 'AsyncRun cd. > ' . s:writeFileName
    endif

    call writefile(s:fileContent, s:writeFileName, 'b')

    execute 'AsyncRun start eisoo_make.bat ' . a:bitnum
    sleep 2
    qa
endfunction
"}}}
"生成配置文件{{{2
function! s:GenerateConfigFile()
    let filepath = expand($HOME) . '/eisoo.config'
    silent! execute '!cd. > ' . filepath

    let content = ['WIN32_EISOO_TOOLS=E:\eisoo\Apollo\apollo\cmake\tools']
    call add(content, 'LINUX_EISOO_TOOLS=/code/Columbus/5r')

    call writefile(content, filepath)
endfunction
"}}}
"}}}
