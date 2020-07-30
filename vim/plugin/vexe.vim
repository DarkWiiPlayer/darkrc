" --- VISUAL EXECUTE ---
let $LUA_PATH=expand('<sfile>:p:h:h')."/lua/?.lua;;"
let g:exe_prg = 'lua -e "vim=require[[vim]]" -'
vnoremap <CR> :<C-U>exec "'<,'>!".g:exe_prg<CR>
inoremap <C-Space> <C-[>0v$:<C-U>exec "'<,'>!".g:exe_prg<CR>
