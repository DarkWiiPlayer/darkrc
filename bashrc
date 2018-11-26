alias hello='echo "Hello :)"'
alias temp='watch -t -d -n 1 sensors -A coretemp-isa-0000'
alias w='watch -t -d -n 1'
alias freq='watch -t -d -n 1 "cpufreq-info -c 0 -f; cpufreq-info -c 1 -f"'
export PATH=~/.bin:$PATH
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias wgetclip='wget `xclip -selection clipboard -o`'
export HISTIGNORE='ls:clear:history'
alias cmatrix='cmatrix -b -C `r.choose green red blue white yellow cyan magenta black`'
alias youtube-mp3='/home/darkwiiplayer/.local/bin/youtube-dl --extract-audio --audio-format mp3'
alias oneko='oneko -speed 20 -fg "#2f2f2f" -cursor 2 -name neko'
alias sakura='oneko -bg "#ffddee" -sakura -name sakura'
alias tmux='tmux -2'
alias pi='ssh pi -t ''tmux a -t home \|\| tmux new-session -s home'''
alias server='ssh server -t ''tmux a -t home \|\| tmux new-session -s home'''
alias ltc='getclip | luac -l -'
alias sign='gpg --armor --no-version --detach-sign --local-user darkwiiplayer'
alias workspace='cd ~/workspace'

stty -ixon

# Enable Vi editing mode
set -o vi

export LESSCHARSET=utf-8

git__prompt () {
	git rev-parse --show-toplevel > /dev/null 2>&1
	if [ $? = 0 ]
	then
    status=`git status --short 2>/dev/null`
		branch=`git branch | grep -Po '(?<=\* )[[:alnum:]]*'`
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
			echo -ne " ${red}↓${behind}${yellow}↑${ahead}"
		fi

    # BRANCH
		if [ -z $branch ]
		then
			branch='#'`git rev-parse --short HEAD`
		fi
		if [ $branch = 'master' ]
		then
			echo -ne " $blue$branch"
		elif [ ${branch:0:1} = '#' ]
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
			echo -ne " ${red}+$untracked"
		fi
	fi
}

PS1='\[\033[00;34m\]┌─╼ \[\033[00;33m\]\$ \[\033[01;35m\]\u\[\033[00;34m\]@\[\033[01;35m\]\h\[\033[01;34m\] `date +%d.%m.%y` \[\033[01;35m\]\w`git__prompt`\[\033[00m\]
\[\033[00;34m\]└╼ \[\033[00m\]'
