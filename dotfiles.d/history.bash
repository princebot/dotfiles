#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     history.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Bash history settings.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{
    shopt -s histappend  # Append to HISTFILE rather than overwrite.
    shopt -s cmdhist     # Add multiline commands as single history entries.
    shopt -s lithist     # Preserve newlines in multiline history entries.
} 2>/dev/null

# Format HISTFILE lines as <year>-<month>-<day>T<hour>:<minute> <history entry>.
HISTTIMEFORMAT="%Y-%m-%dT%H:%M  "

# Don’t save commands that duplicate previous command or begin with a space.
HISTCONTROL=ignoreboth

# Don’t save these commands.
HISTIGNORE="ls:ll:exit:logout:clear:history:jobs:export *"

# Maximum number of commands to save in HISTFILE.
HISTSIZE=1000

# Maximum line count allowed for HISTFILE.
HISTFILESIZE=2000
