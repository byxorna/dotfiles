" file setup
:syntax on
:set ignorecase
:set number
:set mouse=
:set hlsearch
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

"let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
let &titlestring = "vim(" . expand("%:t") . ")"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "xterm-color" || &term == "xterm-256color"
  set title
endif

" ale lint configuration
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'go': [ 'bingo', 'gobuild', 'gofmt', 'golangci-lint', 'golint', 'gopls', 'gosimple', 'gotype', 'govet', 'golangserver', 'staticcheck'],
\   'javascript': 'all',
\   'c': 'all',
\}
let g:ale_fixers = {
\   'go': [ 'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace' ],
\}

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
Plugin 'dense-analysis/ale' " a ton of linters :)
"Plugin 'fatih/vim-go'
Plugin 'git://git.wincent.com/command-t.git'
"Plugin 'scrooloose/syntastic'
Plugin 'statianzo/vim-jade'
Plugin 'airblade/vim-gitgutter'
Plugin 'leafgarland/typescript-vim'
" turn on vimproc for command exec in <vim8, needed for typescript-vim
Plugin 'shougo/vimproc.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'thiagoalessio/rainbow_levels.vim'
"Plugin 'alecthomas/gometalinter'
Plugin 'exitface/synthwave.vim'
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


" https://github.com/exitface/synthwave.vim
:set background=dark
:color synthwave

if has('termguicolors')
  set termguicolors " 24-bit terminal
else
  let g:synthwave_termcolors=256 " 256 color mode
endif

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
" au FileType golang,ruby,javascript,python,php,xml,yaml :RainbowLevelsOn


" set overlength highlights for 80char lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%120v.\+/  " highlight all characters over 100char
match OverLength '\%101v.'  " highlight only the 101st character in a column

