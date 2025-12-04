# vim: set noexpandtab filetype=sh :miv #

if [ -z "$BASH_SOURCE" ]
	then export DARKRC="$(realpath $(dirname $0))"
	else export DARKRC="$(realpath $(dirname $BASH_SOURCE))"
fi

if which nvim > /dev/null
then export EDITOR=nvim
else export EDITOR=vim
fi

export LESSCHARSET=utf-8
export PATH="$DARKRC/bin:$PATH"
