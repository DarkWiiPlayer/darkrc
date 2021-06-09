" vim: set noexpandtab :miv "
"    ┌─────────────────┐    "
"    └─┬─┬───┬─┬───┬─┬─┘    "
"      │ │   │ │   │ │      "
"      │ │   │ │   │ │      "
"    ┌─┴─┴───┴─┴───┴─┴─┐    "
"   ┌┘    Git Stuff    └┐   "
"   └───────────────────┘   "

augroup git

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
	let l:path = fnamemodify(expand(a:path), ':p')
	let l:wd = getcwd()
	if isdirectory(l:path)
		exec 'cd '.a:path
	elseif filereadable(l:path)
		exec 'cd '.fnamemodify(l:path, ':h')
	else
		throw 'Invalid Path'
	endif
	let l:ret = substitute(system('git rev-parse --show-toplevel'), '\n\_.*', '', '')
	if v:shell_error
		exec 'cd '.l:wd
		throw 'Not a git repo!'
	else
		exec 'cd '.l:ret
		return l:ret
	end
endf

function! s:init_file()
	if !exists("b:git_original_file")
		let l:git_original_file = substitute(expand("%"), "\\\\", "/", "g")
		let l:git_revision_hash = system("git")
	end
endfun

function! s:previous_commit()
	" TODO: Refactor this block into s:git_init_buffer() and set buffer
	" variables instead.
	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
		let l:revision = b:git_revision_hash
	else
		let l:fname = substitute(expand("%"), "\\\\", "/", "g")
		let l:revision = 'HEAD'
	end
	let l:commit = system('git log --format="%h" -1 '.l:revision.'~1 '.l:fname)

	return substitute(l:commit, "\n", "", "")
endfun

function! s:next_commit()
	" TODO: See previous_commit()
	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
		let l:revision = b:git_revision_hash
	else
		let l:fname = substitute(expand("%"), "\\\\", "/", "g")
		let l:revision = 'HEAD'
	end
	let l:commit = system('git log --format="%h" '.l:revision.'..HEAD '.l:fname.' | tail -2 | head -1')

	return substitute(l:commit, "\n", "", "")
endfun

function! s:git_first()
	" FIXME: Broken after removing git_history;
	" see TODO in previous_commit()
	if &modified
		throw "File has unsaved modifications!"
	end
	call s:file_at_revision(get(s:git_history(), -1))
endfun

function! s:git_last()
	" FIXME: Broken after removing git_history;
	" see TODO in previous_commit()
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
	let l:next = s:next_commit()
	if l:next == ""
		exec 'e! '.b:git_original_file
		echom "No newer versions available! (Loading working copy) 😱"
	else
		call s:file_at_revision(l:next)
	end
endfun

function! s:git_prev()
	let l:next = s:previous_commit()
	if l:next == ""
		echom "No older versions available! 😱"
	else
		call s:file_at_revision(l:next)
	end
endfun

function! s:go_blame()
	if exists("b:blame")
		let l:next = b:blame[min([getcurpos()[1], len(b:blame)])-1]["commit"]
		if exists("b:git_revision_hash") && l:next == b:git_revision_hash
			echom "No older versions available! 😱"
		else
			call s:file_at_revision(l:next)
		end
	else
		throw "Not a git buffer!"
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
	exec "r!git show ".a:rev.":".system("git ls-files --full-name ".l:fname)
	1,1del
	setl nomodifiable
	setl buftype=nofile
	setl bufhidden=delete
	let &filetype = l:ftype

	let b:git_original_file = l:fname
	let b:git_revision_hash = a:rev

	try
		let b:blame=s:git_blame("","")
	catch
		unlet! b:blame
	endtry

	call setpos('.', l:pos)
endfun

