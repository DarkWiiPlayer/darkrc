function s:colorcolumn()
	if &colorcolumn != "0"
		set colorcolumn=0
	else
		set colorcolumn=+1
	end
endfun

noremap <F1> :setl number!<CR>:
noremap <leader><F1> :setl relativenumber!<CR>:
noremap <f2> :let &laststatus=!&laststatus*2<CR>:
noremap <leader><F2> :call <SID>colorcolumn()<CR>
noremap <F3> :setl autowriteall!<CR>:setl autowriteall?<CR>:
noremap <F4> :setl list!<CR>:
