" vim: set bufhidden=delete noexpandtab tabstop=3 :miv "
"!!! makes use of marker '

let &rtp=expand('<sfile>:p:h').'/vim,'.&rtp

run git.vim
run shame.vim
