" vim: set bufhidden=delete list noexpandtab :miv "
"!!! makes use of marker '

set nocompatible
""""""""""""""""

" Sessions
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages
set foldmethod=marker

" some conditional configs
if has('mouse')
	set mouse=a
endif

if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch "Highlight search results
endif

if v:version >= 800
	set cm=blowfish2
elseif v:version >= 703
	set cm=blowfish
end

" set linespace=0
set scrolloff=6
set history=50 " keep 50 lines of command line history
set nonumber
" set relativenumber
set langmenu=en_UK
let $LANG = 'en_UK'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
try
	set undodir=$HOME/.vimundo
	set undofile
catch
	echom "Undofile doesn't work :("
endtry
filetype plugin on
filetype indent on
set ruler
set backspace=eol,start,indent
set path+=** " Enable fuzzy search " STAAAAAARS
set wildmenu "Menu for tab completion
set enc=utf8

" Search Stuff
set ignorecase
set smartcase
noh
set incsearch
set lazyredraw
set magic "Who doesn't want to be a vim-wizard?
set showmatch

" Backup and file stuff
set nobackup
set nowb
" set noswapfile
set swapfile

" Indentation, etc.
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set smarttab
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set gdefault

set wrap
au BufEnter,BufRead * set linebreak
set breakat=\ .,{
set display+=lastline
if v:version>=800
	set breakindent
	set breakindentopt=sbr
	au WinNew * set breakindentopt=sbr
	set showbreak=.\ 
else
	set showbreak=+->\ 
end
set listchars=eol:¶,tab:»\ ,trail:.,nbsp:.

set modeline " Allows setting vim options in other files
set statusline=(%n)\ %f\ [%M%R]\ [%Y]%=%l,%c%V\ %4.P
set laststatus=2
set cmdheight=1
set timeoutlen=1200

" Clipboard and Copy/Paste things
if has('unnamedplus') " Allow copying to and from OS clipboard
	set clipboard=unnamedplus
else
	set clipboard=unnamed
end

" === GENERAL UTILITIES ===

" --- TEXT SNIPPETS ---

" -- Global --

if !exists('s:snippets')
	let s:snippets = {}
end

function! s:make_snippet(name, lines)
	let s:snippets[a:name] = a:lines
endfun

function! s:make_snippet_range(name, line_start, line_end)
	call s:make_snippet(a:name, getline(a:line_start, a:line_end))
endfun

function! s:insert_snippet(name)
	for line in get(s:snippets, a:name, [])
		put =line
	endfor
endfun

function! MkSnip(name, str)
	call s:make_snippet(a:name, split(a:str, '\n'))
endfun

command! -nargs=1 Snippet call s:insert_snippet(<f-args>)
command! -range -nargs=1 MkSnippet call s:make_snippet_range(<f-args>, <line1>, <line2>)

" -- Filetype --

if !exists('s:ft_snippets')
	let s:ft_snippets = {}
end

function! s:make_ft_snippet(ft, name, lines)
	if !get(s:ft_snippets, a:ft, 0)
		let s:ft_snippets[a:ft] = {}
	end
	let s:ft_snippets[a:ft][a:name] = a:lines
endfun

function! s:make_ft_snippet_range(ft, name, line_start, line_end)
	call s:make_ft_snippet(a:ft, a:name, getline(a:line_start, a:line_end))
endfun

function! s:insert_ft_snippet(ft, name)
	for line in get(get(s:ft_snippets, a:ft, {}), a:name, [])
		put =line
	endfor
endfun

function! MkFTSnip(ft, name, str)
	call s:make_ft_snippet(a:ft, a:name, split(a:str, '\n'))
endfun

command! -nargs=1 FTSnippet call s:insert_ft_snippet(&filetype, <f-args>)
command! -range -nargs=1 FTMkSnippet call s:make_ft_snippet_range(&filetype, <f-args>, <line1>, <line2>)

" --- AUTO CLOSE ---

function! s:autoClose_HelperOpen(open, close)
	let next_c = getline(".")[col(".")-1]
	if match(next_c, "\s")
		return a:open.a:close."\<Left>"
	else
		return a:open
	end
endfunc

function! s:autoClose_HelperClose(open, close)
	if getline(".")[col(".")-1] ==# a:close
		return "\<Right>"
	elseif getline(line(".")+1)
		if match(getline(line(".")+1), "\M^\s*".escape(a:close, "\\"))
			return "\<Down>\<Home>\<C-o>f".a:close."\<Right>"
		end
	else
		return a:close
	end
endfunc

function! s:autoClose_HelperDouble(open)
	if getline(".")[col(".")-1] ==# a:open " Step over
		return "\<Right>"
	else
		return a:open.a:open."\<left>"
	end
endfunc

function! s:autoClose_HelperEnter()
	if exists("b:autoClose_Pairs")
		let next_c = getline(".")[col(".")-1]
		let prev_c = getline(".")[col(".")-2]

		if (next_c !=# "") && (prev_c !=# "")
			if exists("b:autoClose_Pairs[prev_c]")
				if (next_c ==# b:autoClose_Pairs[prev_c])
					return "\<C-o>m'\<enter>\<C-o>`'\<enter>"
				end
			end
		end
	end
	return "\<enter>"
endfunc

function! s:autoClose_HelperSpace()
	if exists("b:autoClose_Pairs")
		let next_c = getline(".")[col(".")-1]
		let prev_c = getline(".")[col(".")-2]

		if (next_c !=# "") && (prev_c !=# "")
			if exists("b:autoClose_Pairs[prev_c]")
				if (next_c ==# b:autoClose_Pairs[prev_c])
					return "\<space>\<C-o>h\<space>"
				end
			end
		end
	end
	return "\<space>"
endfunc

function! s:autoClose_AddPair(open, close) "TODO: Improve with expand('<sfile>')
	if !exists("b:autoClose_Pairs")
		let b:autoClose_Pairs = {}
	end
	let b:autoClose_Pairs[a:open] = a:close

	if a:open!=#a:close
		exe "inoremap <buffer> <expr> ".a:open." <SID>autoClose_HelperOpen('".a:open."', '".a:close."')"
		exe "inoremap <buffer> <expr> ".a:close." <SID>autoClose_HelperClose('".a:open."', '".a:close."')"
	else
		exe "inoremap <buffer> <expr> ".a:open." <SID>autoClose_HelperDouble('".a:open."')"
	end
	inoremap <buffer> <expr> <enter> <SID>autoClose_HelperEnter()
	inoremap <buffer> <expr> <space> <SID>autoClose_HelperSpace()
endfunc

function! MatchingLines(pattern)
	let list = []
	let pattern = a:pattern
	exec "g/".pattern."/ call add(list, expand('%').'('.line('.').') : '.matchstr(getline('.'), '".pattern."'))"
	return list
endfunc

function! s:mld_helper(list, pattern)
	" Helper function for MatchingLinesDict
	call add(a:list, {'filename': expand("%"), 'lnum': line("."), 'col':	match(getline("."), a:pattern)+1, 'text': matchstr(getline("."), a:pattern)})
endfunc
function! MatchingLinesDict(pattern)
	let list = []
	silent! exec "g/".a:pattern."/ call s:mld_helper(list, a:pattern)"
	return list
endfunc

function! LocationAddLineCol(filename, lnum, text, col)
	call setloclist(0, [{'filename': a:filename, 'lnum': a:lnum, 'desc': a:text, 'col': a:col}], 'a')
endfunction

function! QuickfixAddLineCol(filename, lnum, text, col)
	call setqflist([{'filename': a:filename, 'lnum': a:lnum, 'desc': a:text, 'col': a:col}], 'a')
endfunction

function! LocationAddLine(filename, lnum, text)
	call setloclist(0, [{'filename': a:filename, 'lnum': a:lnum, 'desc': a:text}], 'a')
endfunction

function! QuickfixAddLine(filename, lnum, text)
	call setqflist([{'filename': a:filename, 'lnum': a:lnum, 'desc': a:text}], 'a')
endfunction

" Original implementation: https://stackoverflow.com/a/6271254/4984564
function! VisualSelection()
	if mode()=="v"
		let [line_start, column_start] = getpos("v")[1:2]
		let [line_end, column_end] = getpos(".")[1:2]
	else
		let [line_start, column_start] = getpos("'<")[1:2]
		let [line_end, column_end] = getpos("'>")[1:2]
	end
	if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
		let [line_start, column_start, line_end, column_end] =
		\		[line_end, column_end, line_start, column_start]
	end
	let lines = getline(line_start, line_end)
	if len(lines) == 0
			return ''
	endif
	let lines[-1] = lines[-1][: column_end - 1]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function! StringReverse(str)
	return join(reverse(split(str, ".\\zs")), "")
endfunc

function! ShiftMarker(m,n)
	let [bufn,line,column,offset]=getpos("'".a:m)
	call setpos("'".a:m,[bufn,line,column+a:n,offset])
endfunc

function! ShiftSelection(n)
	call ShiftMarker("<", a:n)
	call ShiftMarker(">", a:n)
endfunc

" Auto-close quickfix list when leaving it
function! s:autobd()
	au! WinLeave <buffer> bd!
endfun

" === GENERAL COMMANDS ===

" General Purpose
command! -range Count echo(<line2>-<line1>+1)
command! Closeall bufdo bdelete
command! Context bufdo bdelete | e .
command! Kontext Context

command! L lopen | set number | set norelativenumber
command! LAddLine call LocationAddLine(expand("%"), line("."), getline("."))
command! QAddLine call QuickfixAddLine(expand("%"), line("."), getline("."))
command! LAddCursor call LocationAddLineCol(expand("%"), line("."), getline("."), col("."))
command! QAddCursor call QuickfixAddLineCol(expand("%"), line("."), getline("."), col("."))

command! Fixme call setloclist(0, MatchingLinesDict("\\c\\<fixme.*"))
command! Todo call setloclist(0, MatchingLinesDict("\\c\\<todo.*"))

command! -nargs=1 LFind call setloclist(0, MatchingLinesDict(<args>))
command! -nargs=1 QFind call setqflist(MatchingLinesDict(<args>))

function! s:hex(...)
	if !(a:000 == [""])
		let l:args = map(copy(a:000), {i,val -> "".val})
	else
		let l:args = []
	end
	if &filetype != "xxd"
		silent exec '%!xxd '.join(l:args, "  ")
		set filetype=xxd
		nnoremap <buffer> i i<ins>
		echo "A witch turned your file into a hexadecimal toad!"
	else
		nunmap <buffer> i
		silent exec '%!xxd -r '.join(l:args, "	")
		filetype detect
		echo "The witch turned your file back into binary data"
	end
endfunction
command! -nargs=* Hex call <sid>hex(<q-args>)

" === GIT STUFF === "

function! s:git_history()
	if exists("b:git_history")
		if b:git_history[0]+10 > localtime()
			return b:git_history[1]
		end
	end

	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
	else
		let l:fname = substitute(expand("%"), "\\\\", "/", "g")
	end
	let l:commits = system('git log --format="%h" '.l:fname)
	let l:hist = split(l:commits, "\n")
	let b:git_history = [localtime(), l:hist]

	return l:hist
endfun

function! s:git_first()
	if &modified
		echo "Save your changes first!"
		return
	end
	let l:history = s:git_history()
	call s:file_at_revision(get(l:history, -1))
endfun

function! s:git_last()
	if &modified
		echo "Save your changes first!"
		return
	end
	let l:history = s:git_history()
	call s:file_at_revision(get(l:history, 1, "HEAD"))
endfun

function! s:git_info()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echo "Not a file@revision buffer!"
		return
	end
	echo system("git show --no-patch ".b:git_revision_hash)
endfun

function! s:git_next()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		echo "Error 01: Not a file@revision buffer!"
		return
	end
	let l:history = s:git_history()
	let l:idx = index(l:history, b:git_revision_hash)
	if l:idx == -1
		echo "Error 02"
		return
	end
	let l:new_revision = get(l:history, l:idx-1, "LAST")
	if l:new_revision=="LAST"
		echo "Already at latest revision! ".l:new_revision
		return
	else
		call s:file_at_revision(l:new_revision)
	end
endfun

function! s:git_prev()
	if !exists("b:git_revision_hash") || !exists("b:git_original_file")
		let l:new_revision = s:git_history()[0]
	else
		let l:history = s:git_history()
		let l:idx = index(l:history, b:git_revision_hash)
		if l:idx == -1
			echo "Error 03: cannot find revision ".b:git_revision_hash
			return
		end
		let l:new_revision = get(l:history, l:idx+1, "FIRST")
	end
	if l:new_revision=="FIRST"
		echo "Already at earliest revision! ".l:new_revision
		return
	else
		call s:file_at_revision(l:new_revision)
	end
endfun

function! s:file_at_revision(rev)
	let l:pos = getpos(".")
	if exists("b:git_original_file") " Is this already a file@revision buffer?
		let l:fname = b:git_original_file
		let l:ftail = fnamemodify(b:git_original_file, ":t")
	else
		let l:fname = expand("%")
		let l:ftail = expand("%:t")
	end
	let l:fname = substitute(l:fname, "\\\\", "/", "g")
	let l:ftype = &filetype

	ene!
	set modifiable
	silent exec "file ".l:ftail."@".a:rev
	exec "r!git show ".a:rev.":".l:fname
	1,1del
	let l:pos[0] = bufnr('.')
	call setpos('.', l:pos)
	setl nomodifiable
	setl buftype=nofile
	setl bufhidden=delete
	let &filetype = l:ftype

	let b:git_original_file = l:fname
	let b:git_revision_hash = a:rev
endfun

function! s:git_diff(...)
	if a:0
		split
		call s:file_at_revision(a:1)
		diffthis
		au BufUnload <buffer> diffoff!
		exec "normal \<C-w>\<C-p>"
		diffthis
		call s:git_info()
	else
		if exists("b:git_revision_hash")
			call s:git_diff(get(s:git_history(), index(s:git_history(), b:git_revision_hash)+1, "NIL"))
		else
			call s:git_diff(get(s:git_history(), 0, "HEAD"))
		end
	end
endfun

function! s:git_blame()
	let l:name = expand('%')
	let l:line = getpos('.')[1]
	let l:char = getpos('.')[2]+59
	let l:type = &filetype
	enew
	set modifiable
	let &filetype = l:type
	set buftype=nofile
	set bufhidden=delete
	set nowrap
	silent exec "file Blame: ".l:name
	keepjumps exec 'r !git blame '.l:name
	keepjumps 0,0del "
	set nomodifiable
	keepjumps call setpos('.', [0, l:line, l:char, 0])
endfun

command! Blame call <sid>git_blame()
command! GitNext call <sid>git_next() | call s:git_info()
command! GitPrev call <sid>git_prev() | call s:git_info()
command! GitFirst call <sid>git_first() | call s:git_info()
command! GitLast call <sid>git_last() | call s:git_info()
command! GitInfo call <sid>git_info()
command! -nargs=1 GitCheckout call <sid>file_at_revision(<f-args>)
command! -nargs=? GitCompare call <sid>git_diff(<f-args>)

" === FILE STUFF ===

function! s:unsaved()
	if &mod
		let l:filetype = &filetype
		diffthis
		below new
		set modifiable
		r #
		1,1del
		diffthis
		au BufUnload <buffer> diffoff!
		let &filetype = l:filetype
		set nomodifiable
		set buftype=nofile
		set bufhidden=delete
		silent exec "file =".expand("#:t")."@".strftime("%H:%M")
		exec "normal \<C-w>k"
		set foldlevel=999
	else
		echom "No changes to show :)"
	end
endfun
command! Unsaved call <sid>unsaved()

function! s:snapshot()
	let l:filetype = &filetype
	let l:clipboard = @"
	let l:pos = getpos(".")

	silent 0,$yank "
	below new
	set modifiable
	silent put "
	1,1del
	let &filetype = l:filetype
	set nomodifiable
	set buftype=nofile
	set bufhidden=hide
	call setpos(".", l:pos)
	silent exec "file ¬".expand("#:t")."@".strftime("%H:%M")

	exec "normal \<C-w>k"
	set foldlevel=999

	let @" = l:clipboard
endfun
command! Snapshot call <sid>snapshot()

command! -nargs=? Scratch new | set buftype=nofile | set filetype=<args>
command! -nargs=? Tempfile exec 'new '.tempname()  | set filetype=<args> | au BufDelete <buffer> call delete(expand('%'))

"        ┌──────────────────────────┐
"        ├─┬──────────────────────┐ │
"        ├─┤ GENERAL KEY MAPPINGS ├─┤
"        │ └──────────────────────┴─┤
"        └──────────────────────────┘

let mapleader = "\\"

" --- Moving Between Buffers ---
nnoremap <leader>n :next<CR>:args<CR>
nnoremap <leader>p :previous<CR>:args<CR>

let g:jmp_dist = 8
map <C-j> :exec "normal ".g:jmp_dist."j"<CR>
map <C-k> :exec "normal ".g:jmp_dist."k"<CR>
" Yes, not 'noremap', do whatever is mapped to J and K assuming
" it is some sort of custom up-down motion, but g:jmp_dist times

" --- Marks ---
nnoremap <leader>m :marks abcdefghijklmnopqrstuvwxyz<CR>
nnoremap <leader>M :marks ABCDEFGHIJKLMNOPQRSTUVWXYZ<CR>

" --- Windows, Tabs and More --
nnoremap <leader><space> :e %:p:h<CR>

" --- modes ---
nnoremap <ins> <ins><ins>

" --- /dev/null ---
noremap <leader>d "_d
noremap <leader>d "_d
noremap <del> "_x
noremap <S-del> 0"_x$

" --- Numbers ---
nnoremap <leader>- <C-x>
nnoremap <leader>= <C-a>

" --- Text ---
nnoremap U ~h

" --- MOVEMENT ---
" noremap j gj
" noremap k gk

noremap gj j
noremap gk k

" --- CLIPBOARD ---
nnoremap Y y$

" --- VISUAL EXECUTE ---
vnoremap <C-CR> ""y<CR>
				\ :call setreg("\"", substitute(getreg("\""), "\n", "", ""), "v")<CR>
				\ :<C-r>"<CR>`<

let $LUA_PATH = system("lua -e 'print(package.path)'").";".expand("<sfile>:p:h")."/lua/?.lua"
let g:mooncompile = "!moonc ".expand("<sfile>:p:h")."/lua"
command! Mooncompile silent exec g:mooncompile
let g:exe_prg = "moonc -- \| lua -l vim -"
vnoremap <CR> :<C-U>exec "'<,'>!".g:exe_prg<CR>
inoremap <C-Space> <C-[>0v$:<C-U>exec "'<,'>!".g:exe_prg<CR>

" --- OTHER ---
" Don't exit visual mode when "shifting"
vnoremap < <gv
vnoremap > >gv

vnoremap <leader>" <C-[>`>a"<C-o>`<"<C-[>:call ShiftSelection(1)<CR>gv
vnoremap <leader>' <C-[>`>a'<C-o>`<'<C-[>:call ShiftSelection(1)<CR>gv
vnoremap <leader>( <C-[>`>a)<C-o>`<(<C-[>:call ShiftSelection(1)<CR>gv
vnoremap <leader>[ <C-[>`>a]<C-o>`<[<C-[>:call ShiftSelection(1)<CR>gv
vnoremap <leader>{ <C-[>`>a}<C-o>`<{<C-[>:call ShiftSelection(1)<CR>gv

nnoremap <S-l> :L<cr>
noremap <space> :
noremap <C-space> @:
noremap Q @q
nnoremap <S-space> gQ
" This part is just supposed to make saving as inconvenient as possible
" because I have a tendency to just save stuff pretty much as soon as I start
" typing because I'm bored and possibly a bit paranoid.
function! s:saveprompt()
	if &swapfile
		echo "You have swap files enabled, stop in-between-saving all the time!"
	end
	if input("Type 'save' to save: ") ==? "save"
		write
		echo "File saved, but was it really necessary?"
	else
		echo "Calm the fuck down man!"
	end
endfun
noremap <C-s> :call <sid>saveprompt()<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <leader>j :lnext<cr>
nnoremap <leader>k :lNext<cr>
nnoremap <leader><leader>j :cnext<cr>
nnoremap <leader><leader>k :cNext<cr>
nnoremap <C-i> Bi <esc>i
nnoremap <C-a> Ea <esc>a
" This one does nothing, but I'm adding it to remember not to remap the tab key
nnoremap <tab> <C-S-I>
nnoremap <S-tab> <C-S-O>
noremap <F1> :setl number!<CR>
noremap <F2> :setl relativenumber!<CR>
noremap <F3> :setl autowriteall!<CR>:setl autowriteall?<CR>
noremap <F4> :setl list!<CR>
nnoremap <C-e> ge
nnoremap <C-E> gE
com! SetWD :cd %:p:h
com! SetLWD :lcd %:p:h
com! Trailing let _s=@/ | %s/\v(\\@<!\s)+$//ge | let @/=_s
nnoremap <C-d> :copy .<CR>
vnoremap <C-d> :copy '><CR>
nnoremap dx 0"_d$
nnoremap dcx 0d$
nnoremap <leader>: :let @* = @:<CR>
nnoremap <expr> <S-r> ":%s/\\<".expand("<cword>")."\\>/"
vnoremap <expr> <S-r> ":<C-u>%s/".VisualSelection()."/"
" Put in new line with indentation
nnoremap ]p :let [content, type]=
		\[getreg(v:register), getregtype(v:register)] \|
		\call setreg(v:register, content, "V")<CR>]p
		\:call setreg(v:register, content, type)<CR>
nnoremap [p :let [content, type]=
		\[getreg(v:register), getregtype(v:register)] \|
		\call setreg(v:register, content, "V")<CR>[p
		\:call setreg(v:register, content, type)<CR>

" Empty Lines
nnoremap <ENTER> :call <SID>Enter(0)<CR>
nnoremap <S-ENTER> :call <SID>Enter(1)<CR>
function! s:Enter(shift)
	if !a:shift
		silent exe "normal o\<esc>0\"_d$"
	else
		silent exe "normal O\<esc>0\"_d$j"
	endif
endfunction

" Markdown Stuff
vnoremap * <C-c>`>a*<C-c>`<i*<C-c>
vnoremap _ <C-c>`>a__<C-c>`<i__<C-c>

" === GENERAL ABBREVIATIONS ===
cabbr rcpath fnamemodify($MYVIMRC, ":p:h")

cabbr <expr> %% expand('%:p:h')

digraph <3 9829
digraph ue 252
digraph UE 220
digraph ae 228
digraph AE 196
digraph oe 246
digraph OE 214
digraph ss 223

" === GENERAL AUTOCOMMANDS ===

command! HLProgress syntax match Comment /\_.*\ze\n.*\%#/

nnoremap <leader>h :call <SID>toggleWUC()<CR>
function! s:updateWUC()
	if exists("b:hlwuc")
		if b:hlwuc > 1
			call matchdelete(b:hlwuc)
		end
	end
	if exists("b:word_hl")
		let hl = b:word_hl
	else
		let hl = "Underlined"
	endif
	let str = "\\<".escape(expand("<cword>"), "\\")."\\>"
	let b:hlwuc = matchadd(hl, str)
	"echom str
endfunc
function! s:toggleWUC()
	augroup hlwuc
	if exists("b:hlwuc")
		autocmd!
		if b:hlwuc > 1
			call matchdelete(b:hlwuc)
		end
		unlet b:hlwuc
	else
		call <SID>updateWUC()
		autocmd CursorMoved <buffer> call <SID>updateWUC()
		autocmd CursorMovedI <buffer> call <SID>updateWUC()
	endif
	augroup END
endfunction

" Autosave when vim loses focus :)
function! TryAutosave(warn, mode)
	if a:mode == 0
		if &autowriteall || &autowrite
			silent wall
			if a:warn
				echo "Autosaving all buffers..."
			end
		end
	elseif a:mode == 1
		if &autowriteall
			if &mod
				silent write
				if a:warn
					echo "Autosaving current buffer..."
				end
			end
		end
	end

	redraw
endfunction

augroup autosave
autocmd!
autocmd FocusLost * call TryAutosave(0, 0)
autocmd BufLeave * call TryAutosave(0, 1)
autocmd CursorHold * call TryAutosave(0, 1)
augroup END

vnoremap <leader>g :<C-u>call <SID>GrepOperator(visualmode())<CR>
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<CR>g@
function! s:GrepOperator(type)
	let reg1 = @@
	if a:type==# 'v'
		execute "normal! `<v`>y"
	elseif a:type==# 'char'
		execute "normal! `[y`]"
	else
		return
	end
	echom "vimgrep! /\\M".escape(@@, "\\")."/ *"
	silent! execute "vimgrep /\\M".escape(@@, "\\")."/j *"
	let @@ = reg1
	copen
	set nowrap
endfunction

" Window Height stuff
command! EqualH call Equal()
command! -nargs=1 WinHeight call SetWinMinHeight(<f-args>)
function! Equal()
	set winminheight=0
	set winheight=1
	set equalalways!
	set equalalways!
endfunc
function! SetWinMinHeight(num)
	execute "set winminheight=".0
	if a:num>=0
		execute "set winheight=".(a:num+1)
		execute "set winminheight=".a:num
	endif
	execute "set winheight=".9999
endfunc
" call SetWinMinHeight(2)
function! AddWinMinHeight(num)
	let a:new = &winminheight + a:num
	call SetWinMinHeight(a:new)
	set winminheight?
endfunc

" Window Width Stuff
command! EqualW silent! call EqualW()
command! -nargs=1 WinWidth call SetWinMinWidth(<f-args>)
function! EqualW()
	set winminwidth=0
	set winwidth=1
	set equalalways!
	set equalalways!
endfunc
function! SetWinMinWidth(num)
	execute "set winminwidth=".0
	if a:num>=0
		execute "set winwidth=".(a:num+1)
		execute "set winminwidth=".a:num
	endif
	execute "set winwidth=".9999
endfunc
function! AddWinMinWidth(num)
	let a:new = &winminwidth + a:num
	call SetWinMinWidth(a:new)
	set winminwidth?
endfunc


" === GENERIC AUTOCOMMANDS ===

if has("autocmd")
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.

	" For all text files set 'textwidth' to 78 characters.
	" autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if line("'\"") >= 1 && line("'\"") <= line("$") |
		\		exe "normal! g`\"" |
		\ endif

endif

" === FILETYPE SPECIFIC STUFF ===

" --- GENERIC STUFF ---
au BufNewFile,BufRead * :call <sid>init_generic_file()

function! s:init_generic_file()
	call s:autoClose_AddPair("[", "]")
	call s:autoClose_AddPair("(", ")")
	call s:autoClose_AddPair("{", "}")
	call s:autoClose_AddPair('"', '"')
endfunc

" --- VIMSCRIPT STUFF ---
au BufNewFile,BufRead *.vim,*vimrc :call <sid>init_vim_file()

function! s:init_vim_file()
	setl number
	nnoremap <buffer> <F5> :w<CR>:so %<CR>
	nnoremap <leader>c A<space>"<space>
	nnoremap <leader>if ofunction! <C-o>m'()<enter>endfunction<C-o>`'<C-o>l

	command! -buffer Functions lex MatchingLines("^\\s*fun\\(ction\\)\\?\\>!.*$")
	command! -buffer Commands  lex MatchingLines("^\\s*com\\(mand\\)\\?\\>!.*$")
	command! -buffer Autocommands  lex MatchingLines("^\\s*au\\(tocmd\\)\\?\\>!\\@!.*$")
endfunction

" --- C / C++ Stuff ---

" Insert Stuff
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <leader>ii O#include <><esc>i
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <buffer> <leader>ip oprintf("<C-o>m'\n");<esc>`'a
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <leader>im oint main(int argc, char *args[]) {<CR>}<esc>O
" Other Stuff
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> ; m'$a;<C-c>`'

" --- Ruby Stuff ---
au BufNewFile,BufRead *.rb :call <sid>init_ruby_file()

function! s:init_ruby_file()
	set makeprg=ruby\ -wc\ %
	setl number
	command! -buffer Methods lex MatchingLines("^\\s*def\\>\\s\\+\\zs.*$") | lopen
		command! -buffer Functions Methods " Alias
	command! -buffer Classes lex MatchingLines("^\\s*class\\>\\s\\+\\zs.*$") | lopen
	command! -buffer Modules lex MatchingLines("^\\s*module\\>\\s\\+\\zs.*$") | lopen
	command! -buffer Members lex MatchingLines("@\\<\\i*\\>") | lopen
	command! -buffer Requires lex MatchingLines("^\\s*require\\(_relative\\)\\?\\>\\s\\+\\zs.*$") | lopen

	nnoremap <buffer> <leader>ic oclass <C-o>m'<enter>end<esc>`'a
	nnoremap <buffer> <leader>id odef <C-o>m'()<enter>end<esc>`'a

	nnoremap <buffer> <F5> :w<CR>:!ruby %<CR>
	nnoremap <buffer> <F6> :lmake<CR>:lopen<CR>
	nnoremap <buffer> <leader>~ :call <SID>RubyComment(0)<CR>
	nnoremap <buffer> <leader># :call <SID>RubyComment(1)<CR>
	vnoremap <buffer> <leader>~ :call <SID>RubyComment(0)<CR>
	vnoremap <buffer> <leader># :call <SID>RubyComment(1)<CR>
endfunction

function! s:RubyComment(a)
	if a:a==0
		" silent! exec '.s/\m^\s*\zs#*//'
		silent! exec '.s/\v^(\s|#)*//'
		normal ==
	elseif a:a==1
		" silent! exec '.s/\v^(\s*#)@!/#/'
		silent! exec '.s/\v^(\s|#)*/# /'
		normal ==
	end
endfunction

"	augroup rbindent
"		autocmd!
"		au BufNewFile,BufRead *.rb :set noexpandtab | :retab! |
"	
"		au BufWritePre *.rb :let ts = &tabstop | set expandtab | set tabstop=2 | retab | let &tabstop=ts | :set noexpandtab
"	
"		au BufWritepost *.rb :silent! :undo | :exe "normal \<C-O>"
"	augroup END

" --- Lua Stuff ---

" Matches all types of Lua string!
" \v(["'])\zs.{-}\ze\\@1<!\2|\[(\=*)\[\zs.{-}\ze\]\3\]

au BufNewFile,BufRead *.lua :call <sid>init_lua_file()

function! s:init_lua_file()
	setl number
	command! -buffer Requires call setloclist(0, MatchingLinesDict("\\vrequire\\s*\\(?(([\"'])\\zs.{-}\\ze\\\\@1<!\\2|\\[(\\=*)\\[\\zs.{-}\\ze\\]\\3\\])\\)?"))
	command! -buffer Functions call setloclist(0, MatchingLinesDict("^\\v(\\s*\\zs(local\\s*)?function\\s*[a-zA-Z0-9.:_]*\\(.*\\)(\\s*--.*|\\ze.*)|.*function\\(.*\\)(\\s*--.*|\\ze.*))$")) 
endfunction!

" --- HTML Stuff ---
au BufNewFile,BufRead *.html,*.htm,*.etlua,*.erb :call <sid>init_html_file()

function! s:init_html_file()
	setl number
	command! -buffer -nargs=1 Tag normal
				\ i<<args>><<C-o>m'/<args>><ESC>`'
	nnoremap <buffer> <leader>T ""ciw<<C-o>""p><C-o>m'</<C-o>""p><C-o>`'<C-o>l
	nnoremap <buffer> <leader>T ""diw<C-o>"_cc<<C-o>""p><C-o>o</<C-o>""p><C-o>O

	function! s:insert_tag(tag, newline)
		if !a:newline
			let l:text = "<".a:tag."></".a:tag.">" 
		else
		end
		put =l:text
	endfunction

	nnoremap <C-space> :call <sid>insert_tag(input(""), 0)<CR>

	inoremap <buffer> <C-space> <C-o>""ciw<<C-o>""p><C-o>m'</<C-o>""p><C-o>`'<C-o>l
	inoremap <buffer> <C-CR> <C-o>""diw<C-o>"_cc<<C-o>""p><C-o>o</<C-o>""p><C-o>O
endfunction