function s:split_blame_entry(idx, entry)
	let l:map = {}
	for l:pair in split(a:entry, "\n")[1:]
		let l:split = match(l:pair, " ")
		let l:map[l:pair[:l:split-1]] = l:pair[l:split+1:]
	endfor
	let l:map["commit"]=a:entry[:match(a:entry, " ")-1]
	let l:map["time"]=strftime("%Y-%m-%d %H:%M:%S", l:map["committer-time"])
	let l:map["date"]=strftime("%Y-%m-%d", l:map["committer-time"])
	if l:map["author"]=="Not Committed Yet"
		let l:map["short"]="(Uncommitted)"
	else
		let l:map["short"]=l:map["commit"][:6]." ".l:map["time"]." ".l:map["author"]
	end
	return l:map
endfun
let s:split_blame_entry_ref = funcref("s:split_blame_entry")

function! s:git_blame(first, last)
	if exists("b:git_revision_hash")
		let l:revision = b:git_revision_hash
		let l:name = b:git_original_file
	else
		let l:revision = ""
		let l:name = expand("%")
	end
	if a:first.a:last == ""
		let l:command = 'git blame '.l:revision.' --line-porcelain -- '.l:name
	else
		let l:command = 'git blame '.l:revision.' --line-porcelain -L '.a:first.','.a:last.' -- '.l:name
	end
	let l:input = system(l:command)
	if v:shell_error
		throw v:shell_error
	else
		let l:split = split(l:input, '\n\t[^\n]*\n')
		let l:array = map(l:split, s:split_blame_entry_ref)
		return l:array
	end
endfun

function! s:git_root_to_path()
	let l:root = substitute(system('git rev-parse --show-toplevel'), '\n\_.*', '', '')
	if !v:shell_error
		let &path.=','.l:root.'/**'
	end
endfun

call s:git_root_to_path()

function! s:blame_command(what, line1, line2)
	let l:what=tolower(a:what)
	if l:what=="date"
		echom join(uniq(sort(map(<sid>git_blame(a:line1, a:line2), { i,a -> a["date"] }))), ', ')
	elseif l:what=="adate"
		echom join(uniq(sort(map(<sid>git_blame(a:line1, a:line2), { i,a -> a["author"]." @ ".a["date"] }))), ', ')
	elseif l:what=="mail"
		echom join(uniq(sort(map(<sid>git_blame(a:line1, a:line2), { i,a -> a["committer-mail"] }))), ', ')
	elseif l:what=="author" || l:what==""
		echom join(uniq(sort(map(<sid>git_blame(a:line1, a:line2), { i,a -> a["author"] }))), ', ')
	else
		throw "Don't know what '".a:what."' is!"
	end
endfun

au BufReadPost  * try | let b:blame=<SID>git_blame("","") | catch | unlet! b:blame | endtry
au BufWritePost * try | let b:blame=<SID>git_blame("","") | catch | unlet! b:blame | endtry

command! -nargs=? SplitBlame exec
	\| exec 'normal m"gg'
	\| set cursorbind scrollbind
	\| vert bel split
	\| exec 'Scratch blame'
	\| set cursorbind scrollbind
	\| exec 'r !git blame #'
	\| 1delete 1
	\| silent %s/ *+.*$//
	\| silent %s/(//
	\| silent %s/^\(\x\{8}\) \(.*\)$/\2 \1/
	\| silent %s/^.*0\{8}$//
	\| call matchadd('Comment', '\x\+$')
	\| call matchadd('Comment', '\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}')
	\| call matchadd('Todo', <q-args>)
	\| vertical resize 50
	\| exec "normal h"
	\| exec 'normal `"'

command! -range -nargs=? Blame call <SID>blame_command(<q-args>, <line1>, <line2>)
command! -range DBlame !git blame % -L <line1>,<line2>
command! GitNext call <sid>git_next()
		\| GitInfo
command! GitPrev call <sid>git_prev()
		\| GitInfo
command! GitGoBlame call <sid>go_blame()
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
command! GitRoot call <SID>cd_git_root('%')
command! GitOrig exec 'e '.b:git_original_file
command! ShowGitRoot try
		\| echo <sid>gitroot() 
		\| catch | echo 'Not a git repository'
		\| endtry

augroup END
