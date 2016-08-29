#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     gpg.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Configuration for gpg.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if which gpg &>/dev/null; then
    # If gpg is installed, set GPG_TTY.
    export GPG_TTY="$(tty)"
    if which gpg2 &>/dev/null; then
        # If gpg and gpg2 are installed, alias gpg to gpg2.
        alias gpg=gpg2
    fi
fi
