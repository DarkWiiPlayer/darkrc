augroup RUBY
	if b:undo_ftplugin
	  let b:undo_ftplugin .= " | "
	else 
	  let b:undo_ftplugin = ""
	end
	let b:undo_ftplugin .= "augroup RUBY | au! | augroup END"

	comm! -buffer AsyncLint call AsyncLint(bufnr("%"), b:linter)
	let b:undo_ftplugin .= " | delcommand AsyncLint"
	comm! -buffer Lint silent exec "%!".b:linter->substitute("$0", "\\\\$0", "g")
	let b:undo_ftplugin .= " | delcommand Lint"

	let b:linter = "sh -c \"rubocop --auto-correct -o /dev/null --stdin . 2>/dev/null | awk 'BEGIN { header=0 } // && header==1 { print $0 } /^====================$/ { header=1 }'\""
	let b:undo_ftplugin .= " | unlet b:linter"

	au InsertLeave <buffer> AsyncLint
"	au CursorHoldI <buffer> AsyncLint
augroup END
