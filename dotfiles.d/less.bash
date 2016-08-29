#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     less.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Settings for the less pager.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

which less &>/dev/null || return

# Disable saving less history to disk.
export LESSHISTFILE=/dev/null
