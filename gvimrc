set guioptions-=T
set guioptions-=m
set guioptions-=e

set cursorline " Highlight cursor line

if !exists("g:colors")
	let g:colors=['slate', 'desert', 'blue', 'ron', 'elflord', 'murphy', 'torte']
end
function! Randomcolor()
	let random = localtime() % len(g:colors)
	execute "colorscheme ".g:colors[random]
endfunction

function! SetFont()
	if exists("g:font_size_template") && exists("g:font_size")
		let &guifont=substitute(g:font_size_template, "%%", g:font_size, "g")
	end
endfun
function! SetFontSize(size)
	let g:font_size=a:size
	call SetFont()
endfun

" Color list can be extended after including (sourcing) this file with
" :let g:colors = extend(['list', 'of', 'color', 'schemes'], g:colors)

" Color Stuff
nnoremap <C-F1>  :exe "colorscheme ".g:colors[0 % len(g:colors)]<CR>
nnoremap <C-F2>  :exe "colorscheme ".g:colors[1 % len(g:colors)]<CR>
nnoremap <C-F3>  :exe "colorscheme ".g:colors[2 % len(g:colors)]<CR>
nnoremap <C-F4>  :exe "colorscheme ".g:colors[3 % len(g:colors)]<CR>

nnoremap <C-F5>  :exe "colorscheme ".g:colors[4 % len(g:colors)]<CR>
nnoremap <C-F6>  :exe "colorscheme ".g:colors[5 % len(g:colors)]<CR>
nnoremap <C-F7>  :exe "colorscheme ".g:colors[6 % len(g:colors)]<CR>
nnoremap <C-F8>  :exe "colorscheme ".g:colors[7 % len(g:colors)]<CR>

nnoremap <C-F9>  :exe "colorscheme ".g:colors[8 % len(g:colors)]<CR>
nnoremap <C-F10> :exe "colorscheme ".g:colors[9 % len(g:colors)]<CR>
nnoremap <C-F11> :exe "colorscheme ".g:colors[10 % len(g:colors)]<CR>
nnoremap <C-F12> :call Randomcolor()<CR>
