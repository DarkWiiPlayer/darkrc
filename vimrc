" vim: set bufhidden=delete noexpandtab tabstop=3 :miv "
"!!! makes use of marker '

" Set up the runtime path
set runtimepath=$VIMRUNTIME,$HOME/.config/nvim,$HOME/.vim
let &rtp=&rtp.','.expand('<sfile>:p:h').'/vim'

if has("nvim")
	lua pcall(require, "plugins")
end

au VimEnter * TSEnable highlight
au VimEnter * TSEnable incremental_selection
au VimEnter * TSEnable indent
