#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     functions.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Convenience functions and aliases for using git.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

which git &>/dev/null || return

# Shortcut for listing one-line summary of all commits.
alias gl='git log --oneline --decorate'
