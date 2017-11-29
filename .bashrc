
#!/usr/bin/env bash

source ~/.sections/defaults

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=20000

# Using current history in other terminals ry
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# disable suspend, CTRL-s will not freeze bash
stty -ixon

# Introduction
export USERNAME="Ryan"
export NICKNAME="Ryan"

source ~/.sections/alias
source ~/.sections/android
source ~/.sections/functions
source ~/.sections/git


echo 
quoter[0]=$(fortune)
quoter[1]=$(fortune /usr/local/fortune/bible)
quoter[2]=$(verse)

# Welcome message
echo -ne "Good Morning, $NICKNAME! It's "; date '+%A, %B %-d %Y'
echo 
rand=$[ $RANDOM % 3 ]
echo ${quoter[$rand]}


### Pushing devlop branch directly to master
# $ git push origin develop:master

### Drastically increased my internet. keeping
# sudo sysctl -w net.ipv4.tcp_window_scaling=0

### Regex that matches path names
#  \/[^,:]*\.\w+ 

### Copy new differences to third directory
# diff -qr NewFiles/ OldFiles/ | awk '{print $2}' | egrep -v "in" | xargs -n1 -I R cp --parents R Location
# $ cp -pv --parents `git diff --name-only` DESTINATION-DIRECTORY

