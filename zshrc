export HISTFILE=$HOME/.zsh_history
export SAVEHIST=10000
export HISTFILESIZE=10000
export HISTSIZE=10000

alias scratch="scratch $SHELL"

alias hgrep='history 0 | grep '
setopt append_history
setopt hist_find_no_dups
# setopt hist_ignore_dups
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
# setopt hist_ignore_all_dups
setopt prompt_subst
setopt hist_ignore_space

bindkey -v

which task > /dev/null && which jq > /dev/null
run_task_prompt=$?
task_prompt() {
	if [ -z $run_task_prompt ]
	then
		tasks="$(task +ACTIVE export | jq -r '.[].description' | sed 's/^/‣ /')"
		if [ -n "$tasks" ]
		then
			echo "\x1b[30m$tasks\n\x1b[0m"
		fi
	fi
}

which timew > /dev/null
run_timew_prompt=$?
timew_prompt() {
	if [ -z $run_timew_prompt ]
	then
		if [ $(timew get dom.active) -eq "1" ]
		then echo '\x1b[31m●\x1b[0m '
		fi
	fi
}

ranger_prompt() {
	if [ -n "$RANGER_LEVEL" ]
	then
		for num in $(seq "$RANGER_LEVEL")
		do echo -n »
		done
	fi
}

prompt='$(task_prompt)%(?.%F{green}.%F{red})λ%F{blue}$(ranger_prompt)%f '
export PROMPT_full='%F{red}$(timew_prompt)%B%F{magenta}%n%F{blue}@%F{magenta}%m%b %F{magenta}%~
'"$prompt"
export PROMPT_gitlong='%F{red}$(timew_prompt)$(gitprompt && echo -ne " ")%F$(git log --oneline --no-decorate -1 2>/dev/null)
%F{cyan}$(gitpath)'"$prompt"
# export PS1tiny=
# export PS1nano=
# export PS1nogit=
# export PS1git=

export HISTORY_IGNORE='(ls|vimswitch|clear)'
zshaddhistory() {
	[[ $1 != ${~HISTORY_IGNORE} ]]
}

export PROMPT=$PROMPT_full
prompt() {
	case $1 in
	(full)
		export PROMPT=$PROMPT_full;;
	(gitlong)
		export PROMPT=$PROMPT_gitlong;;
	(*)
		export PROMPT=$PROMPT_full;;
	esac
	export PROMPT_set=$1
}
prompt $PROMPT_set

source smartprompt
chpwd() {
	source smartprompt
}
