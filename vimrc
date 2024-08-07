" Set up the runtime path
set runtimepath=$VIMRUNTIME,$HOME/.config/nvim,$HOME/.vim
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim'
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim/pack/*/start/*'

set nocompatible

set updatetime=600

au VimEnter * TSEnable highlight
au VimEnter * TSEnable incremental_selection
au VimEnter * TSEnable indent

set foldlevel=99
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

nnoremap g# :b #<CR>
