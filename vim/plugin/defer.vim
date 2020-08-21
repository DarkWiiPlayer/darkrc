function Defer(command, callback)
	let l:buffer = []
	call job_start(a:command, {
	\ "out_io": "pipe",
	\ "out_cb": { pipe, text -> add(l:buffer, text) },
	\ "close_cb": { pipe -> a:callback(l:buffer) }
	\ })
endfun

function s:echo(message)
  echom a:message
endfun

function s:notify(message)
  call Defer('notify-send "Vim" "'.a:message.'"', { b -> 0 })
endfun

comm -complete=shellcmd -nargs=* Defer call Defer(<q-args>, { buffer -> 0 })
comm -complete=shellcmd -nargs=* DeferEcho call Defer(<q-args>, { buffer -> <SID>echo("Deferred job completed: ".<q-args>) })
comm -complete=shellcmd -nargs=* DeferNotify call Defer(<q-args>, { buffer -> <SID>notify("Deferred job completed:\n$ ".<q-args>) })
