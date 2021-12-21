" For my patched version of the papercolor theme
let g:only_generic_hl=1

function! s:kitty_bg_color()
	if $TERM=="xterm-kitty" || $KITTY_LISTEN_ON != ""
		let l:num_color=synIDattr(hlID("normal"), "bg")
		if l:num_color!=""
			let l:color=system("kitty @ --to $KITTY_LISTEN_ON get-colors | grep 'color".l:num_color."'")
			let l:color=l:color[match(l:color, "#"):]
			call system('kitty @ --to $KITTY_LISTEN_ON set-colors background="'.l:color.'"')
			call system("cat ".$HOME."/darkrc/kitty_".&bg.".conf | grep cursor | sed -e 's/ /=/' | xargs -L 1 kitty @ --to $KITTY_LISTEN_ON set-colors")
		end
	end
endfun

augroup kitty
	au ColorScheme * call <SID>kitty_bg_color()
augroup END

function! s:kitty_bg_color_reset()
	if filereadable($HOME."/.dark")
		let l:file = $HOME."/darkrc/kitty_dark.conf"
	else
		let l:file = $HOME."/darkrc/kitty_light.conf"
	end
	call system("kitty @ --to ".$KITTY_LISTEN_ON." set-colors ".l:file)
endfun

if $TERM=="xterm-kitty" || $KITTY_LISTEN_ON != ""
	augroup kitty
		au VimLeavePre * call <SID>kitty_bg_color_reset()
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

if $TERM=="xterm-kitty" || match($TERM, '-256color$')
	Arcadia
end
