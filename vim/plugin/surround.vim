" ┌──────────┐
" │ Funtions │
" └──────────┘

function! s:vsurround(left, right)
	if visualmode() ==# "v"
		let l:type="char"
	elseif visualmode() ==# "V"
		let l:type="line"
	elseif visualmode() ==# ""
		let l:type="block"
	end
	call <SID>surround(l:type, a:left, a:right)
endf

function! s:surround(type, left, right)
	if a:type ==? 'char'
		exec 'normal! `>a'.a:right.'`<i'.a:left
	elseif a:type ==? 'line'
		exec 'normal! `<`>$A'.a:right.'`<`>I'.a:left
	elseif a:type ==? 'block'
		exec 'normal! `<`>A'.a:right.'`<`>I'.a:left
	end
endf

" ┌──────────┐
" │ Mappings │
" └──────────┘

function! s:dquote_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, '"', '"')
endf
nnoremap <leader>" :<C-U>set operatorfunc=<SID>dquote_op<CR>g@
vnoremap <leader>" :<C-U>call <SID>vsurround('"', '"')<CR>

function! s:squote_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "'", "'")
endf
nnoremap <leader>' :<C-U>set operatorfunc=<SID>squote_op<CR>g@
vnoremap <leader>' :<C-U>call <SID>vsurround("'", "'")<CR>

function! s:paren_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "(", ")")
endf
nnoremap <leader>( :<C-U>set operatorfunc=<SID>paren_op<CR>g@
vnoremap <leader>( :<C-U>call <SID>vsurround("(", ")")<CR>

function! s:pracket_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "[", "]")
endf
nnoremap <leader>[ :<C-U>set operatorfunc=<SID>bracket_op<CR>g@
vnoremap <leader>[ :<C-U>call <SID>vsurround("[", "]")<CR>

function! s:brace_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "{", "}")
endf
nnoremap <leader>{ :<C-U>set operatorfunc=<SID>brace_op<CR>g@
vnoremap <leader>{ :<C-U>call <SID>vsurround("{", "}")<CR>

function! s:angle_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "<", ">")
endf
nnoremap <leader>< :<C-U>set operatorfunc=<SID>angle_op<CR>g@
vnoremap <leader>< :<C-U>call <SID>vsurround("<", ">")<CR>

function! s:backtick_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "`", "`")
endf
nnoremap <leader>` :<C-U>set operatorfunc=<SID>backtick_op<CR>g@
vnoremap <leader>` :<C-U>call <SID>vsurround("`", "`")<CR>

function! s:asterisk_op(type)
  normal `[m<`]m>
  call <SID>surround(a:type, "*", "*")
endf
nnoremap <leader>* :<C-U>set operatorfunc=<SID>asterisk_op<CR>g@
vnoremap <leader>* :<C-U>call <SID>vsurround("*", "*")<CR>
