#!/usr/bin/env bash

source ~/.sections/defaults

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=9000
HISTFILESIZE=90000
#export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "
parse_git_branch() {
#	git branch 2> /dev/null | grep '^*' | colorm 1 2
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# Using current history in other terminals ry
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# disable suspend, CTRL-s will not freeze bash
stty -ixon

# new prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;34m\]\w\n\[\033[2;38;5;214m\]\@ \[\033[01;32m\]skylar\[\033[33m\]$(parse_git_branch)\[\033[00m\] 🌱 '
# Introduction
export USERNAME="Ryan"
export NICKNAME="Ryan"

source ~/.sections/alias
source ~/.sections/android
source ~/.sections/functions
source ~/.sections/git
source ~/.sections/rfidtest
# Scroll past splash screen
# for i in {1..40}
# do
#   echo 
# done

clear
# Welcome 
screenfetch

echo 

quoter[0]=$(fortune)
quoter[1]=$(fortune /usr/local/fortune/bible)
quoter[2]=$(verse)

gday="Good day"
h=`date +%H` #| sed -e 's/^0//g'

if [ $h -lt 12 ]; then
  gday="Good Morning"
elif [ $h -lt 18 ]; then
  gday="Good Afternoon"
else
  gday="Good Evening"
fi

# Welcome message
echo -ne "$gday, $NICKNAME! It's "; date '+%A, %B %-d %Y'
echo -ne "The time is "; date '+%I:%M %P'
echo 
rand=$[ $RANDOM % 3 ]
echo ${quoter[$rand]}

# echo
# savoy

echo
cat ~/.notes.txt
