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

set nocompatible
""""""""""""""""
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
set gfn=Courier_New:h12:cANSI
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
set noswapfile

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
set showbreak=+->\ 
set listchars=eol:¶,tab:»\ ,trail:.

set modeline " Allows setting vim options in other files
set statusline=(%n)\ %f\ [%M%R]\ [%Y]%=%l,%c%V\ %4.P
set laststatus=2
set cmdheight=1
set timeoutlen=1200

" Clipboard and Copy/Paste things
set clipboard=unnamed " Allow copying to and from OS clipboard
noremap <leader>d "_d
noremap <leader>d "_d
noremap x "_x
noremap <leader>x x

" === GENERAL UTILITIES ===
function! MatchingLines(pattern)
	let list = []
	let pattern = a:pattern
	exec "g/".pattern."/ call add(list, expand('%').'('.line('.').') : '.matchstr(getline('.'), '".pattern."'))"
	return list
endfunc

function! s:mld_helper(list, pattern)
	" Helper function for MatchingLinesDict
	call add(a:list, {'filename': expand("%"), 'lnum': line("."),	'col':	match(getline("."), a:pattern)+1, 'text': matchstr(getline("."), a:pattern)})
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

" === GENERAL COMMANDS ===
command! L lopen | set number | set norelativenumber
command! LAddLine call LocationAddLine(expand("%"), line("."), getline("."))
command! QAddLine call QuickfixAddLine(expand("%"), line("."), getline("."))
command! LAddCursor call LocationAddLineCol(expand("%"), line("."), getline("."), col("."))
command! QAddCursor call QuickfixAddLineCol(expand("%"), line("."), getline("."), col("."))

command! Fixme lex MatchingLines("\\c\\<fixme.*")
command! Todo lex MatchingLines("\\c\\<todo.*")

command! -nargs=1 LFind call setloclist(0, MatchingLinesDict(<args>))
command! -nargs=1 QFind call setqflist(MatchingLinesDict(<args>))

" === GENERAL KEY MAPPINGS ===
let mapleader = "\\"
nnoremap <S-l> :L<cr>
noremap <space> :
noremap <C-space> @:
noremap Q @q
nnoremap <S-space> gQ
noremap <C-s> :w<CR>
noremap <C-x> :hide<CR>
noremap <C-q> :bdelete<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <leader>n :lnext<cr>
nnoremap <leader>p :lNext<cr>
nnoremap <leader><leader>n :cnext<cr>
nnoremap <leader><leader>p :cNext<cr>
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
com! Setwd :cd %:p:h
com! Removetrailingspaces :%s/\v(\\@<!\s)+$//ge
nnoremap <leader>t :Removetrailingspaces<CR>
nnoremap <C-d> :copy .<CR>
nnoremap dx 0"_d$
nnoremap dcx 0d$
nnoremap <leader>: :let @* = @:<CR>

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

function! Autosave()
	if &autowriteall==1
		silent w
		echo "Lost focus, buffer saved."
		redraw
	endif
endfunction
au FocusLost * call Autosave()
au WinLeave * call Autosave()

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
command! Equal call Equal()
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
call SetWinMinHeight(2)
function! AddWinMinHeight(num)
	let a:new = &winminheight + a:num
	call SetWinMinHeight(a:new)
	set winminheight?
endfunc
nnoremap <leader>= :call AddWinMinHeight(1)<cr>
nnoremap <leader>- :call AddWinMinHeight(-1)<cr>
nnoremap <leader>0 :Equal<cr>

" Window Width Stuff
command! EqualW silent! call EqualW()
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
nnoremap <leader>+ :call AddWinMinWidth(1)<cr>
nnoremap <leader>_ :call AddWinMinWidth(-1)<cr>
nnoremap <leader>) :EqualW<cr>


if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if line("'\"") >= 1 && line("'\"") <= line("$") |
		\		exe "normal! g`\"" |
		\ endif

	augroup END
endif

" === FILETYPE SPECIFIC STUFF ===

" Vimscript Stuff
au BufNewFile,BufRead *.vim,*vimrc :call <sid>init_vim_file()

function! s:init_vim_file()
	nnoremap <buffer> <F5> :so %<CR>
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
	command! -buffer Defines lex MatchingLines("^\\s*def\\>.*$")
		command! -buffer Functions Defines " Alias
		command! -buffer Methods Defines " Alias
	command! -buffer Classes lex MatchingLines("^\\s*class\\>.*$")
	command! -buffer Modules lex MatchingLines("^\\s*module\\>.*$")

	nnoremap <buffer> <leader>ic oclass <C-o>m'<enter>end<esc>`'a
	nnoremap <buffer> <leader>id odef <C-o>m'()<enter>end<esc>`'a

	setl expandtab
	nnoremap <buffer> <F5> :w<CR>:!ruby %<CR>
	nnoremap <buffer> <F6> :w<CR>:!ruby -wc %<CR>
	nnoremap <buffer> <leader>~ :call <SID>RubyComment(0)<CR>
	nnoremap <buffer> <leader># :call <SID>RubyComment(1)<CR>
	vnoremap <buffer> <leader>~ :call <SID>RubyComment(0)<CR>
	vnoremap <buffer> <leader># :call <SID>RubyComment(1)<CR>
endfunction

function! s:RubyComment(a)
	if a:a==0
		silent! exec '.s/\m^\s*\zs#*//'
	elseif a:a==1
		silent! exec '.s/\v^(\s*#)@!/#/'
	end
endfunction

augroup rbindent
autocmd!
	au BufNewFile,BufRead *.rb :set noexpandtab
	au BufNewFile,BufRead *.rb :retab!

	au BufWritePre *.rb :set expandtab
	au BufWritePre *.rb :set tabstop=2 " TODO: find a way to change it back to whatever it was before
	au BufWritePre *.rb :retab

	au BufWritepost *.rb :set noexpandtab
	au BufWritepost *.rb :silent! :undo
augroup END
