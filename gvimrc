set guioptions-=T
set guioptions-=m
set guioptions-=e

set cursorline " Highlight cursor line

function! SetFont()
	if exists("g:font_size_template") && exists("g:font_size")
		let &guifont=substitute(g:font_size_template, "%%", g:font_size, "g")
	end
endfun
function! SetFontSize(size)
	let g:font_size=a:size
	call SetFont()
endfun
