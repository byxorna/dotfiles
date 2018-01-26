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
au BufRead *.md set filetype=markdown
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

" try and set up ctrlp. make sure you git submodule init
set runtimepath^=~/.vim/bundle/ctrlp.vim
" turn on syntastic for awesome syntax checking
set runtimepath^=~/.vim/bundle/syntastic.vim
" turn on vim-gitgutter
set runtimepath^=~/.vim/bundle/vim-gitgutter
" turn on vim-jade syntax
set runtimepath^=~/.vim/bundle/vim-jade
" turn on vim-go
set runtimepath^=~/.vim/bundle/vim-go
" turn on vimproc for command exec in <vim8, needed for typescript-vim
set runtimepath^=~/.vim/bundle/vimproc.vim
" turn on typescript-vim
set runtimepath^=~/.vim/bundle/typescript-vim
" turn on nerdtree, let \ + } toggle tree
set runtimepath^=~/.vim/bundle/nerdtree
noremap <leader>} :NERDTreeToggle<CR>
" turn on tagbar, toggle with \ + ]
set runtimepath^=~/.vim/bundle/tagbar
noremap <leader>] :TagbarToggle<CR>

" set overlength highlights for 80char lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%120v.\+/  " highlight all characters over 100char
match OverLength '\%101v.'  " highlight only the 101st character in a column

