set guioptions-=T
set guioptions-=m
set guioptions-=e

set cursorline " Highlight cursor line

let g:only_generic_hl=1

com! Dark silent! let g:colors_name_bak = g:colors_name
      \ | set bg=dark
      \ | let ayucolor="dark"
      \ | let g:arcadia_Daybreak=0
      \ | let g:arcadia_Midnight=1
      \ | let g:alduin_Shout_Become_Ethereal=1
      \ | silent! exec "colorscheme ".g:colors_name_bak
      \ | silent! delc PaperColor
com! Light silent! let g:colors_name_bak = g:colors_name
      \ | set bg=light
      \ | let ayucolor="light"
      \ | let g:arcadia_Daybreak=1
      \ | let g:arcadia_Midnight=0
      \ | let g:alduin_Shout_Become_Ethereal=0
      \ | silent! exec "colorscheme ".g:colors_name_bak
      \ | silent! delc PaperColor

com! Ayu colorscheme ayu
com! Arcadia colorscheme arcadia
com! Alduin colorscheme alduin
com! Moria colorscheme moria
com! Molokai colorscheme molokai
com! Iceberg colorscheme iceberg
com! Papercolor colorscheme papercolor | delc PaperColor
com! Firewatch colorscheme two-firewatch

if !exists('g:colors_name')
  if &diff
    Moria
  else
    Dark
    Ayu
  end
end

if has("unix")
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

command! -nargs=1 SetFontSize call SetFontSize(<f-args>)
command! ResetFontSize call SetFontSize(s:fontsize)
