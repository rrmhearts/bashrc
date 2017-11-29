# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=20000

# Using current history in other terminals ry
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias cd..="cd .."
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..7="cd ../../../../../../.."

alias reboot="sudo shutdown -r now"
alias fn="find . -name"

# csearch function
csrch() {
	if [ "$1" == "-h" ]; then
		echo "Usage: 'csearch dir search_phrase' Lists files containing phrase"
	else
		grep --include=\*.{c,cpp,h} -rnw "$1" -e "$2"
	fi
}

gfiles() {
	if [ "$1" == "-h" ]; then
                echo "Usage: 'gfiles search_phrase regex_files' Lists search_phrase in regex_files"
        else
		find . -iname "$2" -exec grep -i "$1" {} + 2> >(grep -Ev "Permission denied|Is a directory") | grep -v "Binary file"
	fi
}

replacestr() {
        if [ "$1" == "-h" ]; then
                echo "Usage: 'replacestr dir/ oldstring newstring"
        else
                grep -rl "$2" "$1" | xargs sed -i "s/$2/$3/g"
        fi

}

supgrade() {
	sudo apt update
	yes | sudo apt upgrade
	sudo apt autoremove
	sudo apt autoclean
}

fslsdpart() {
         if [ "$1" == "-h" ]; then
                 echo "Usage: 'fsl-sd-part /dev/sdx' "
         elif [ "${1%/*}" == "/dev" ]; then
		 echo "Preparing disk..."
		 sudo umount `echo "$1?*"` 2> /dev/null  
		 sudo partprobe $1
                 echo "Partitioning disk..."
                 croot
                 cd out/target/product/sabresd_6dq
                 yes | sudo ../../../../device/fsl/common/tools/fsl-sdcard-partition.sh -f imx6q $1
         
         else
                echo "Bad argument."
         fi
}


# disable suspend, CTRL-s will not freeze bash
stty -ixon

# Android builds should be using SD card, not eMMC for boot storage
export BUILD_TARGET_DEVICE=sd
export ARCH=arm
export CROSS_COMPILE=~/Android/Source/newdroid/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-


extract() {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

#promptFunction() {

#   if [ "$PWD" != "$OLDPWD" ] && [ -e ./build/envsetup.sh ]; then
#	OLDPWD="$PWD";
#	source ./build/envsetup.sh > /dev/null
#	chooseproduct sabresd_6dq > /dev/null
#	choosevariant eng > /dev/null
#	echo "Setup Complete."
#   fi
#   export PROMPT_COMMAND=promptFunction
#}

# function cd () { builtin cd "$@" && promptFunction; } # recursive issue
#export PROMPT_COMMAND=promptFunction

export USERNAME="Ryan"
export NICKNAME="Ryan"

quoter[0]=$(fortune)
quoter[1]=$(fortune /usr/local/fortune/bible)
quoter[2]=$(verse)

# Welcome message
echo -ne "Good Morning, $NICKNAME! It's "; date '+%A, %B %-d %Y'
echo 
rand=$[ $RANDOM % 3 ]
echo ${quoter[$rand]}


als () {
  echo "alias" $1'="'$2'"' >> ~/.bashrc
  source ~/.bashrc
}

expandPath() {
  case $1 in
    ~[+-]*)
      local content content_q
      printf -v content_q '%q' "${1:2}"
      eval "content=${1:0:2}${content_q}"
      printf '%s\n' "$content"
      ;;
    ~*)
      local content content_q
      printf -v content_q '%q' "${1:1}"
      eval "content=~${content_q}"
      printf '%s\n' "$content"
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

# Replace "rm" command so that files are disposed to the
# user's Gnome trash can.

rmSinglefile() {
   echo "removing $1" 
   type=`/usr/bin/stat --printf="%F" "$1"`

   if [ "$type" == "directory" ]; then
        echo -n "rm: cannot remove \`"
        echo -n $1
        echo "\`: Is a directory"
   else
        dir=`/usr/bin/dirname "$1"`
        file=`/usr/bin/basename "$1"`
        info=${HOME}/.local/share/Trash/info/"$file".trashinfo

        cd "$dir"

        /bin/cp "$file" ${HOME}/.local/share/Trash/files
        /bin/rm -f "$file"

        echo "[Trash Info]"                > "$info"
        echo "Path=$PWD/$file"            >> "$info"
        echo "DeletionDate=`date +%FT%T`" >> "$info"

        cd "$OLDPWD"
   fi
}

rmfiles() {
   for file in "$@"
   do
        rmSinglefile $file
   done
   # echo $@ | xargs bash -c '_rmfile "$1"' # | xargs -I {} bash -c '_rmfile "$@"' {}
}

cleanmemory() {
	free_data="$(free)"
	mem_data="$(echo "$free_data" | grep 'Mem:')"
	free_mem="$(echo "$mem_data" | awk '{print $4}')"
	buffers="$(echo "$mem_data" | awk '{print $6}')"
	cache="$(echo "$mem_data" | awk '{print $7}')"
	total_free=$((free_mem + buffers + cache))
	used_swap="$(echo "$free_data" | grep 'Swap:' | awk '{print $3}')"
	
	echo -e "Free memory:\t$total_free kB ($((total_free / 1024)) MB)\nUsed swap:\t$used_swap kB ($((used_swap / 1024)) MB)"
	echo 
	# swap to ram
	if [[ $used_swap -lt $total_free ]]; then
		sudo sh -c "echo 0 > /proc/sys/vm/swappiness"
	fi
	# clean cache 
	sudo sh -c "free && sync && echo 3 > /proc/sys/vm/drop_caches swapon -a && printf '\n\n%s\n\n' 'Ram-cache Cleared, Swap on' && free"
	sudo sh -c "echo 10 > /proc/sys/vm/swappiness"

}
### Pushing devlop branch directly to master
# $ git push origin develop:master

### Drastically increased my internet. keeping
# sudo sysctl -w net.ipv4.tcp_window_scaling=0

### Regex that matches path names
#  \/[^,:]*\.\w+ 
