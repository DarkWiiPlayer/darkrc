set guioptions-=T
set guioptions-=m
set guioptions-=e

set cursorline " Highlight cursor line

if has("unix")
  let g:font_temp="\\\\\\@<! \\zs\\d\\+"
elseif has("win32")
  let g:font_temp=".*:h\\zs\\d\\+"
  set linespace=0
end
let s:fontsize = match(&guifont, "")

function! SetFontSize(size)
	if exists("g:font_temp")
		let &guifont=substitute(&guifont, g:font_temp, a:size, "g")
	end
endfun

" Override using ranger for picking files
nnoremap <leader><space> :e %:p:h<CR>

command! -nargs=1 SetFontSize call SetFontSize(<f-args>)
command! ResetFontSize call SetFontSize(s:fontsize)
