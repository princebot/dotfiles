#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     go.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Set golang configuration.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If Go is not installed, skip the rest of this script.
go version &>/dev/null || return

# Set this to the directory you use for your Go workspace; by default, this just
# assumes it is ~/go if that directory exists.
if [[ -z ${GOPATH} && -d ~/go ]]; then
    export GOPATH=~/go
fi

# If GOPATH is not set, skip the rest of this script.
[[ -n ${GOPATH} ]] || return

# Add user-installed Go programs to PATH.
dotfiles.pathmunge "${GOPATH}/bin" after

# Change to a directory relative to $GOPATH/src.
function cdgo { cd "${GOPATH}/src/$1"; }
