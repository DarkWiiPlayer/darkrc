function Defer(command, callback)
	let l:buffer = []
	call job_start(a:command, {
	\ "out_io": "pipe",
	\ "out_cb": { pipe, text -> add(l:buffer, text) },
	\ "close_cb": { pipe -> a:callback(l:buffer) }
	\ })
endfun

comm -complete=shellcmd -nargs=* Defer call Defer(<q-args>, { buffer -> 0 })
