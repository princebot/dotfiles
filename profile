#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:        bashrc / bash_profile
# Author:      prince@princebot.com
# Source:      https://github.com/princebot/dotfiles
# Description: Startup script for interactive shells.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Note: ~/.bashrc and ~/.bash_profile are the same file.

# Source the dotfiles library if the current shell or one of its ancestors has
# not already done so.
if [[ -r ~/.config/dotfiles/lib/dotfiles.bash ]]; then
        source ~/.config/dotfiles/lib/dotfiles.bash
else
    echo "dotfiles: missing library file ~/.config/dotfiles/lib/dotfiles.bash"
    echo "dotfiles: reinstall from https://github.com/princebot/dotfiles"
    return 1
fi >&2

# Run all startup scripts.
dotfiles.do_startup

# Poorly behaved programs may append lines to this file with or without user
# permission, so add a defensive return.
return
