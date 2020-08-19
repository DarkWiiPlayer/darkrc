" Extend autosavefeature :)

function! TryAutosave()
	if &autowriteall && &mod && &buftype==""
		silent write
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
