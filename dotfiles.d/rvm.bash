#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     rvm.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set Ruby Version Manager (RVM) configuration.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [[ -d ~/.rvm/bin && -s ~/.rvm/scripts/rvm ]]; then
    dotfiles.pathmunge ~/.rvm/bin  # activate RVM
    source ~/.rvm/scripts/rvm      # load RVM into shell as a function
fi
