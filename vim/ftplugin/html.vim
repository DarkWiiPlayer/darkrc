nnoremap <buffer> ; m'A;`'
if b:undo_ftplugin
  let b:undo_ftplugin .= "unmap <buffer> ;"
else 
  let b:undo_ftplugin = ""
end
let b:undo_ftplugin .= "| unmap <buffer> ;"
