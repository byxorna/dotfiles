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
" jump between last opened buffer with Ctrl+E (:b# and :e# do same thing)
:nmap <C-e> :e#<CR>

" title setting
autocmd BufEnter * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"

" assorted automatic syntax loading
au BufRead *.md set syntax=markdown

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "xterm-color" || &term == "xterm-256color"
  set title
endif

