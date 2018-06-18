#! /bin/bash
#
# Licensed under the Apache License 2.0
# author: wang.zhuowei
# Install vimrc file to your system
set -e
VIMRC_RTP=$(pwd) # vim plugin runtime path

########################################
# Echo help Info
# Arguments:
#     None
# Returns:
#     None
########################################
Help() {
    echo "usage: install.sh [-vh] [-a|b]"
    echo "        -v    Show version info"
    echo "        -h    Show help info"
    echo "        -b    Install basic vimrc for vim"
    echo "        -a    Install advanced vimrc for vim(with a lot of addon)"
    echo "        If no parameters are given, the basic is installed by default"
}

########################################
# Echo version info
# Arguments:
#     None
# Returns:
#     None
########################################
Version() {
    echo "version 0.1"
    echo "author: wang.zhuowei@foxmail.com"
}

########################################
# Install basic vimrc
# Arguments:
#     None
# Global
#     VIMRC_RTP
# Returns:
#     None
########################################
InstallBasic() {
    vimrc_path=~/.vimrc
    echo '" A powerful vim configuration for programmers' > ${vimrc_path}
    echo '" Last Change: 2018 June 15'>> ${vimrc_path}
    echo '" Maintainer: Wang Zhuowei <wang.zhuowei@foxmail.com>'>> ${vimrc_path}
    echo '" Basic:' >> ${vimrc_path}
    echo "set runtimepath+=${VIMRC_RTP}">> ${vimrc_path}
    echo "source ${VIMRC_RTP}/vimrcs/basic.vim">> ${vimrc_path}
    echo '' >> ${vimrc_path}
}

########################################
# Install advanced vimrc
# Arguments:
#     None
# Global
#     VIMRC_RTP
# Returns:
#     None
########################################
InstallAdvanced() {
    InstallBasic
    vimrc_path=~/.vimrc
    echo '" Advanced:' >> ${vimrc_path}
    echo "let g:vundle_rtp = '${VIMRC_RTP}/bundle/Vundle.vim'" >> ${vimrc_path}
    echo "source ${VIMRC_RTP}/vimrcs/advanced.vim">> ${vimrc_path}
}

# Main funciton
if [[ "$#" == "0" ]]
then
    Help
    exit
fi

while getopts abvh OPTION;do
    case $OPTION in
        a) InstallAdvanced; break ;;
        b) InstallBasic; break ;;
        v) Version; exit ;;
        h) Help; exit ;;
        ?) exit ;;
    esac
done

echo 'Installed the vimrc for vim is successfully! (QWQ)'
echo 'For more infomation, please read README.MD'
