augroup train
  autocmd!
	au BufWritePost * echom 'Really tho?'
  au InsertEnter * let b:undo=undotree()['seq_last']
augroup END
inoremap  :silent exec 'undo '.b:undo<CR>
