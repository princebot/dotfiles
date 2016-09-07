#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     conda.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Configure Anaconda Python if installed.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Determine if an Anaconda Python is installed. If one is, add its bin directory
# to the beginning of PATH so that it is used instead of the system Python.
#
# When multiple installations exist, prefer Anaconda to Miniconda and Python 2.x
# to Python 3.x.
for path in ~/{ana,mini}conda{2,,3}; do
    if [[ -d ${path} && -x ${path}/bin/conda && -x ${path}/bin/python ]]; then
        dotfiles.pathmunge "${path}/bin"
        break
    fi
done

if [[ -d ${path}/envs/py3 ]]; then
    alias py3='source activate py3'
elif [[ -d ${path}/envs/py2 ]]; then
    alias py2='source activate py2'
fi 2>/dev/null

unset -v path
