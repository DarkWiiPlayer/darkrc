# vim: set noexpandtab filetype=sh :miv #

if which nvim > /dev/null
then export EDITOR=nvim
else export EDITOR=vim
fi

export LESSCHARSET=utf-8

# export MANPATH="$HOME/.local/share/man:$(manpath)"
