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
au BufRead *.erb set filetype=erb
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
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'go': 'all',
\   'javascript': 'all',
\   'c': 'all',
\}
let g:ale_fixers = {
\   'go': [ 'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace' ],
\   'ruby': [ 'rubocop', 'rufo', 'remove_trailing_lines', 'trim_whitespace' ],
\   'sh': [ 'shfmt', 'remove_trailing_lines', 'trim_whitespace' ],
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
"Plugin 'kien/ctrlp.vim'
" 2021.07.04 disabled for possible conflict with coc
"Plugin 'dense-analysis/ale'
"Plugin 'git://git.wincent.com/command-t.git'
Plugin 'statianzo/vim-jade'
Plugin 'airblade/vim-gitgutter'
Plugin 'leafgarland/typescript-vim'
" turn on vimproc for command exec in <vim8, needed for typescript-vim
Plugin 'shougo/vimproc.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'artanikin/vim-synthwave84'
Plugin 'dracula/vim', {'name':'dracula'}
Plugin 'rainglow/vim', {'name':'rainglow'}
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'hashivim/vim-terraform'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
call vundle#end()            " required
filetype plugin indent on    " requiredPlug 'junegunn/fzf', { 'do': { -> fzf#install() } }

if has('termguicolors')
  set termguicolors " 24-bit terminal
else
  let g:synthwave_termcolors=256 " 256 color mode
endif

" set colorscheme after termguicolors, or the background gets messed up
:set background=dark
:color synthwave84

"set runtimepath^=~/.vim/bundle/nerdtree
noremap <leader>} :NERDTreeToggle<CR>
" turn on tagbar, toggle with \ + ]
set runtimepath^=~/.vim/bundle/tagbar
noremap <leader>] :TagbarToggle<CR>


nnoremap <silent> <C-t> :GFiles<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-l> :Lines<CR>
" ctrl-h to lookup help for the current focused word as input
nnoremap <silent> <C-h> :Helptags!<CR>
let g:fzf_layout = { 'down': '40%' }
"nmap <Leader>f :GFiles<CR>
"nmap <Leader>F :Files<CR>

" these are default, but it doesnt hurt to call out improved search with
" snapping to search term
:set hlsearch
:set incsearch

" Ignore cases, but only when the cases are not uniform. That is, make 
" searching case-sensitive when there are upper and lower case letters.
:set ignorecase
:set smartcase

" set useful format options. see `:help fo-table` for more.
:set formatoptions=jtcroqln

" https://mandreyel.github.io/posts/fav-vim-settings/
"
fun! s:SetRelativeNumber()
    if &number
        set relativenumber
    endif
endfun

fun! s:UnsetRelativeNumber()
    if &number
        set norelativenumber
    endif
endfun

" automatically turn on relativenumbering when in command mode, and
" norelativenumber when in insert
augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * call s:SetRelativeNumber()
  autocmd BufLeave,FocusLost,InsertEnter   * call s:UnsetRelativeNumber()
augroup END

" coc tab completion stuff
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

set statusline^=%{coc#status()}

" set overlength highlights for 80char lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%120v.\+/  " highlight all characters over 100char
match OverLength '\%101v.'  " highlight only the 101st character in a column

" terraform specific settings
" https://github.com/hashivim/vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1

let g:coc_global_extensions = [
  \'coc-json',
  \'coc-git',
  \'coc-html',
  \'coc-css',
  \'coc-yaml',
  \'coc-sh',
  \'coc-tsserver',
  \'coc-pyright',
  \'coc-solargraph']
