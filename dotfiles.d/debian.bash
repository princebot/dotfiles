#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     debian.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Configuration specific to Debian-based systems.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# The rest of this file is copypasta from Ubuntu’s default ~/.bashrc — so if we
# are not on a Debian-based system, skip this script.
[[ $DOTFILES_OS_TYPE == debian ]] || return

# Make less play nice with non-text input files.
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support for ls.
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Enable Bash completion.
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi
fi
