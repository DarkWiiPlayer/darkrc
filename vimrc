"!!! makes use of marker '

" Sessions
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages

" some conditional configs
if has('mouse')
	set mouse=a
endif

if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch "Highlight search results
endif

if v:version > 702
	set cm=blowfish
end
if v:version > 800
	set cm=blowfish2
end

set nocompatible
""""""""""""""""
" set linespace=0
set scrolloff=6
set history=50 " keep 50 lines of command line history
set nonumber
set relativenumber
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
		\   [line_end, column_end, line_start, column_start]
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
command! L lopen | set number | set norelativenumber
command! LAddLine call LocationAddLine(expand("%"), line("."), getline("."))
command! QAddLine call QuickfixAddLine(expand("%"), line("."), getline("."))
command! LAddCursor call LocationAddLineCol(expand("%"), line("."), getline("."), col("."))
command! QAddCursor call QuickfixAddLineCol(expand("%"), line("."), getline("."), col("."))

command! Fixme call setloclist(0, MatchingLinesDict("\\c\\<fixme.*"))
command! Todo call setloclist(0, MatchingLinesDict("\\c\\<todo.*"))

command! -nargs=1 LFind call setloclist(0, MatchingLinesDict(<args>))
command! -nargs=1 QFind call setqflist(MatchingLinesDict(<args>))

" === GENERAL KEY MAPPINGS ===
let mapleader = "\\"

" --- /dev/null ---
noremap <leader>d "_d
noremap <leader>d "_d
noremap x "_x
noremap <leader>x x

" --- Numbvers ---
nnoremap <leader>- <C-x>
nnoremap <leader>= <C-a>

" --- MOVEMENT ---
nnoremap j gj
nnoremap k gk

" --- CLIPBOARD ---
nnoremap Y y$

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
" noremap <C-s> :w<CR>
noremap <C-s> :echo "Calm the fuck down! There's
			\ no need to save every 10 seconds FFS!"<CR>
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
com! Removetrailingspaces let _s=@/ | %s/\v(\\@<!\s)+$//ge | let @/=_s
nnoremap <leader>t :Removetrailingspaces<CR>
nnoremap <C-d> :copy .<CR>
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

" Tabs vs. Spaces
nnoremap <C-tab> :setl expandtab!<CR>:set expandtab?<CR>
" TODO: custom function to retab only indentation

" Empty Lines
nnoremap <ENTER> :call <SID>Enter(0)<CR>
nnoremap <S-ENTER> :call <SID>Enter(1)<CR>
function! s:Enter(shift)
	if !a:shift
		if col(".")-1
			exe "normal o\<esc>0\"_d$"
		else
			exe "normal O\<esc>0\"_d$j"
		end
	else
		exe "normal O\<esc>0\"_d$"
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
function! TryAutosave()
	if &autowriteall==1
		silent w
		redraw
	endif
endfunction
au FocusLost * call TryAutosave()
au WinLeave * call TryAutosave()

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

" Vimscript Stuff
au BufNewFile,BufRead *.vim,*vimrc :call <sid>init_vim_file()

function! s:init_vim_file()
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
	command! -buffer Defines lex MatchingLines("^\\s*def\\>\\s\\+\\zs.*$") | lopen
		command! -buffer Functions Defines " Alias
		command! -buffer Methods Defines " Alias
	command! -buffer Classes lex MatchingLines("^\\s*class\\>\\s\\+\\zs.*$") | lopen
	command! -buffer Modules lex MatchingLines("^\\s*module\\>\\s\\+\\zs.*$") | lopen
	command! -buffer Requires lex MatchingLines("^\\s*require\\(_relative\\)\\?\\>\\s\\+\\zs.*$") | lopen

	nnoremap <buffer> <leader>ic oclass <C-o>m'<enter>end<esc>`'a
	nnoremap <buffer> <leader>id odef <C-o>m'()<enter>end<esc>`'a

	set expandtab
	nnoremap <buffer> <F5> :w<CR>:!ruby %<CR>
	nnoremap <buffer> <F6> :w<CR>:!ruby -wc %<CR>
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
	command! -buffer Requires call setloclist(0, MatchingLinesDict("\\vrequire\\s*\\(?(([\"'])\\zs.{-}\\ze\\\\@1<!\\2|\\[(\\=*)\\[\\zs.{-}\\ze\\]\\3\\])\\)?"))
	command! -buffer Functions call setloclist(0, MatchingLinesDict("^\\v(\\s*\\zs(local\\s*)?function\\s*[a-zA-Z0-9.:_]*\\(.*\\)(\\s*--.*|\\ze.*)|.*function\\(.*\\)(\\s*--.*|\\ze.*))$")) 
endfunction!

" --- HTML Stuff ---
au BufNewFile,BufRead *.html,*.htm,*.etlua,*.erb :call <sid>init_html_file()

function! s:init_html_file()
	command! -buffer -nargs=1 Tag normal
				\ i<<args>><<C-o>m'/<args>><ESC>`'
	nnoremap <buffer> <leader>t ""ciw<<C-o>""p><C-o>m'</<C-o>""p><C-o>`'<C-o>l
	nnoremap <buffer> <leader>T ""diw<C-o>"_cc<<C-o>""p><C-o>o</<C-o>""p><C-o>O

	inoremap <buffer> <C-space> <C-o>""ciw<<C-o>""p><C-o>m'</<C-o>""p><C-o>`'<C-o>l
	inoremap <buffer> <C-CR> <C-o>""diw<C-o>"_cc<<C-o>""p><C-o>o</<C-o>""p><C-o>O
endfunction
