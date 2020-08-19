" For my patched version of the papercolor theme
let g:only_generic_hl=1

function! s:kitty_bg_color()
	if $TERM=="xterm-kitty"
		let l:num_color=synIDattr(hlID("normal"), "bg")
		if l:num_color!=""
			let l:color=system("kitty @ get-colors | grep 'color".l:num_color." '")
			let l:color=l:color[match(l:color, "#"):]
			echom system("kitty @ set-colors background=".l:color)
		end
	end
endfun
augroup kitty
	au ColorScheme * call <SID>kitty_bg_color()
augroup END

if $TERM=="xterm-kitty"
	augroup kitty
		call system("which updatecolors")
		if v:shell_error
			let s:kitty_bg=system("kitty @ get-colors | grep ^background")
			let g:kitty_bg=s:kitty_bg[match(s:kitty_bg, "#"):]
			au VimLeavePre * echom system("kitty @ set-colors background=".g:kitty_bg)
		else
			au VimLeavePre * call system("updatecolors")
		end
	augroup END
end

com! Dark silent! let g:colors_name_bak = g:colors_name
	\ | let g:ayucolor="dark"
	\ | let g:arcadia_Daybreak=0
	\ | let g:arcadia_Midnight=1
	\ | let g:alduin_Shout_Become_Ethereal=1
	\ | set bg=dark
	\ | silent! exec "colorscheme ".g:colors_name_bak
	\ | silent! delc PaperColor
com! Light silent! let g:colors_name_bak = g:colors_name
	\ | let g:ayucolor="light"
	\ | let g:arcadia_Daybreak=1
	\ | let g:arcadia_Midnight=0
	\ | let g:alduin_Shout_Become_Ethereal=0
	\ | set bg=light
	\ | silent! exec "colorscheme ".g:colors_name_bak
	\ | silent! delc PaperColor

" Commands for some colorschemes I often use
com! Ayu colorscheme ayu
com! Arcadia colorscheme arcadia
com! Alduin colorscheme alduin
com! Moria colorscheme moria
com! Molokai colorscheme molokai
com! Iceberg colorscheme iceberg
com! Papercolor colorscheme PaperColor | delc PaperColor
com! Firewatch colorscheme two-firewatch

if filereadable($HOME."/.dark")
	Dark
else
	Light
end

if $TERM=="xterm-kitty"
  Arcadia
end
