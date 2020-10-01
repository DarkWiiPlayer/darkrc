function Zen()
	set nonumber
	set norelativenumber
	set colorcolumn=0
	set laststatus=0
	if has("nvim")
		set fillchars=eob:\ 
	end
endfun

command! Zen call Zen()

nnoremap <F12> :Zen<CR>
