dotfiles
========
_bash startup files and vim configuration_
<br>  


## quickstart

```bash
git clone https://github.com/princebot/dotfiles
bash dotfiles/installer/install
```

## requirements

- macOS/OS X, Debian/Ubuntu, or Red Hat/CentOS
- Bash 4.x

These may work in other environments without modification, but that has not been
tested.

(**Note for Mac users:** Macs ship with an old version of Bash due to licensing
issues, so use [homebrew](http://brew.sh) to install Bash 4.x first.)


## details

The installer does the following:

- backs up existing <tt>~/.bash_profile</tt>, <tt>~/.bashrc</tt>, <tt>/~/.bash_logout</tt>, and <tt>~/.vimrc</tt>
- copies <tt>profile</tt> to <tt>~/.bashrc</tt>
- hard links <tt>~/.bashrc</tt> to <tt>~/.bash_profile</tt>
- copies <tt>vimrc</tt> to <tt>~/.vimrc</tt>
- copies <tt>dotfiles.d</tt> to <tt>~/.dotfiles.d/</tt>

New shells will source the main configuration in <tt>~/.config/dotfiles/lib/dotfiles.bash</tt>,
which in turn sources every file matching <tt>~/.dotfiles.d/\*.\*sh</tt>. 

To add new configuration, create a new file in <tt>~/.dotfiles.d</tt> to be 
sourced with all the others; for example, to add [Visual Studio Code](https://code.visualstudio.com/)
configuration, you might create a <tt>~/.dotfiles.d/vscode.bash</tt> file.
