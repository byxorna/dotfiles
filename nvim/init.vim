set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" https://github.com/neovim/neovim/issues/7994
au InsertLeave * set nopaste
