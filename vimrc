:syntax on
:set ignorecase
:set number
:set mouse=
:set hlsearch
:set autoindent
:set background=dark
:set incsearch
:set encoding=utf-8
:set fileencoding=utf-8
:set fileformat=unix
:set expandtab
:set smarttab
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
autocmd BufEnter * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"

let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "xterm-color" || &term == "xterm-256color"
  set title
endif

