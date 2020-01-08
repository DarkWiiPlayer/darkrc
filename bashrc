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

git__fetch() {
	if [ -n "$BASH_AUTOFETCH_TIMEOUT" ]; then
		timeout=$BASH_AUTOFETCH_TIMEOUT
	else
		timeout=60
	fi
	if [ -f $1/.git/FETCH_HEAD ]; then
		diff=$(($(date +%s) - $(stat -c %Y $1/.git/FETCH_HEAD)))
	else
		diff=9999
	fi
	if [ $diff -gt $timeout ]
	then run=1
	else run=0
	fi
	if [ $run -gt 0 ]; then
		touch $1/.git/FETCH_HEAD
		nohup git fetch > /dev/null 2>&1 &
	fi
	echo $run
}

git__prompt () {
	top=$(git rev-parse --show-toplevel 2>/dev/null)
	if [ -n "$top" ]
	then
		if [ $BASH_AUTOFETCH -gt 0 ]; then
			autofetch=$(git__fetch $top)
			f=$((2-$autofetch))
		else
			f=3
		fi
		echo -ne " \033[00;3${f}mδ\033[00;33m"
		status=`git status --short 2>/dev/null`
		branch=`git branch | grep -Po '(?<=\* )[[:alnum:]_.-]*'`
		modif=`echo "$status" | grep -Po '^\s*M' | wc -l`
		untracked=`echo "$status" | grep -Po '^\?\?' | wc -l`
		added=`echo "$status" | grep -Po '^\s*[A]' | wc -l`
		deleted=`echo "$status" | grep -Po '^\s*[D]' | wc -l`
		renamed=`echo "$status" | grep -Eo '^\s*R' | wc -l`
		stat=`git branch -vv | grep -P '^\*' | grep -Po '\[.*\]'`
		ahead=`echo $stat | grep -Po '(?<=ahead )\d*'`
		behind=`echo $stat | grep -Po '(?<=behind )\d*'`
		gray='\033[01;30m'
		blue='\033[01;34m'
		yellow='\033[01;33m'
		red='\033[01;31m'
		green='\033[01;32m'
		purple='\033[01;35m'

		# SYNC
		if [ -z $ahead ] && [ -z $behind ]
		then
			echo -ne "" # Nothing to do here
		elif [ -z $ahead ]
		then
			echo -ne " ${yellow}↓${behind}"
		elif [ -z $behind ]
		then
			echo -ne " ${green}↑${ahead}"
		else
			echo -ne " ${red}↓${behind}${red}↑${ahead}"
		fi

		# BRANCH
		if [ -z $branch ]
		then
			head=`git rev-parse --short HEAD 2>&1`
			if [[ "$head" =~ fatal* ]]
			then
				branch='{no commits}'
			else
				branch='#'"$head"
			fi
		fi
		if [ "$branch" = 'master' ]
		then
			echo -ne " $blue$branch"
		elif [ "${branch:0:1}" = '#' ]
		then
			echo -ne " $red$branch"
		else
			echo -ne " $yellow$branch"
		fi

		# CHANGES
		if [ $modif = 0 ]
		then
			echo -ne # "${gray}:\033[01;36m$modif" # No modified files
		else
			echo -ne "${gray}:\033[01;33m$modif" # Modified files
		fi
		if [ $added -ne 0 ]
		then
			echo -ne " ${green}+$added"
		fi
		if [ $deleted -ne 0 ]
		then
			echo -ne " ${red}-$deleted"
		fi
		if [ $renamed -ne 0 ]
		then
			echo -ne " ${yellow}$renamed→$renamed"
		fi
		if [ $untracked -ne 0 ]
		then
			echo -ne " ${purple}+$untracked"
		fi
	fi
}

PS1n='\[\033[00;34m\]┌─╼ \[\033[01;35m\]\u\[\033[00;34m\]@\[\033[01;35m\]\h \[\033[00;33m\]\$ \[\033[01;35m\]\w \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00m\]`git__prompt`
\[\033[00;34m\]└╼ \[\033[00m\]'

PS1c='\[\033[00;34m\]┌─╼ \[\033[00;33m\]\$ \[\033[01;35m\]\u`git__prompt` \[\033[01;35m\]`basename \`dirs +0\`` \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00m\]
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
