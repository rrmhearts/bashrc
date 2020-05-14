# Use global profile when available
if [ -f /usr/share/defaults/etc/profile ]; then
	. /usr/share/defaults/etc/profile
fi
# allow admin overrides
if [ -f /etc/profile ]; then
	. /etc/profile
fi

parse_git_branch() {
#	git branch 2> /dev/null | grep '^*' | colorm 1 2
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[00;34m\]\w\n\[\033[2;38;5;214m\]\@\[\033[33m\]$(parse_git_branch)\[\033[00m\] 🌱 '

alias cats='pygmentize -g'

export PATH=$PATH:/home/ryan/bin
export DENO_INSTALL="/home/ryan/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

source '/home/ryan/lib/azure-cli/az.completion'
