"******************************************************************************
"description:
"    wangzhuowei's vimrc files
"
"author:
"    wangzhuowe@eisoo.com
"
"time:
"    2016-8-2
"******************************************************************************
"Source other module
"source $VIMRUNTIME/mswin.vim
"behave mswin

"end_Source
"******************************************************************************
"Initialization

"加载grep插件
"source $VIMRUNTIME\..\plugin\*.vim

"关闭兼容模式
set nocompatible

"自动语法高亮
syntax on

"设定配色方案
colorscheme molokai

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

"覆盖文件不备份
set nobackup

"不生成undo文件
set noundofile

"不生成swap文件
set noswapfile

"自动切换目录为当前文件目录
set autochdir

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

"设置启动窗口大小
"set lines=30 columns=80

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
set statusline=%f 	 " 文件路径
set statusline+=%=	 " 切换到右侧模式 
set statusline+=%B	 " 显示当前光标编码值
set statusline+=%y   " 显示文件类型
set statusline+=%c   " 显示列号
set statusline+=%l	 " 当前行数
set statusline+=/    " 分隔符
set statusline+=%L   " 总行数
set statusline+=%P   " 总百分比
set statusline=%<%f%h%m%r%y%=%b\ 0x%B\ \ %l/%L,%c\ %P

au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

"将剪粘板设置为unnamed寄存器
set clipboard=unnamed

"GVIM全屏化
if has('gui_running') && has("win32")
    au GUIEnter * simalt ~x
endif

"设置编码格式
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=gb2312
set termencoding=utf-8

"设置字体
if has('mac')
    set guifont=Monaco:h18
elseif has('win32')
    set guifont=consolas:h14
endif

"具有三行上下光标
set scrolloff=3
"end_Initialization
"******************************************************************************
"individual_mapping

"设置learder键
let mapleader = ","

"设置localleader
let maplocalleader = "\\"

"设置打开配置文件快捷键
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"字符搜索时自动加入\v参数
nnoremap / /\v
nnoremap ? ?\v

nnoremap <leader>/ :execute "normal! /\\v" . expand(@*). "\r"<cr>

"去除搜索高亮
nnoremap <leader>nh :nohlsearch<cr>

"使vimrc设置作为脚本立即执行
nnoremap <leader>sv :source $MYVIMRC<cr>

"给单词加上单引号
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lbl<cr>

"再插入模式中用jk取代<esc>
inoremap jk <esc>

"再插入模式中禁止使用<esc>键
inoremap <esc> <nop>

"禁用方向键
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>

"设置切换分屏的快捷键
nnoremap <leader><leader> <c-w>

"设置自动命令组，防止重复加载
augroup wzws_autocmd

"清除组内自动命令
	autocmd!

"加载c++配置
	autocmd FileType cpp source $HOME/.vim/plugin/CppPlugin.vim

"加载scheme配置
	autocmd FileType scheme source $HOME/.vim/plugin/SchemePlugin.vim

"加载AsyncRun
	source $HOME/.vim/plugin/asyncrun.vim

"组结束
augroup END

"Vundle插件配置
"end_individual_mapping
"******************************************************************************
"custom command
"
command! LoadCalcMod source $HOME/.vim/plugin/CalcModule.vim
command! LoadUtilMod source $HOME/.vim/plugin/UtilModule.vim
command! LoadPlugCfg source $HOME/.vim/plugin/PluginConfig.vim

"end_custom-command
"******************************************************************************
"Vundle插件配置
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin('$HOME/vimfiles/bundle')
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
Plugin 'ascenator/L9', {'name': 'newL9'}
" Install The NERD-Tree
Plugin 'The-NERD-tree'

call vundle#end()            " required
filetype plugin indent on    " required
"end_Vundle
"*****************************************************************************
"自动加载
LoadPlugCfg

"Vundle插件配置
"end_individual_mapping
"******************************************************************************
