function s:exit(code, buffer, start, end, callbacks)
	if len(a:callbacks)>1
		let [l:Success, l:Error] = a:callbacks
	elseif len(a:callbacks)>0
		let l:Success = a:callbacks[0]
		let l:Error = a:callbacks[0]
	else
		let l:Success = { a -> a }
		let l:Error = { a -> a }
	end
	if (a:code == 0)
		return l:Success({"output": a:buffer, "tstart": a:start, "tend": a:end, "code": a:code})
	else
		return l:Error({"output": a:buffer, "tstart": a:start, "tend": a:end, "code": a:code})
	endif
endfun

function Defer(command, ...)
	let l:start = strftime("%s")
	let l:buffer = []
	let l:callbacks = a:000
	if has("nvim")
		call jobstart(a:command, {
			\ "out_io": "pipe",
			\ "on_stdout": { pipe, text -> extend(l:buffer, text) },
			\ "on_stderr": { pipe, text -> extend(l:buffer, text) },
			\ "on_exit": { id, code -> <SID>exit(code, l:buffer, l:start, strftime("%s"), l:callbacks) }
		\})
	else
		call job_start(a:command, {
			\ "out_io": "pipe",
			\ "out_cb": { pipe, text -> add(l:buffer, text) },
			\ "close_cb": { pipe -> <SID>exit(0, l:buffer, l:start, strftime("%s"), a:000) }
		\})
	end
endfun

function s:replace(buf, text)
	call nvim_buf_set_lines(a:buf, 0, nvim_buf_line_count(a:buf), 0, a:text)
endfun

function s:expand(string)
	return substitute(a:string, '%[:a-z]*', '\=expand(submatch(0))', 'g')
endfun

function s:echo(message, ...)
	if (a:0 > 0)
		exec "echohl ".a:1
	end
	echom a:message
	if (a:0 > 0)
		echohl None
	end
endfun

function s:scratch(result)
	new
	call nvim_buf_set_lines(0, 0, nvim_buf_line_count(0), 0, a:result["output"])
endfun

function s:notify(message)
	call Defer('notify-send "Vim" "'.a:message.'"', { b -> 0 })
endfun

comm -complete=shellcmd -nargs=* Defer call Defer(s:expand(<q-args>))
comm -complete=shellcmd -nargs=* DeferEcho call Defer(s:expand(<q-args>), { result -> <SID>echo("Deferred job completed (".(result['tend']-result['tstart'])."s): ".s:expand(<q-args>)) }, { result -> <SID>echo("Deferred job errored with ".result['code']." (".(result['tend']-result['tstart'])."s): ".s:expand(<q-args>), 'WarningMsg') })
comm -complete=shellcmd -nargs=* DeferNotify call Defer(s:expand(<q-args>), { result -> <SID>notify("Deferred job completed (".(result['tend']-result['tstart'])."s):\n$ ".s:expand(<q-args>)) }, { result -> <SID>notify("Deferred job errored with ".result['code']." (".(result['tend']-result['tstart'])."s):\n$ ".s:expand(<q-args>)) })
comm -complete=shellcmd -nargs=* DeferScratch call Defer(s:expand(<q-args>), function("<SID>scratch"))
comm -complete=shellcmd -count=0 -nargs=* DeferBuffer call Defer(s:expand(<q-args>), { result -> <SID>replace(<count>, result['output']) })
