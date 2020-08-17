nnoremap <leader>h :call <SID>toggleWUC()<CR>

function! s:updateWUC()
	if exists("b:hlwuc")
		if b:hlwuc > 1
			call matchdelete(b:hlwuc)
		end
	end
	if exists("b:word_hl")
		let hl = b:word_hl
	else
		let hl = "Underlined"
	endif
	let l:str = "\\<".escape(expand("<cword>"), "\\")."\\>"
	let b:hlwuc = matchadd(hl, l:str)
endfunc

function! s:toggleWUC()
	augroup hlwuc
	if exists("b:hlwuc")
		autocmd!
		if b:hlwuc > 1
			call matchdelete(b:hlwuc)
		end
		unlet b:hlwuc
	else
		autocmd CursorMoved <buffer> call <SID>updateWUC()
		autocmd CursorMovedI <buffer> call <SID>updateWUC()
		call <SID>updateWUC()
	endif
	augroup END
	redraw
endfunction
