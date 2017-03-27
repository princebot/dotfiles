#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:     functions.bash
# Author:   prince@princebot.com
# Source:   https://github.com/princebot/dotfiles
# Synopsis: Shell utility functions.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Change directories and do a long listing.
function cdl { cd "${1:-$HOME}" && ll; }

# Create a directory and change to it.
function mcd { mkdir -p "$1" && cd "$1"; }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# List all alias names and definitions.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function aliases {
    local bold reset
    if ((DOTFILES_COLORS_SUPPORTED)); then
        bold=$(tput bold)
        reset=$(tput sgr0)
    fi

    # Calculate column display padding by storing character count of longest
    # alias as $width.
    local -a words=($(alias | awk -F'[[:space:]]+|=' '{print $2}'))
    local -i width n
    local w
    for w in "${words[@]}"; do
        n=${#w}
        if ((width < n)); then
            width=$n
        fi
    done

    echo
    local fmt=${reset}${bold}"\t%-${width}s"${reset}
    local line name def
    while read -r line; do
        line=${line##alias }
        name=$(printf -- "${line}" | awk -F'=' '{print $1}')
        def=$(printf -- "${line}" | awk -F'=' '{print $2}' | sed "s/'//g")
        printf -- "${fmt} =>  ${def}\n" "${name}"
    done < <(alias)
    echo
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Edit common system- or user-level configuration files.
#
# Usage: edit hosts
#        edit git|local.git|user.git
#        edit ssh|user.ssh
#        edit sshd
#
# Files that have multiple versions accept an optional namespace , e.g., edit
# user.ssh. This defaults to the system namespace when omitted, and editing
# system files will require sudo access.
#
# Currently supported files:
#
#     hosts        => /etc/hosts
#     git
#       local.git  => $(pwd)/config
#       system.git => /etc/gitconfig
#       user.git   => ~/.config/git/config
#     ssh
#       system.ssh => /etc/ssh/ssh_config
#       user.ssh   => ~/.ssh/config
#     sshd         => /etc/ssh/ssh_config
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function edit {
    local namespace
    local target
    if [[ $1 =~ \. ]]; then
        namespace=$(printf -- "$1" | cut -d '.' -f 1)
        target=$(printf -- "$1" | cut -d '.' -f 2)
    else
        namespace="system"
        target=$1
    fi

    local config
    case ${target} in
        hosts)
            config="/etc/hosts" ;;
        git)
            case ${namespace} in
                local)  config="$(pwd)/.git/config" ;;
                system) config="/etc/gitconfig" ;;
                user)   config="${HOME}/.config/git/config" ;;
            esac ;;
        ssh)
            case ${namespace} in
                system) config="/etc/ssh/ssh_config" ;;
                user)   config="${HOME}/.ssh/config" ;;
            esac ;;
        sshd)
            config="/etc/ssh/sshd_config" ;;
        *)
            >&2 echo "unknown target ${target}"
            return 1 ;;
    esac

    local editor="${VISUAL:-vim}"
    if [[ ${namespace} == system ]] && (($(id -u) != 0)); then
        sudo ${editor} "${config}"
    else
        ${editor} "${config}"
    fi
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Extract archives based on file extension.
#
# This parses file extensions to determine program to use for extraction and
# places extracted files in a new directory named after the archive.
#
# Supported types: tar, tar.gz, tar.bz2, gz, bz2, rar, tbz2, tgz, zip, Z, 7z
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function extract {
    local usage="\
Usage: extract file [file ...]
Extract archives based on file extension.

Supported file types: tar, tar.gz, tar.bz2, gz, bz2, rar, tbz2, tgz, zip, Z, 7z"

    if [[ -z $1 || $1 =~ ^--?h(elp)?$ ]]; then
        >&2 echo "${usage}"
        return
    fi

    while (($# > 0)); do
        if [[ ! -r $1 ]]; then
            >&2 echo "extract: cannot read $1"
            return 1
        fi
        case $1 in
            *.tar.bz2)   tar xvjf "$1"   ;;
            *.tar.gz)    tar xvzf "$1"   ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar x "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xvf "$1"    ;;
            *.tbz2)      tar xvjf "$1"   ;;
            *.tgz)       tar xvzf "$1"   ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *)
                >&2 echo "extract: unrecognized file type for $1"
                >&2 echo "${usage}" 
                return 1
        esac

        if (($?)); then
            >&2 echo "extract: cannot extract $1"
            return 1
        fi
        shift
    done
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# List the functions defined in this file along with a short help string.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function functions {
    local bold reset f
    if ((DOTFILES_COLORS_SUPPORTED)); then
        bold=$(tput bold)
        reset=$(tput sgr0)
        fmt=${reset}${bold}"%-9s"${reset}
    fi

    echo
    printf -- "    ${fmt} — display all alias names and definitions\n"  aliases
    printf -- "    ${fmt} — change directories and do a long listing\n" cdl
    printf -- "    ${fmt} — edit system configuration files as root\n"  edit
    printf -- "    ${fmt} — extract archives based on file extension\n" extract
    printf -- "    ${fmt} — create a directory and change to it\n"      mcd
    printf -- "    ${fmt} — swap two files\n"                           swap
    printf -- "    ${fmt} — go up n directories (default 1)\n"          up
    printf -- "    ${fmt} — display current public and private IPs\n"   whereami
    echo
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# List the scripts included in ~/.dotfiles.d/bin with a short help string.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function scripts {
    >&2 echo "not yet implemented :("
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Swap two files..
#
# Usage: swap file file
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function swap {
    if (($# != 2)) || [[ -z $1 || -z $2 ]]; then
        >&2 echo "swap: wrong number of files"
        return 1
    elif [[ -d $1 || -d $2 ]]; then
        >&2 echo "swap: cannot swap directories"
        return 1
    fi

    local tmp=${1}.dotfiles.swap.tmp.${RANDOM}
    if ! cat "$1" > "${tmp}"; then
        >&2 echo "cannot copy $1 to temp file"
        return 1
    fi
    if ! cat "$2" > "$1"; then
        >&2 echo "cannot copy $2 to $1"
        rm -f -- "${tmp}"
        return 1
    fi
    if ! mv -f "${tmp}" "$2"; then
        mv -f "${tmp}" "$1"
        >&2 echo "cannot copy temp file ${tmp} to $2"
        return 1
    fi
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Go up n directories (default 1)
#
# Usage: up n
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function up {
    if [[ -z $1 ]]; then
        cd ..
        return
    fi
    local -i n=$1
    for ((; i > 0; i--)); do
        cd ..
    done
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Display current public and private IPv4 addresses.
#
# If curl or wget are available, this makes an API call to ipify.org to get the
# the current public IP.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function whereami {
    local public_ip
    if which curl &>/dev/null; then
        public_ip=$(curl -s https://api.ipify.org)
    elif which wget &>/dev/null; then
        public_ip=$(wget -q -O - https://api.ipify.org)
    fi
    printf -- "\nPublic IP:\n${public_ip:-unknown}\n\n"

    # Iterate the network interfaces and make a list of device names. This works
    # on modern *nixes with ip addr or on macOS with BSD flags for ifconfig —
    # but nothing else.
    local -a ifaces
    if ip addr &>/dev/null; then
        IFS=$'\n'
        ifaces=($(ip addr show scope global | awk '/inet / {print $NF, $2}'))
        IFS=$' \t\n'
    else
        local i
        # Note: This ignores loopback interfaces.
        for i in $(ifconfig -u -l); do
            IFS=$'\n'
            ifaces+=($(ifconfig "$i" \
                       | grep -F 'inet ' \
                       | awk '$2 !~ /^127/ && $2 !~ /\.1$/' \
                       | awk '{print "'"${i}"'", $2}'))
            IFS=$' \t\n'
        done
    fi 2>/dev/null

    local -i len=${#ifaces[@]}
    ((len)) && echo "Local IPs:" || echo "Local IP:"
    if ((len)); then
        local i dev private_ip 
        for i in "${ifaces[@]}"; do
            dev=$(echo "$i" | awk '{print $1}' )
            private_ip=$(echo "$i" | awk '{print $2}')
            printf -- "%-15s -> %s\n" "${private_ip%/*}" "${dev}"
        done
    else
        echo "none / unknown"
    fi
    echo
}

