export SAVEHIST=10
export HISTFILE=$HOME/.zsh_history
export HISTFILESIZE=10000
export HSITSIZE=10000

setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
# setopt hist_ignore_all_dups
setopt prompt_subst
setopt hist_ignore_space

prompt='%(?.%F{green}.%F{red})λ%f '
export PROMPT_full='%B%F{magenta}%n%F{blue}@%F{magenta}%m%b %F{magenta}%~
'"$prompt"
export PROMPT_gitlong='$(gitprompt && echo -ne " ")%F5$(git log --oneline --no-decorate -1 2>/dev/null)
%F{cyan}$(gitpath)'"$prompt"
# export PS1tiny=
# export PS1nano=
# export PS1nogit=
# export PS1git=

export HISTORY_IGNORE='(ls|vimswitch|clear)*'
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
