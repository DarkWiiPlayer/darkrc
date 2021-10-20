" --- VISUAL EXECUTE ---
let g:exe_prg = 'lua'
vnoremap <CR> :<C-U>exec "'<,'>!".g:exe_prg<CR>
