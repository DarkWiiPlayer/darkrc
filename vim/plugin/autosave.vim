" Extend autosavefeature :)

function! TryAutosave()
	if &autowriteall && &mod && &buftype==""
		if has("nvim")
			do BufWritePre
			silent write
			do BufWritePost
		else
			silent write
		end
		redraw
	end
endfunction

if exists("$AUTOSAVE") 
	set autowriteall
end

augroup autosave
autocmd!
	autocmd BufLeave * call TryAutosave()
	autocmd CursorHold * call TryAutosave()
	autocmd InsertLeave * call TryAutosave()
	autocmd TextChanged * call TryAutosave()
	autocmd FocusLost * call TryAutosave()
augroup END
