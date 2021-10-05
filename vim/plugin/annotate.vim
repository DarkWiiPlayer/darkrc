let s:namespace = nvim_create_namespace("annotate_cursor")
let s:callbacks = []

function! Blame()
	if exists("b:blame")
		let l:lineblame = b:blame[line('.')-1]
		return l:lineblame['author'] . ' @ ' . l:lineblame['time']
	end
endfun

function! Annotate(callback)
	call insert(s:callbacks, a:callback)
	call s:update()
endfun
com! -nargs=1 Annotate call Annotate(funcref(<q-args>))

function! Deannotate(callback)
	let s:callbacks = filter(s:callbacks, { idx, value -> value != a:callback })
	call s:update()
endfun
com! -nargs=1 Deannotate call Deannotate(funcref(<q-args>))

function! Annotated(callback)
	for l:Callback in s:callbacks
		if l:Callback == a:callback
			return 1
		end
	endfor
	return 0
endfun

function! s:update()
	call nvim_buf_clear_namespace(0, s:namespace, 1, -1)
	for l:Callback in s:callbacks
		call nvim_buf_set_virtual_text(0, s:namespace, line('.')-1, [[l:Callback(), "comment"]], {})
	endfor
	redraw!
endfun

au CursorMoved * call <SID>update()
au CursorMovedI * call <SID>update()
