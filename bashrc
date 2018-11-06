
alias hello='echo "Hello :)"'
alias rmd='rm --recursive'
alias temp='watch -t -d -n 1 sensors -A coretemp-isa-0000'
alias w='watch -t -d -n 1'
alias freq='watch -t -d -n 1 "cpufreq-info -c 0 -f; cpufreq-info -c 1 -f"'
export PATH=~/.bin:$PATH
alias zbhere="zbstudio \`pwd\`"
alias lynxc='lynx -accept_all_cookies -session=$HOME/.lynx_session'
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias wgetclip='wget `xclip -selection clipboard -o`'
alias untar='tar -xf'
alias lynx='lynx --accept_all_cookies'
alias push='clipstack -push'
alias pop='clipstack -pop'
alias pushwd='pwd | clipstack -push'
alias popwd='cd `clipstack -pop`'
alias now='date -I'
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
stty -ixon

# Enable Vi editing mode
set -o vi

PS1='\[\033[02;34m\]┌─╼ \[\033[02;35m\]\$\u\[\033[00m\]@\[\033[02;35m\]\h\[\033[01;34m\] `date +%d.%m.%y` \[\033[01;35m\]\w\[\033[00m\]
\[\033[02;34m\]└╼ \[\033[00m\]'
