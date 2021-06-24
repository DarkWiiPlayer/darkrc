function s:async_lint_done(bufnr, buffer)
	if getbufvar(a:bufnr, "lint_job")!=""
		call getbufvar(a:bufnr, "")
		let l:pos = getcurpos()
		call deletebufline(bufname(a:bufnr), 1, "$")
		for line in a:buffer[0:-2]
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
		let l:job = jobstart(a:command, {
		\	"on_stdout": { id, text -> s:async_lint_done(a:bufnr, text) },
		\	"stdout_buffered": 1,
		\})
		call chansend(l:job, getline(1, line("$")))
		call chanclose(l:job, "stdin")
		call setbufvar(a:bufnr, "lint_job", l:job)
	end
endfun

augroup ASYNC_LINT
	au TextChanged * call s:async_lint_abort(bufnr("%"))
	au TextChangedI * call s:async_lint_abort(bufnr("%"))
	if has("nvim")
		au TextChangedP * call s:async_lint_abort(bufnr("%"))
	endif
augroup END
