" Set up the runtime path
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim'
let &pp=&pp.','.expand('<sfile>:p:h').'/vim'

packadd packer.nvim

set nocompatible

set updatetime=600

set foldlevel=99
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

cnoreabbrev matcha Matcha -l

nnoremap g# :b #<CR>
