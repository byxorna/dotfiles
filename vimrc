" file setup
:syntax on
:set ignorecase
:set number
:set mouse=
:set hlsearch
:set background=dark
:set incsearch
:set encoding=utf-8
:set fileencoding=utf-8
:set fileformat=unix

" disable .netrwhist nonsense
:let g:netrw_dirhistmax = 0

" tab stuff
:set autoindent
:set expandtab
:set smarttab
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2

" navigation (from http://statico.github.com/vim.html)
" go up and down one row, not one line (useful for wrapped lines)
:nmap j gj
:nmap k gk
" tab next/prev with shift h and shift l
nnoremap <S-h> gT
nnoremap <S-l> gt
" jump between last opened buffer with Ctrl+E (:b# and :e# do same thing)
:nmap <C-e> :e#<CR>
" jump between syntastic syntax errors on location-list with :ll

" title setting
"autocmd BufEnter * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
autocmd BufEnter * let &titlestring = "vim(" . expand("%:t") . ")"

" assorted automatic syntax loading. filetype -> syntax
" see https://github.com/vim-syntastic/syntastic/wiki/%28v3.7.0%29---Syntax-Checkers for list of plugins
au BufRead *.md set filetype=markdown
" NOTE: install `gem install mdl` for markdown setup
au BufRead *.scala set filetype=scala
au BufRead *.pp set filetype=puppet
au BufRead *.jade set filetype=jade
au BufRead *.go set filetype=go
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" always use 256 colors. its 2015.
set t_Co=256

"let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
let &titlestring = "vim(" . expand("%:t") . ")"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "xterm-color" || &term == "xterm-256color"
  set title
endif

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'fatih/vim-go'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'scrooloose/syntastic'
Plugin 'statianzo/vim-jade'
Plugin 'airblade/vim-gitgutter'
Plugin 'leafgarland/typescript-vim'
" turn on vimproc for command exec in <vim8, needed for typescript-vim
Plugin 'shougo/vimproc.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'thiagoalessio/rainbow_levels.vim'
"Plugin 'alecthomas/gometalinter'
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"set runtimepath^=~/.vim/bundle/syntastic.vim
" turn on vimproc for command exec in <vim8, needed for typescript-vim
"set runtimepath^=~/.vim/bundle/vimproc.vim
" turn on typescript-vim
"set runtimepath^=~/.vim/bundle/typescript-vim
" turn on nerdtree, let \ + } toggle tree
"set runtimepath^=~/.vim/bundle/nerdtree
noremap <leader>} :NERDTreeToggle<CR>
" turn on tagbar, toggle with \ + ]
set runtimepath^=~/.vim/bundle/tagbar
noremap <leader>] :TagbarToggle<CR>


" Creating a mapping to turn it on and off:
map <leader>l :RainbowLevelsToggle<cr>
" Or automatically turning it on for certain file types:
au FileType golang,ruby,javascript,python,php,xml,yaml :RainbowLevelsOn


" set overlength highlights for 80char lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%120v.\+/  " highlight all characters over 100char
match OverLength '\%101v.'  " highlight only the 101st character in a column

