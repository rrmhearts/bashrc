
#!/usr/bin/env bash

# Splash
timg `find ~/Pictures/ -name coolmount.png 2>&1 | grep -v "Permission denied" | head -n 1`

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

# Scroll past splash screen
for i in {1..40}
do
   echo 
done

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
