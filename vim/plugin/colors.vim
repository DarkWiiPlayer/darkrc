let g:only_generic_hl=1

function! s:term_bg_color()
	let l:num_color=synIDattr(hlID("normal"), "bg")
	if $TERM=="xterm-kitty" || $KITTY_LISTEN_ON != ""
		if l:num_color!=""
			if match(l:num_color, "^\\d\\{3}$")==0
				let l:color=system("kitty @ --to $KITTY_LISTEN_ON get-colors | grep 'color".l:num_color."'")
				let l:color=l:color[match(l:color, "#"):]
			elseif match(l:num_color, "^#\\x\\{6}$")==0
				let l:color=l:num_color
			end
			call jobstart('kitty @ --to $KITTY_LISTEN_ON set-colors background="'.l:color.'"')
			call jobstart("cat ".$HOME."/darkrc/kitty_".&bg.".conf | grep cursor | sed -e 's/ /=/' | xargs -L 1 kitty @ --to $KITTY_LISTEN_ON set-colors")
		end
	end
endfun

augroup termcolors
	au ColorScheme * call <SID>term_bg_color()
augroup END

function! s:term_bg_color_reset()
	if $TERM=="xterm-kitty" || $KITTY_LISTEN_ON != ""
		if filereadable($HOME."/.dark")
			let l:file = $HOME."/darkrc/kitty_dark.conf"
		else
			let l:file = $HOME."/darkrc/kitty_light.conf"
		end
		call system("kitty @ --to ".$KITTY_LISTEN_ON." set-colors ".l:file)
	end
endfun

augroup termcolors
	au VimLeavePre * call <SID>term_bg_color_reset()
augroup END
