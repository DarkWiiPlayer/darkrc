" vim: set bufhidden=delete noexpandtab tabstop=3 :miv "
"!!! makes use of marker '

" Set up the runtime path
set runtimepath=$VIMRUNTIME,$HOME/.config/nvim,$HOME/.vim
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim'
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim/pack/*/start/*'

set nocompatible

au VimEnter * TSEnable highlight
au VimEnter * TSEnable incremental_selection
au VimEnter * TSEnable indent

set foldlevel=99
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
