" exec 'hi TabLine' . s:fg_tabline_inactive_fg . s:bg_tabline_inactive_bg . s:ft_none
" exec 'hi TabLineFill' . s:fg_tabline_bg . s:bg_tabline_bg . s:ft_none
" exec 'hi TabLineSel' . s:fg_tabline_active_fg . s:bg_tabline_active_bg . s:ft_none

set laststatus=2
set statusline=%#StatusBar#
set statusline+=%#TabLineSel#
set statusline+=%{&autowriteall?'\ \ 🖬\ ':''}%<
set statusline+=%#TabLine#
set statusline+=%y%t%M%R\ 
set statusline+=%#TabLine#
set statusline+=%{exists(\"b:blame\")?b:blame[min([getcurpos()[1],len(b:blame)])-1][\"short\"]:\"\"}
set statusline+=%#TabLine#
set statusline+=%=
set statusline+=%#TabLine#
set statusline+=%{strlen(@\")}\ 
set statusline+=0x%B\ 
set statusline+=[%l/%L,\ %c%V]\ 
"set statusline+=%#DiffDelete#
set statusline+=%4.P
