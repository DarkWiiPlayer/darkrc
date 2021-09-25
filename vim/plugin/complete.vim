function s:autocomplete(enabled)
	if a:enabled
		for letter in (split("abcdefghijklmnopqrstuvwxyz", ".\\zs"))
			exec "inoremap ".letter." ".letter.""
		endfor
		let g:autcomplete=1
	else
		for letter in (split("abcdefghijklmnopqrstuvwxyz", ".\\zs"))
			exec "iunmap ".letter
		endfor
		unlet g:autocomplete
	end
endfun

command -nargs=1 Complete call <SID>autocomplete(<q-args> == "on")
command ToggleComplete call <SID>autocomplete(!exists("g:autocomplete"))
map <leader>c :ToggleComplete<CR>
