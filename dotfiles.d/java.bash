#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     functions.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set JAVA_HOME for macOS systems.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [[ DOTFILES_OS_TYPE == darwin ]] && which /usr/libexec/java_home; then
    export JAVA_HOME=/usr/libexec/java_home
fi &>/dev/null
