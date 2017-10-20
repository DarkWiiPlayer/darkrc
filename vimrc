" makes use of marker '

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
set history=50		" keep 50 lines of command line history
set nonumber " Switch these two if it proves to be annoying
set relativenumber
set langmenu=en_UK
let $LANG = 'en_UK'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
colorscheme slate
set gfn=Courier_New:h12:cANSI
try
"	set undodir=~/.vim_runtime/temp_dirs/undodir
	set undodir=C:\vim\undodir
	set undofile
catch
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
" au BufEnter,BufRead * set linebreak
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

" === GENERAL KEY MAPPINGS ===
let mapleader = "\\"
noremap <space> :
noremap <C-space> @:
noremap Q @q
nnoremap <S-space> gQ
noremap <C-s> :w<CR>
noremap <C-x> :hide<CR>
noremap <C-q> :close<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
noremap <F1> :setl number!<CR>
noremap <F2> :setl relativenumber!<CR>
noremap <F3> :setl autowriteall!<CR>:setl autowriteall?<CR>
noremap <F4> :setl list!<CR>
nnoremap <S-tab> :retab!<CR>
nnoremap <C-tab> :setl expandtab!<CR>:set expandtab?<CR>
nnoremap <C-e> ge
nnoremap <C-E> gE
com! Setwd :cd %:p:h
com! Removetrailingspaces :%s/\v(\\@<!\s)+$//ge
nnoremap <leader>t :Removetrailingspaces<CR>
nnoremap <C-d> :copy .<CR>
nnoremap dx 0"_d$
nnoremap dcx 0d$
nnoremap <C-i> Bi <esc>i
nnoremap <C-a> Ea <esc>a
nnoremap <leader>: :let @* = @:<CR>
 
" Empty Lines
nnoremap <ENTER> :call <SID>Enter(0)<CR>
nnoremap <S-ENTER> :call <SID>Enter(1)<CR>
function! s:Enter(shift)
	if !a:shift
		if col(".")-1
			exe "normal o\<esc>"
		else
			exe "normal O\<esc>j0"
		end
	else
		exe "normal O\<esc>j"
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
	let str = "\\<".escape(expand("<cword>"), "\\")."\\>"
	let b:hlwuc = matchadd("Underlined", str)
	echom str
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
function! SetWinMinHeight(num)
	execute "set winminheight=".0
	execute "set winheight=".(a:num+1)
	execute "set winminheight=".a:num
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


if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

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
au BufNewFile,BufRead *.vim,*vimrc :nnoremap <buffer> <F5> :so %<CR>
au BufNewFile,BufRead *.vim,*vimrc :nnoremap <leader>c A<space>"<space>
au BufNewFile,BufRead *.vim,*vimrc :nnoremap <leader>if ofunction! <C-o>m'()<enter>endfunction<C-o>`'<C-o>l

" --- C / C++ Stuff ---

" Insert Stuff
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <leader>ii o#include <><esc>i
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <buffer> <leader>ip oprintf("<C-o>m'\n");<esc>`'a
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> <leader>im oint main(int argc, char *args[]) {<CR>}<esc>O
" Other Stuff
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp :nnoremap <buffer> ; m'$a;<C-c>`'

" --- Ruby Stuff ---
" Insert Stuff
au BufNewFile,BufRead *.rb :nnoremap <buffer> <leader>ic oclass <C-o>m'<enter>end<esc>`'a
au BufNewFile,BufRead *.rb :nnoremap <buffer> <leader>id odef <C-o>m'()<enter>end<esc>`'a
" Other Stuff
au BufNewFile,BufRead *.rb setl expandtab
au BufNewFile,BufRead *.rb nnoremap <buffer> <F5> :w<CR>:!ruby %<CR>
au BufNewFile,BufRead *.rb nnoremap <buffer> <F6> :w<CR>:!ruby -wc %<CR>
au BufNewFile,BufRead *.rb setl foldmethod=syntax
au BufNewFile,BufRead *.rb folddoclosed foldopen
au BufNewFile,BufRead *.diff setl foldmethod=diff

au BufNewFile,BufRead *.rb :nnoremap <buffer> <leader>C :call <SID>RubyComment(0)<CR>
au BufNewFile,BufRead *.rb :nnoremap <buffer> <leader>c :call <SID>RubyComment(1)<CR>
au BufNewFile,BufRead *.rb :vnoremap <buffer> <leader>C :call <SID>RubyComment(0)<CR>
au BufNewFile,BufRead *.rb :vnoremap <buffer> <leader>c :call <SID>RubyComment(1)<CR>
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
	au BufWritepost *.rb :retab!
augroup END
