augroup filecolors
autocmd!
" au BufLeave * :colorscheme slate
" au BufEnter *.rb :colorscheme desert
" au BufEnter *.txt :colorscheme morning
" au BufEnter *.vim,.vimrc,_vimrc :colorscheme morning
augroup end

let s:colors=['slate', 'desert', 'blue', 'ron', 'elflord', 'murphy', 'torte']
function! Randomcolor()
	let random = localtime() % len(s:colors)
	execute "colorscheme ".s:colors[random]
endfunction
call Randomcolor()

" Color Stuff
nnoremap <C-F1> :colorscheme slate<CR>
nnoremap <C-F2> :colorscheme desert<CR>
nnoremap <C-F3> :colorscheme blue<CR>
nnoremap <C-F4> :colorscheme ron<CR>

nnoremap <C-F5> :colorscheme peachpuff<CR>
nnoremap <C-F6> :colorscheme morning<CR>
nnoremap <C-F7> :colorscheme delek<CR>
nnoremap <C-F8> :colorscheme shine<CR>

nnoremap <C-F9> :colorscheme elflord<CR>
nnoremap <C-F10> :colorscheme murphy<CR>
nnoremap <C-F11> :colorscheme torte<CR>
nnoremap <C-F12> :call Randomcolor()<CR>
