function s:loadState(state)
	for name in keys(a:state)
		exec "let" name.'="'.a:state[name].'"'
	endfor
endfun

function s:dumpState(state)
	let l:newstate = {}
	for name in keys(a:state)
		exec "let l:newstate[\"".name."\"]=".name
	endfor
	return l:newstate
endfun

let s:state = { "&number": "0", "&relativenumber": "0", "&colorcolumn": "0", "&laststatus": "0", "&fillchars": "eob:\\ " }

function Zen()
	if exists("g:zenState")
		call s:loadState(g:zenState)
		unlet g:zenState
	else
		let g:zenState = s:dumpState(s:state)
		call s:loadState(s:state)
	end
endfun

command! Zen call Zen()

nnoremap <F12> :Zen<CR>
