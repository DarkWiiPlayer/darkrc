" For my patched version of the papercolor theme
let g:only_generic_hl=1

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
