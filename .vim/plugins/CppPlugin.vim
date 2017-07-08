"while c++ file open. loading following map and func
"��������{{{1
setlocal fdm=marker
setlocal foldlevel=0
"}}}
"ӳ���{{{1
"�Զ���ȫ���ַ���
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap [ []<Left>
inoremap { {}<Left><CR><CR><Up><Tab>

"���ӵ���ע��
nnoremap <buffer><localleader>c I//<esc>

"���ӿ�ע��
vnoremap <buffer><localleader>* <esc>`<i/*<esc>`>a*/<esc>

"���Ӻ���������
nnoremap <buffer><localleader># :call CppPlugin#GenerateDef()<cr>

"����ͷ�ļ����
nnoremap <buffer><localleader>mf :call CppPlugin#MakeHeaderFrame()<cr>

"ʹ��gcc�����ļ�
nnoremap <buffer><F7> :w<cr>:AsyncRun g++ -std=c++11 -g -Wall % -o %<<cr>

"ִ���ļ�
if (has('win32'))
  nnoremap <buffer><F5> :w<cr>:AsyncRun %<<cr>
else
  nnoremap <buffer><F5> :w<cr>:AsyncRun ./%<<cr>
endif
"}}}
"��д����{{{1
"����ͷ�ļ�ע��
inoreabbrev <buffer> ghc /***************************************************************************************************<cr><backspace><backspace><backspace>CppPlugin.vim:<cr><tab>Copyright (c) Eisoo Software, Inc.(2004 - 2016), All rights reserved.<cr>Purpose:<cr><cr>Author:<cr><tab>wang.zhuowei@eisoo.com<cr><cr><backspace><backspace>Creating Time:<cr><tab>2017- 7-08<cr><bs>***************************************************************************************************/

"������ע��
inoreabbrev <buffer> gcc //class CppPlugin{{{<cr> "}}}

"����trace
inoreabbrev <buffer> gtr NC_DO_MODULE_TRACE(_T("%s () ------ begin"), __AB_FUNC_NAME__);

"���ɺ���ע��
inoreabbrev <buffer> /** /**<cr>purpose :<cr><cr>param :<cr><cr>return :<cr><cr>other :<cr><cr><bs><bs><bs>**/

"�������ļ�
inoreabbrev <buffer> gcb class CppPlugin<cr>{<cr><bs>public:<cr>CppPlugin();<cr>virtual ~CppPlugin();<cr><cr>CppPlugin(const CppPlugin&);<cr><cr>CppPlugin& operator=(const CppPlugin&);<cr><cr>private:<cr>};
"}}}
"��������{{{1
"����������Ϣ���ɺ���{{{2
function! CppPlugin#GenerateDef()
    let wordList = split(expand("%s"), '\v\.')
    let prefix = split(wordList[0], '\v[A-Z]\zs')

    "��ǰһ���ַ��������һ����д��ĸ�Ƶ��¸��ַ����Ŀ�ͷ, ��ȥ�����ַ���
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
"}}}
" ��һ��ͷ�ļ��ﴴ��ͨ�ÿ��{{{2
function! CppPlugin#MakeHeaderFrame()
    let filename = split(expand("%s"), '\v\.')

    if filename[1] !~? '\vh.*'
        echom 'Only .h file can create header frame'
        return
    endif
    "{{{
    if line("$") ==# 1
        normal ggdGgg
        normal Ighc
        normal o
        normal G\#
        normal jo
        normal jIgcc
        normal 0d$
        normal Igcb
        normal o
        normal I//}}}
        normal o
        normal 0d$
        normal ,s

        let targetname = filename[0] . ".cpp"

        " ����һ��ͬ��cpp�ļ�
        if has('win32')
            silent execute '!cd. > ' . targetname
        else
            silent execute '!touch ' . targetname
        endif

        " ������Ϣ
        let i = 0
        let message = []
        while i < 10
            call add(message, getline(i+1))
            let i = i + 1
        endwhile
        call add(message, '#include "' . expand('%s') . '"')
        call add(message, '')
        call writefile(message, targetname)
    else
        call CppPlugin#WriteFuncDef()
    endif

endfunction
"}}}
" ȥ���ַ���ǰ��ո��{{{2
function! CppPlugin#Trim(str)

    let bindex = match(a:str, '\v\S.*$')
    let eindex = match(a:str, '\v\s*$')
    return a:str[bindex:eindex-1]

endfunction

" ��һ���ַ����л��һ��������ԭ��, ���Է���ֵ
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
"}}}
" �Ƴ�virtual��static�ؼ���, ��������ԭ�ͼ����������{{{2
" ������ת��Ϊ return_type#class::func(argv)
function! CppPlugin#ChangeFuncDef(funcdef)
    let remove_list     = ['static ', 'virtual ', 'inline ', ' = 0']
    let result          = a:funcdef
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

    if  index ==# -1
        let result ='#' . 'CppPlugin::' . result[:-2]
    else
        let result = result[:index-1] . '#' . 'CppPlugin::' . result[index+1:-2]
    endif

    return result
endfunction
"}}}
" ��h�ļ��������ĺ�����ͬ��cpp�ļ��ж���, �Ѿ����ڵĶ��岻�ᱻ����{{{2
function! CppPlugin#WriteFuncDef()
    let bufname         = split(expand("%s"), '\v\.')[0] . ".cpp"
    let file_content    = getline(1, "$")
    let buf_content     = readfile(bufname)
    let new_content     = []

    let regexp_h        = "v:val =~? " . '"\\v\\w+\\(.*\\)\\s*(const|)\\s*(\\=\\s*0|);"'
    call filter(file_content, regexp_h)

    let regexp_cpp      = "v:val =~? " . '"\\v\\w+::.+\\(.*\\)\\s*(const|)"'
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

            " ��дmarker
            let marker = '//'
            for i in result
                let marker = marker . i . ' '
            endfor
            let marker = CppPlugin#Trim(marker) . '{{{' "}}}
            call add(new_content, marker)

            " ��д��������
            for i in result
                call add(new_content, i)
            endfor

            call add(new_content, "{")
            call add(new_content, '    NC_PROFILE_POINT();')
            call add(new_content, '    NC_DO_MODULE_TRACE(_T("%s () ------ begin"), __AB_FUNC_NAME__);')
            call add(new_content, "}") "{{{
            call add(new_content, "//}}}")
        endif
    endfor

    call writefile(new_content, bufname, "a")
endfunction
"}}}
"}}}