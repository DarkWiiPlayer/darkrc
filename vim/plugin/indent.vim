if exists("$EXPANDTAB")
	set expandtab
else
	set noexpandtab
end

if exists("$TABSTOP")
	let &tabstop=str2nr($TABSTOP)
else
	set tabstop=3
end

" Just use the value of &tabstop
set shiftwidth=0
" I use proper tabstop anyway
set softtabstop=0
" Don't use shiftwidth for indentation
set nosmarttab
set autoindent
set smartindent
set smarttab
