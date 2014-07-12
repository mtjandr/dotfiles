" -[ Vundle Settings ]
set nocompatible        "Ward off unexpected things from global config, or distro settings
filetype off            "Required for vundle bundles

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"There is a bug where comments cannot follow the bundle
"Let Vundle manage Vundle, required
"Highlight and remove trailing whitespace
"Obtain a fancy status bar
"Show git branch
"Add scala syntax highlighting
Plugin 'gmarik/vundle'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'derekwyatt/vim-scala'

call vundle#end()

" -[ Syntastic ]
let g:syntastic_python_checkers=['python2.7']

" -[ Color Settings ]
syntax on               "Use pretty colours to distinguish syntax
set hlsearch            "Highlight all the terms that match your search
set t_Co=256            "Always try to use all 256 colours
colorscheme candycode   "Use canycode colour scheme

" -[ File Detection Settings ]
filetype on             "Enable file type detection
filetype indent on      "Enable loading indent file for specific file types
filetype plugin on      "Enable loading plugin files for specific file types

" -[ Vim Setting Settings ]
set fileformats=unix    "Global option specifies to use the unix format when reading a file
set mouse=a             "Enable mouse wheel scrolling, hold shift+mouse for normal use

" -[ Info Settings ]
set ruler               "Show cursor position in the bottom right
set number              "Show line number
set incsearch           "Search as you type
set showmatch           "Show matching brackets
set smartcase           "Be case sensitive only when capitilization is used
set ignorecase          "Otherwise ignore case
set laststatus=2        "Always show status bar

" -[ Whitespace Settings ]
"  http://tedlogan.com/techblog3.html
set tabstop=4           "Tell Vim that a tab counts for 4 columns
set shiftwidth=4        "Shift by 4 coloumns when using '<<' and '>>'
set softtabstop=4       "Use 4 columns when hitting Tab in insert mode
set expandtab           "Insert space characters whenever tab key is pressed
set smartindent         "Allow Vim to try and guess the proper indentation

" -[ File Specific ]-
"  Complete Tags with `C-X o` during closing '</'
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" -[ Mappings ] -
" Toggle Status Bar
" Toggle Paste Mode
" Toggle Wrap Mode
" Remove trailing whitespace
" Toggle highlight search
nnoremap <F1> :set <C-R>=&laststatus == 1 ? 'laststatus=2' : 'laststatus=1'<CR><CR>
nnoremap <F2> :set nopaste! paste?<CR>
nnoremap <F5> :set nonumber! number?<CR>
nnoremap <F6> :set nowrap! wrap?<CR>
nnoremap <F7> :FixWhitespace<CR>
nnoremap <F8> :set nohls! hlsearch?<CR>

