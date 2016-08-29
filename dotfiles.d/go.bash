#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     functions.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set JAVA_HOME for macOS systems.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

which go version &>/dev/null || return

# Change to a directory relative to $GOPATH/src.
function cdgo { cd "${GOPATH}/src/$1"; }