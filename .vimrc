set nocompatible              " be iMproved, required

filetype off                  " required


" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

"let Vundle manage Vundle, required

Plugin 'VundleVim/Vundle.vim'
Plugin 'simplyzhao/cscope_maps.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdtree'
Plugin 'mhinz/vim-signify'
Plugin 'triglav/vim-visual-increment'
Plugin 'gmoe/vim-eslint-syntax'
Plugin 'junegunn/goyo.vim'

""Plugin 'Valloric/YouCompleteMe'

"
"All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
"  auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


 

 

aug CStuff
    au!
    au BufEnter *.c set syntax=c.doxygen textwidth=75
    au BufEnter *.h set syntax=c.doxygen textwidth=75
    au BufEnter *.cpp set syntax=cpp.doxygen textwidth=75
aug END

let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 1

set t_Co=256
set background=dark
colorscheme diokai

set nu
filetype indent on
set tabstop=4
set shiftwidth=4
set expandtab
set hlsearch

nmap ,cr :!cscope -Rb<enter> :cs reset<enter>
set cst
set csre

let python_highlight_all=1
syntax on
