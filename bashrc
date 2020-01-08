# vim: set noexpandtab :miv #
alias hello='echo "Hello :)"'
alias w='watch -t -d -n 1'
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias r='ranger'
alias rr='(ranger)'
alias ro='(f=$(tempfile); $(which ranger) --choosefiles $f; rifle $(cat $f); rm $f)'
export HISTIGNORE='ls:clear:history'
# alias cmatrix='cmatrix -b -C `r.choose green red blue white yellow cyan magenta black`'
alias oneko='oneko -speed 20 -fg "#2f2f2f" -cursor 2 -name neko'
alias sakura='oneko -bg "#ffddee" -sakura -name sakura'
alias tmux='tmux -2'
alias pi='ssh pi -t ''tmux a -t home \|\| tmux new-session -s home'''
alias server='ssh server -t ''tmux a -t home \|\| tmux new-session -s home'''
alias ltc='getclip | luac -l -'
alias sign='gpg --armor --no-version --detach-sign --local-user darkwiiplayer'
alias workspace='cd ~/workspace'
alias shit='git'
alias ranger='source ranger'
alias ta='tmux a -t'
alias co='checkout'

stty -ixon

# Enable Vi editing mode
set -o vi

PS1n='\[\033[00;34m\]┌─╼ \[\033[01;35m\]\u\[\033[00;34m\]@\[\033[01;35m\]\h \[\033[00;33m\]\$ \[\033[01;35m\]\w \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00m\] $(gitprompt)
\[\033[00;34m\]└╼ \[\033[00m\]'

PS1c='\[\033[00;34m\]┌─╼ \[\033[00;33m\]\$ \[\033[01;35m\]\u`gitprompt` \[\033[01;35m\]`basename \`dirs +0\`` \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00m\]
\[\033[00;34m\]└╼ \[\033[00m\]'

PS1=$PS1n

cd() {
	if [ -f .bashcdout ]
	then
		source .bashcdout
	fi
	builtin cd "$@" || return
	if [ -f .bashcd ]
	then
		source .bashcd
	fi
}

export GPG_TTY="$(tty)" # This is necessary for the gpg-agent, apparently
