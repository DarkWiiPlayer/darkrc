# vim: set noexpandtab filetype=sh :miv #

export DARKRC="$(realpath $(dirname $0))"

if which nvim > /dev/null
then export EDITOR=nvim
else export EDITOR=vim
fi

export LESSCHARSET=utf-8
export PATH="$PATH"

# export MANPATH="$HOME/.local/share/man:$(manpath)"
