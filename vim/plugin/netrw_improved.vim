let g:netrw_liststyle=3

let g:netrw_banner=0

let g:netrw_browse_split=4
"	1 - open files in a new horizontal split
"	2 - open files in a new vertical split
"	3 - open files in a new tab
"	4 - open in previous window

"	Netrw window size in %
let g:netrw_winsize = 20

"	Reuse directory listings
let g:netrw_fastbrowse = 1

augroup NETRW
	au!
	au FileType netrw nmap <buffer> l gn:exec("tcd ".b:netrw_curdir)<CR>
	au FileType netrw nmap <buffer> h -:exec("tcd ".b:netrw_curdir)<CR>
	au FileType netrw nmap <buffer> <space> <CR>
	au FileType netrw nmap <nowait> <buffer> q :q<CR>
	au FileType netrw set winfixwidth
augroup END

function s:vex()
  let netrw_windows = getwininfo()
        \->filter({ k,v -> v["variables"]->has_key("netrw_treedict") })
        \->filter({ k,v -> v["tabnr"]==tabpagenr() })
  if netrw_windows->len() > 0
    call win_gotoid(netrw_windows[0]["winid"])
  else
    Vex .
  end
endfun

nnoremap <leader><space> :call <SID>vex()<CR>
