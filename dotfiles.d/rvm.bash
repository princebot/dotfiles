#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     rvm.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set Ruby Version Manager (RVM) configuration.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If RVM is installed, load it.
if [[ -d ~/.rvm/bin && -s ~/.rvm/scripts/rvm ]]; then
    dotfiles.pathmunge ~/.rvm/bin after
    source ~/.rvm/scripts/rvm
fi
