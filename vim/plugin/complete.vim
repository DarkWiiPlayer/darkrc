function s:autocomplete(enabled)
	if a:enabled
		let g:autocomplete=1
		for letter in (split("abcdefghijklmnopqrstuvwxyz", ".\\zs"))
			exec "inoremap ".letter." ".letter.""
		endfor
		echo "Autocomplete enabled"
	else
		unlet g:autocomplete
		for letter in (split("abcdefghijklmnopqrstuvwxyz", ".\\zs"))
			exec "iunmap ".letter
		endfor
		echo "Autocomplete disabled"
	endif
endfun

command -nargs=1 Complete call <SID>autocomplete(<q-args> == "on")
command ToggleComplete call <SID>autocomplete(!exists("g:autocomplete"))
map <leader>c :ToggleComplete<CR>
