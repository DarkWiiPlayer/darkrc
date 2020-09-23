function s:jobstart(command, options)
  if has("nvim")
    let a:options["on_exit"] = a:options["close_cb"]
    return jobstart(a:command, a:options)
  else
    return job_start(a:command, a:options)
  end
endfun

function Defer(command, callback)
  let l:start = strftime("%s")
	let l:buffer = []
	call s:jobstart(a:command, {
	\ "out_io": "pipe",
	\ "out_cb": { pipe, text -> add(l:buffer, text) },
  \ "close_cb": { pipe -> a:callback({"output": l:buffer, "tstart": l:start, "tend":strftime("%s")}) }
	\ })
endfun

function s:echo(message)
  echom a:message
endfun

function s:notify(message)
  call Defer('notify-send "Vim" "'.a:message.'"', { b -> 0 })
endfun

comm -complete=shellcmd -nargs=* Defer call Defer(<q-args>, { r -> 0 })
comm -complete=shellcmd -nargs=* DeferEcho call Defer(<q-args>, { result -> <SID>echo("Deferred job completed (".(result['tend']-result['tstart'])."s): ".<q-args>) })
comm -complete=shellcmd -nargs=* DeferNotify call Defer(<q-args>, { result -> <SID>notify("Deferred job completed (".(result['tend']-result['tstart'])."s):\n$ ".<q-args>) })
