#! /bin/bash
#
# Licensed under the Apache License 2.0
# author: wang.zhuowei
# Uninstall vimrc file from your system and clean all related files

set -e

########################################
# Uninstall vimrc and git files
# Arguments:
#     None
# Returns:
#     None
########################################
RemoveVimrcAndGit() {
    rm -rf ~/.vimrc
    rm -rf $(pwd)
}

########################################
# Restore old vimrc
# Arguments:
#     None
# Returns:
#     None
########################################
RestoreOldVimrc() {
    if [[ -f ~/.vimrc-coding.bak ]]
    then
        mv ~/.vimrc-coding.bak ~/.vimrc
    fi
}

RemoveVimrcAndGit
RestoreOldVimrc

echo 'Uninstalled the vimrc configuration is successfully! (QWQ)'
