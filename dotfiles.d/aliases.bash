#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     aliases.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set general Bash aliases.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Directory movement.
alias -- '-'='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# Directory listing.
if [[ $DOTFILES_OS_TYPE == darwin ]]; then
    alias ll='ls -lthraG'
else
    alias ll='ls -lthra --color=auto'
fi
alias lls='ll -S'
alias lli='ll -i'
alias llr='ll -R'

# Child-proofing. (╯°□°)╯︵ ┻━┻
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Miscellaneous.
alias ?='man'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias less='less -R'
alias mkdir='mkdir -p'
