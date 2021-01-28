augroup RUBY
	if b:undo_ftplugin
		let b:undo_ftplugin .= " | "
	else 
		let b:undo_ftplugin = ""
	end
	let b:undo_ftplugin .= "augroup RUBY | au! | augroup END"

"	comm! -buffer AsyncLint call AsyncLint(bufnr("%"), substitute(b:linter, "%", expand("%"), "g"))
	comm! -buffer AsyncLint call AsyncLint(bufnr("%"), substitute(substitute(b:linter, "$0", "\\\\$0", "g"), "%", expand("%"), "g"))
	let b:undo_ftplugin .= " | delcommand AsyncLint"
	comm! -buffer Lint silent exec "%!".substitute(substitute(b:linter, "$0", "\\\\$0", "g"), "%", expand("%"), "g")
	let b:undo_ftplugin .= " | delcommand Lint"

	let b:linter = "sh -c \"standardrb --auto-correct -o /dev/null --stdin % 2>/dev/null | awk 'BEGIN { header=0 } // && header==1 { print $0 } /^====================$/ { header=1 }'\""
	let b:undo_ftplugin .= " | unlet b:linter"

	set complete=t,.,kspell,i
	aut BufWritePost <buffer> Defer timeout 5 ripper-tags -R

"	au InsertLeave <buffer> AsyncLint
"	au BufWritePre <buffer> Lint
augroup END
