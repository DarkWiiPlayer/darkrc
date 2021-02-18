export HISTIGNORE='ls:clear:history:vimswitch*'

# Enable Vi editing mode
set -o vi

export PS1full='\[\033[00;34m\]┌─╼ \[\033[00;30m\]$(numjobs ⚒ " ×")\033[00;36m$(rlevel 🥆 📓 ·)\[\033[01;35m\]\u\[\033[00;34m\]@\[\033[01;35m\]\h \[\033[00;33m\]\$ \[\033[01;35m\]\w \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00;34m\] $(gitprompt)
\[\033[00;34m\]└╼ \[\033[00m\]'

export PS1tiny='\[\033[00;30m\]$(numjobs ⚒)\[\033[00;30m\]$(dirs +0 | sed -e "s/.*\\(\\(\\/.*\\)\\{2\\}\\)$/…\\1/") \[\033[00;36m\]$(rlevel 🥆 📓 ·)\[\033[00;34m\]‣ \[\033[00m\]'

export PS1nano='\[\033[02;31m\]‣ \[\033[00m\]'

export PS1nogit='\[\033[00;34m\]┌─╼ \033[00;31m$(rlevel 🥆 📓)\[\033[01;35m\]\u\[\033[00;34m\]@\[\033[01;35m\]\h \[\033[00;33m\]\$ \[\033[01;35m\]\w \[\033[01;34m\]`find -mindepth 1 -maxdepth 1 -type d | wc -l`\[\033[00;34m\]d \[\033[01;32m\]`find -maxdepth 1 -type f | wc -l`\[\033[00;32m\]f\[\033[00m\]
\[\033[00;34m\]└╼ \[\033[00m\]'

export PS1git='\[\033[00;30m\]$(numjobs ⚒)\[\033[00;30m\]$(gitprompt || dirs +0) \[\033[00;36m\]$(gitpath) \[\033[00;36m\]$(rlevel 🥆 📖 ·)
\[\033[00;34m\]↳ \[\033[00m\]'

export PS1gitlong='\[\033[00;30m\]$(numjobs ⚒ ·)\[\033[00;30m\]$(gitprompt || dirs +0) \[\033[00;30m\]$(git log --oneline --no-decorate -1 2>/dev/null) 
\[\033[00;36m\]$(rlevel 🥆 📓 ·)\[\033[00;36m\]$(gitpath)\[\033[00;31m\]» \[\033[00m\]'

prompt() {
	name=PS1$1
	if [ -z $1 ] || [ -z "${!name}" ]; then
		name=PS1full
	fi
	export PS1set=$1
	PS1=${!name}
}

prompt $PS1set
