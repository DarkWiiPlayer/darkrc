let g:only_generic_hl=1

function! s:wez_color(value)
	let g:__color = a:value
	lua vim.g.__color = vim.base64.encode(vim.g.__color)
	call chansend(v:stderr, "\x1b]1337;SetUserVar=bgcolor=".g:__color."\x07")
endfun

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
	elseif $TERM_PROGRAM=="WezTerm"
		call <SID>wez_color(l:num_color)
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
	elseif $TERM_PROGRAM=="WezTerm"
	end
endfun

augroup termcolors
	au VimLeavePre * call <SID>term_bg_color_reset()
augroup END

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

if filereadable($HOME."/.dark")
	Dark
else
	Light
end

if $TERM=="xterm-kitty" || match($TERM, '-256color$')
	set termguicolors
	if &bg=="dark"
		colorscheme sierra
	else
		colorscheme PaperColor
	end
end
