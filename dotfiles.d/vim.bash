#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     vim.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Settings for Vim.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

which vim &>/dev/null || return

alias vi=vim
export EDITOR=vim
export VISUAL=vim
