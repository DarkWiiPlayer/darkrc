" vim: set noexpandtab :miv "
"    ┌─────────────────┐    "
"    └─┬─┬───┬─┬───┬─┬─┘    "
"      │ │   │ │   │ │      "
"      │ │   │ │   │ │      "
"    ┌─┴─┴───┴─┴───┴─┴─┐    "
"   ┌┘    Git Stuff    └┐   "
"   └───────────────────┘   "

" Find the root of a git repository
function! s:gitroot()
	let l:ret = substitute(system('git rev-parse --show-toplevel'), '\n\_.*', '', '')
	if v:shell_error
		throw l:ret
	else
		return l:ret
	end
endf

function! s:cd_git_root(path)
	let l:path = fnamemodify(a:path, ':p')
	let l:wd = getcwd()
	if isdirectory(l:path)
		exec 'cd '.a:path
	elseif filereadable(l:path)
		exec 'cd '.fnamemodify(l:path, ':h')
	else
		return 0
	endif
	let l:ret = substitute(system('git rev-parse --show-toplevel'), '\n\_.*', '', '')
	if v:shell_error
		exec 'cd '.l:wd
		return 0
	else
		exec 'cd '.l:ret
		return l:ret
	end
endf

" Returns an array containing chronologically sorted commits
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
		throw "File has unsaved modifications!"
	end
	call s:file_at_revision(get(s:git_history(), -1))
endfun

function! s:git_last()
	if &modified
		throw "File has unsaved modifications!"
	end
	call s:file_at_revision(get(s:git_history(), 1, "HEAD"))
endfun

function! s:git_info()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echom "Working copy or not in any repo"
		return 0
	end
	echo system("git show --no-patch ".b:git_revision_hash)
endfun

function! s:git_next()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echom "Error 01: Not a file@revision buffer!"
		return 0
	end
	let l:history = s:git_history()
	let l:idx = index(l:history, b:git_revision_hash)
	if l:idx == -1
		echo "Error 02"
		return
	end
	let l:new_revision = get(l:history, l:idx-1, "LAST")
	if l:new_revision=="LAST"
		throw "Already at last revision!"
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
		throw "Already at earliest revision!"
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
	setl nomodifiable
	setl buftype=nofile
	setl bufhidden=delete
	let &filetype = l:ftype

	let b:git_original_file = l:fname
	let b:git_revision_hash = a:rev

	call setpos('.', l:pos)
endfun

function! s:git_diff(...)
	if a:0
		let l:wd = getcwd()
		call s:cd_git_root(expand('%'))
		split
		call s:file_at_revision(a:1)
		diffthis
		au BufUnload <buffer> diffoff!
		exec "normal \<C-w>\<C-p>"
		diffthis
		exec "normal \<C-w>\<C-p>"
		exec "cd ".l:wd
	else
		if exists("b:git_revision_hash")
			call s:git_diff(get(s:git_history(), index(s:git_history(), b:git_revision_hash)+1, "NIL"))
		else
			call s:git_diff(get(s:git_history(), 0, "HEAD"))
		end
	end
endfun

function! s:git_blame(first, last)
	let l:input = system('git blame '.expand('%').' --line-porcelain -L '.a:first.','.a:last)
	let l:data = map(split(l:input, '\ze\x\{40} \d\+ \d\+'), {idx, elem -> split(elem, '\n')})
	return map(l:data, {idx, ary -> ary[1][match(ary[1], '\s\+\zs'):]})
endfun

command! -range Blame echom join(uniq(sort(<sid>git_blame(<line1>, <line2>))), ', ')
command! -range DBlame !git blame % -L <line1>,<line2>
command! GitNext try
      \| call <sid>gitroot()
      \| call <sid>git_next()
      \| catch
      \| echo 'Not a git repo!'
      \| endtry
      \| GitInfo
command! GitPrev call <sid>git_prev()
      \| GitInfo
command! GitFirst call <sid>git_first() | call s:git_info()
command! GitLast call <sid>git_last() | call s:git_info()
command! GitInfo call <sid>git_info()
command! -nargs=1 GitCheckout call <sid>file_at_revision(<f-args>)
command! -nargs=? GitCompare try
      \| call s:gitroot() | call <sid>git_diff(<f-args>)
      \| catch
      \| echo 'Not a git repo!' 
      \| endtry
command! Uncommited try
      \| call <sid>git_diff()
      \| catch
      \| echo 'Not a git repo!' 
      \| endtry
command! GitRoot call <SID>cd_git_root('.')
command! ShowGitRoot try
      \| echo <sid>gitroot() 
      \| catch | echo 'Not a git repository'
      \| endtry
