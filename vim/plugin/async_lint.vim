function s:async_lint_done(bufnr, buffer)
	if getbufvar(a:bufnr, "lint_job")!=""
		call getbufvar(a:bufnr, "")
		let l:pos = getcurpos()
		call deletebufline(bufname(a:bufnr), 1, "$")
		for line in a:buffer
			call appendbufline(bufname(a:bufnr), "$", line)
		endfor
		call deletebufline(bufname(a:bufnr), 1)
		call setpos(".", l:pos)
		call setbufvar(a:bufnr, "lint_job", "")
	end
endfun

function s:async_lint_abort(bufnr)
	let l:job = getbufvar(a:bufnr, "lint_job")
	if l:job!=""
		call job_stop(l:job)
	end
	call setbufvar(a:bufnr, "lint_job", "")
endfun

function AsyncLint(bufnr, command)
	if getbufvar(a:bufnr, "lint_job")==""
		let l:buffer = []
		let l:job = job_start(a:command, {
		\ "in_io": "buffer", "in_name": bufname(a:bufnr),
		\ "out_io": "pipe",
		\ "out_cb": { pipe, text -> add(l:buffer, text) },
		\ "close_cb": { pipe -> s:async_lint_done(a:bufnr, l:buffer) }
		\ })
		call setbufvar(a:bufnr, "lint_job", l:job)
	end
endfun

augroup ASYNC_LINT
	au TextChanged * call s:async_lint_abort(bufnr("%"))
	au TextChangedI * call s:async_lint_abort(bufnr("%"))
	au TextChangedP * call s:async_lint_abort(bufnr("%"))
augroup END

