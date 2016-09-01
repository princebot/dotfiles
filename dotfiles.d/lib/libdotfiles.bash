#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     libdotfiles.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Bash library for dotfiles.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# This defines functions and variables core to the dotfiles implementation. To
# add new shell configuration, place a new a script in ~/.dotfiles.d rather than
# modifying this file unless you need to alter the startup process itself.


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Globals.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Booleans.
declare -xi DOTFILES_STARTUP_ALREADY_RAN
declare -xi DOTFILES_COLORS_SUPPORTED

# Strings.
declare -xl DOTFILES_OS_TYPE


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Functions.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initialize dotfiles features and source all scripts in ~/.dotfiles.d.
#
# If DOTFILES_STARTUP_ALREADY_RAN is nonzero, this does nothing. Likewise, if
# PS! is not set, this assumes the shell is noninteractive and does nothing.
#
# Arguments: None
# Globals:   DOTFILES_COLORS_SUPPORTED
#            DOTFILES_OS_TYPE
#            DOTFILES_STARTUP_ALREADY_RAN
# Returns:   None
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dotfiles.do_startup {
    if ((DOTFILES_STARTUP_ALREADY_RAN)) || [[ -z $PS1 ]]; then
        return
    fi

    {
        shopt -s extglob     # Enable extended syntax for glob pattern matching.
        shopt -s direxpand   # Put expanded value of directories in readline.
        shopt -s globstar    # Modify behavior of `**` in pathname expansion.
    } 2>/dev/null

    DOTFILES_OS_TYPE=$(dotfiles.os)
    dotfiles.configure_terminal

    # Source user startup scripts.
    for f in ~/.dotfiles.d/*.*sh; do
        if [[ -r $f && ! -d $f ]]; then
            source "$f"
        fi
    done

    # If ~/.dotfiles.d/bin or ~/bin exist and aren’t empty, append them to PATH.
    local d
    for d in ~/.dotfiles.d/bin ~/bin; do
        if [[ -n $(find "$d" -type f 2>/dev/null) ]]; then
            dotfiles.pathmunge "$d" after
        fi
    done

    dotfiles.print_motd
    DOTFILES_STARTUP_ALREADY_RAN=1
    return
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Return the operating system for the current machine.
#
# If this has been run before and DOTFILES_OS_TYPE is nonempty, dotfiles.os just
# returns DOTFILES_OS_TYPE. Otherwise, this usually returns `debian`, `redhat`,
# `darwin` (for Macs).
#
# If this is not a CentOS, RedHat, Debian, Ubuntu, or macOS system, this returns
# an ID value from /etc/os-release or a DISTRIB_ID value from /etc/lsb-release
# if those files exist; otherwise, dotfiles.os returns `unknown`.
#
# Arguments: None
# Globals:   DOTFILES_OS_TYPE
# Returns:   The operating-system type.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dotfiles.os {
    if [[ -n ${DOTFILES_OS_TYPE} ]]; then
        printf -- "${DOTFILES_OS_TYPE}"
        return
    fi

    local -l os
    while true; do
        if [[ -f /etc/centos-release ]]; then
            os=centos
            break
        elif [[ -f /etc/redhat-release && ! -L /etc/redhat-release ]]; then
            os=redhat
            break
        fi

        local -l out
        if [[ -f /etc/os-release ]]; then
            out=$(awk -F'=' '$1 == "ID" {print $2}' </etc/os-release)
        elif [[ -f /etc/lsb-release ]]; then
            out=$(awk -F'=' '$1 == "DISTRIB_ID" {print $2}' </etc/lsb-release)
        fi
        if [[ -n ${out} ]]; then
            # Strip quotation marks.
            os=$(printf -- "${out}" | sed 's/\"//g')
            break
        fi

        if [[ $(uname -s 2>/dev/null) == [Dd]arwin ]]; then
            os=darwin
            break
        fi
        os=unknown
        break
    done

    printf -- "${os}"
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set PS1 and shell options.
#
# If the shell environment supports colors, dotfiles.configure_terminal sets PS1
# to a colorized prompt and also sets DOTFILES_COLORS_SUPPORTED to 1. Otherwise,
# this sets a basic default prompt.
#
# Arguments: None
# Globals:   PS1
#            DOTFILES_COLORS_SUPPORTED
# Returns:   None
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dotfiles.configure_terminal {
    # Check window size after each command and update LINES and COLUMNS.
    shopt -s checkwinsize 2>/dev/null
    clear

    # If the terminal is colorable, set DOTFILES_COLORS_SUPPORTED to 1.
    if which tput &>/dev/null; then
        local -i n=$(tput colors 2>/dev/null)
        if ((n >=8)); then
            DOTFILES_COLORS_SUPPORTED=1
        fi
    fi

    if ((! DOTFILES_COLORS_SUPPORTED)); then
        PS1='[\t \u@\h \W]\$ '
        return
    fi

    local bold=$(tput bold)
    local green=$(tput setaf 2)
    local red=$(tput setaf 1)
    local reset=$(tput sgr0)
    PS1='\['${reset}'\]\[\033]1;@\h:\w\a\]\['${red}'\][\['${green}'\]\t '
    PS1+='\['${bold}'\]\['${red}'\]\u@\h \['${reset}${green}'\]\W\['${red}'\]'
    PS1+=']$ \['${reset}'\]'
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Prepend or append a directory to PATH.
#
# This re-implements the pathmunge function commonly found in /etc/profile and
# works exactly the same. Prepending is the default behavior; to append instead,
# add "after" as a second argument.
#
# If the directory has already been added to PATH, this is a noop.
#
# Arguments: $1 (required) => <directory path>
#            $2 (optional) => "after"
# Globals:   PATH
# Returns:   None
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dotfiles.pathmunge {
    local prog=${FUNCNAME}
    local usage="\
Usage: ${prog} directory [\"after\"]
Add a directory to PATH if it is not already present.

Use the optional \"after\" argument to append rather than prepend to PATH."

    if [[ -z $1 || $1 =~ ^--?h(elp)?$ ]]; then
        >&2 echo "${usage}"
        return
    fi

    if [[ ${PATH} =~ (^|:)"$1"($|:) ]]; then
        return
    fi

    if [[ $2 == after ]]; then
        PATH=${PATH}:$1
    else
        PATH=$1:${PATH}
    fi
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate and display the message of the day.
#
# Arguments: None
# Globals:   DOTFILES_COLORS_SUPPORTED
# Returns:   None
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function dotfiles.print_motd {
    local bold green reset underline white
    if ((DOTFILES_COLORS_SUPPORTED)); then
        bold=$(tput bold)
        cyan=$(tput setaf 6)
        green=$(tput setaf 2)
        reset=$(tput sgr0)
        underline=$(tput smul)
        white=$(tput setaf 7)
    fi
    
    # date +%H gives the hour padded with a 0 if it’s a single digit, i.e., 09.
    # Bash interprets this as octal and throws an obscure error when it’s 8 or
    # 9 AM — so strip the leading 0. 
    #
    # Oh, Bash.  ◔_◔
    local -i hour=$(date +%H | sed 's/^0//')

    local word
    if ((hour >= 2 && hour < 12 )); then
        word=morning
    elif ((hour >= 12 && hour < 18)); then
        word=afternoon
    else
        word=evening
    fi

    local hello="${bold}good ${word}, ${USER:-friend}"$'!'
    local arrow="${reset}${white}→ ${green}"
    local alias_cmd="${reset}${white}${bold}aliases${reset}${green}"
    local func_cmd="${reset}${white}${bold}functions${reset}${green}"
    local script_cmd="${reset}${white}${bold}scripts${reset}${green}"
    local url="${underline}${cyan}https://github.com/princebot/dotfiles${reset}"

    echo "
 ${arrow}  ${hello}
 ${arrow}
 ${arrow}  your shell has custom features; to list available enhancements, use
 ${arrow}  the ${func_cmd}, ${alias_cmd}, or ${script_cmd} commands.
 ${arrow}
 ${arrow}  source: ${url}
"
}
