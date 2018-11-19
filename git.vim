"  ┌─────────────────┐
"  └─┬─┬───┬─┬───┬─┬─┘
"    │ │   │ │   │ │
"    │ │   │ │   │ │
"  ┌─┴─┴───┴─┴───┴─┴─┐
" ┌┘    Git Stuff    └┐
" └───────────────────┘

function! s:gitroot()
	let s:ret = substitute(system('git rev-parse --show-toplevel'), '\n\_.*', '', '')
	if v:shell_error
		throw s:ret
	else
		return s:ret
	end
endf

function! s:git_history()
	if exists("b:git_history")
		if b:git_history[0]+10 > localtime()
			return b:git_history[1]
		end
	end

	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
	else
		let l:fname = substitute(expand("%"), "\\\\", "/", "g")
	end
	let l:commits = system('git log --format="%h" '.l:fname)
	let l:hist = split(l:commits, "\n")
	let b:git_history = [localtime(), l:hist]

	return l:hist
endfun

function! s:git_first()
	if &modified
		echo "Save your changes first!"
		return
	end
	let l:history = s:git_history()
	call s:file_at_revision(get(l:history, -1))
endfun

function! s:git_last()
	if &modified
		echo "Save your changes first!"
		return
	end
	let l:history = s:git_history()
	call s:file_at_revision(get(l:history, 1, "HEAD"))
endfun

function! s:git_info()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echo "Not a file@revision buffer!"
		return
	end
	echo system("git show --no-patch ".b:git_revision_hash)
endfun

function! s:git_next()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echo "Error 01: Not a file@revision buffer!"
		return
	end
	let l:history = s:git_history()
	let l:idx = index(l:history, b:git_revision_hash)
	if l:idx == -1
		echo "Error 02"
		return
	end
	let l:new_revision = get(l:history, l:idx-1, "LAST")
	if l:new_revision=="LAST"
		echo "Already at latest revision! ".l:new_revision
		return
	else
		call s:file_at_revision(l:new_revision)
	end
endfun

function! s:git_prev()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		let l:new_revision = s:git_history()[0]
	else
		let l:history = s:git_history()
		let l:idx = index(l:history, b:git_revision_hash)
		if l:idx == -1
			echo "Error 03: cannot find revision ".b:git_revision_hash
			return
		end
		let l:new_revision = get(l:history, l:idx+1, "FIRST")
	end
	if l:new_revision=="FIRST"
		echo "Already at earliest revision! ".l:new_revision
		return
	else
		call s:file_at_revision(l:new_revision)
	end
endfun

function! s:file_at_revision(rev)
	let l:pos = getpos(".")
	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
		let l:ftail = fnamemodify(b:git_original_file, ":t")
	else
		let l:fname = expand("%")
		let l:ftail = expand("%:t")
	end
	let l:fname = substitute(l:fname, "\\\\", "/", "g")
	let l:ftype = &filetype

	ene!
	set modifiable
	silent exec "file ".l:ftail."@".a:rev
	exec "r!git show ".a:rev.":".l:fname
	1,1del
	let l:pos[0] = bufnr('.')
	call setpos('.', l:pos)
	setl nomodifiable
	setl buftype=nofile
	setl bufhidden=delete
	let &filetype = l:ftype

	let b:git_original_file = l:fname
	let b:git_revision_hash = a:rev
endfun

function! s:git_diff(...)
	if a:0
		vert bot split
		call s:file_at_revision(a:1)
		diffthis
		au BufUnload <buffer> diffoff!
		exec "normal \<C-w>\<C-p>"
		diffthis
		call s:git_info()
	else
		if exists("b:git_revision_hash")
			call s:git_diff(get(s:git_history(), index(s:git_history(), b:git_revision_hash)+1, "NIL"))
		else
			call s:git_diff(get(s:git_history(), 0, "HEAD"))
		end
	end
endfun

function! s:git_blame()
	let l:name = expand('%')
	let l:line = getpos('.')[1]
	let l:char = getpos('.')[2]+59
	let l:type = &filetype
	enew
	set modifiable
	let &filetype = l:type
	set buftype=nofile
	set bufhidden=delete
	set nowrap
	silent exec "file Blame: ".l:name
	keepjumps exec 'r !git blame '.l:name
	keepjumps 0,0del "
	set nomodifiable
	keepjumps call setpos('.', [0, l:line, l:char, 0])
endfun

command! Blame try
			\| call s:gitroot() | call <sid>git_blame()
			\| catch | echo 'Not a git repo!'
			\| endtry
command! GitNext try
			\| call s:gitroot() | call <sid>git_next() | call s:git_info()
			\| catch | echo 'Not a git repo!'
			\| endtry
command! GitPrev call <sid>git_prev() | call s:git_info()
command! GitFirst call <sid>git_first() | call s:git_info()
command! GitLast call <sid>git_last() | call s:git_info()
command! GitInfo call <sid>git_info()
command! -nargs=1 GitCheckout call <sid>file_at_revision(<f-args>)
command! -nargs=? GitCompare try
			\| call s:gitroot() | call <sid>git_diff(<f-args>)
			\| catch | echo 'Not a git repo!' 
			\| endtry
command! Uncommited try
			\| call s:gitroot() | call <sid>git_diff()
			\| catch | echo 'Not a git repo!' 
			\| endtry
command! GitRoot try
			\| echo <sid>gitroot() 
			\| catch | echo 'Not a git repository'
			\| endtry
