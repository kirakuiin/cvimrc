"wangzhuowei's vimrc files{{{1
"
"author:
"    wangzhuowe@eisoo.com
"
"time:
"    2016-8-2
"}}}
"特性设置{{{1
"关闭兼容模式
set nocompatible

"自动语法高亮
syntax on

"显示行号
set number

"突出显示当前行
set cursorline
    
"打开状态栏标尺
set ruler

"用空格替换tab
set expandtab

"设定tab长度
set tabstop=4
set softtabstop=4

"覆盖文件不备份
set nobackup

"不生成undo文件
set noundofile

"不生成swap文件
set noswapfile

"设置每行最大文本数量
set textwidth=80

"设置文件格式
set fileformat=unix


"设置自动对齐
set autoindent

"设置备份行为为覆盖
set backupcopy=yes

"动态显示搜索内容
set incsearch

"高亮被搜索文本
set hlsearch

"关闭错误信息响铃
set noerrorbells

"插入括号是短暂调到被匹配括号
set showmatch

"跳过去的时间
set matchtime=5

"设置魔术
set magic

"开启智能缩进
set smartindent

"非插入状态下无法用无法删除回车符
set backspace=indent,eol,start

"使得状态栏和命令行分开    
set laststatus=2

"去掉菜单
set go=

"设置c风格缩进
set cindent

"忽略命令大小写
set ignorecase

"设置每一级缩进长度
set shiftwidth=4

"设置状态栏
set statusline=%<%f%h%m%r%y%=%b\ 0x%B\ \ %l/%L,%c\ %P

"将剪粘板设置为unnamed寄存器
set clipboard=unnamed

"设置编码格式
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=gb2312
set termencoding=utf-8

"具有三行上下光标
set scrolloff=3

"gvim专用
if has('gui_running')
    "开始折叠
    set foldenable

    "设置语法折叠
    set foldmethod=manual

    "设置折叠宽度
    set foldcolumn=0

    "设置折叠层数
    setlocal foldlevel=1 

    "设置为自动关闭折叠
    set foldclose=all

    "自动切换目录为当前文件目录
    set autochdir

    "设置平台相关信息
    if has('mac')
        set guifont=Monaco:h18
        set rtp+=~/.vim

    elseif has('win32')
        set guifont=consolas:h14
        set rtp+=~\.vim
        "win GVIM全屏化
        au GUIEnter * simalt ~x

    else
        set rtp+=~/.vim

    endif
endif

"}}}
"映射绑定{{{1
"字符搜索时自动加入\v参数
nnoremap / /\v
nnoremap ? ?\v

"再插入模式中用jk取代<esc>
inoremap jk <esc>

"再插入模式中禁止使用<esc>键
inoremap <esc> <nop>

"禁用方向键
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>

"buffer切换键绑定
nnoremap <PageUp> :bp<cr>
nnoremap <PageDown> :bn<cr>

"设置查找邮件未定操作符(motion)
onoremap in@ :<c-u>execute "normal! /\\w\\+\\([-+.]\\w\\+\\)*@\\w\\+\\([-.]\\w\\+\\)*\\.\\w\\+\\([-.]\\w\\+\\)*\r:nohlsearch\rvg_"<cr><cr>

"设置learder键
let mapleader = ','

"设置localleader
let maplocalleader = '\'

"设置打开配置文件快捷键
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"使vimrc设置作为脚本立即执行
nnoremap <leader>sv :source $MYVIMRC<cr>

"搜索@"寄存器的内容
nnoremap <leader>/ :execute "normal! /\\v" . expand(@*). "\r"<cr>

"去除搜索高亮
nnoremap <leader>nh :nohlsearch<cr>

"给单词加上单引号
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lbl<cr>

"设置切换分屏的快捷键
nnoremap <leader><leader> <c-w>

"映射cnext
nnoremap <leader>> :cnext<cr>

"映射cprevious
nnoremap <leader>< :cprevious<cr>
"}}}
"全局加载{{{1
"加载通用模块
    source $HOME/.vim/plugins/UtilModule.vim

"加载配置文件
    source $HOME/.vim/plugins/PluginConfig.vim
"}}}
"自动加载{{{1
"设置自动命令组，防止重复加载
augroup wzws_autocmd

"清除组内自动命令
    autocmd!

"加载c++配置
    autocmd FileType cpp source $HOME/.vim/plugins/CppPlugin.vim

"加载python配置
    autocmd Filetype python source $HOME/.vim/plugins/PythonPlugin.vim

"加载scheme配置
    autocmd FileType scheme source $HOME/.vim/plugins/SchemePlugin.vim

"打开vim文件时采用marker缩进
    autocmd FileType vim source $HOME/.vim/plugins/VimPlugin.vim

"组结束
augroup END
"}}}
