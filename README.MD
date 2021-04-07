## Coder Vimrc

## Table of Contents

- [About](#about)
- [Install](#install)
- [Docs](#docs)

## About

本项目为一个为程序员编写的一个vimrc配置包 ,包含一些基本设置以及很多功能强大的实用插件。从Linux到Windows，从终端到GUI版本的*Vim*均支持，通过简单的安装步骤即可将配置包安装到您的电脑上。

本配置集合提供如下功能:

## Install

第一步, 首先将**cvimrc**从github上拉取到任意一个目录, 假设为~/cvimrcs:
    git clone --recursive https://github.com/Chinazwking/cvimrc ~/vimrcs

第二步, 进入~/vimrcs目录, 执行脚本(以下两种命令根据情况选择一个):

* *./install.sh -b*  # 安装basic版, 适用于终端的vi和不支持复杂功能的vim

* *./install.sh -a*  # 安装advanced版, 完整的命令, 映射, 插件支持

执行命令后会在~目录生成.vimrc文件, 已存在的.vimrc文件会被重命名为 .vimrc-coder.bak。

第三步, 如果安装的是basic版, 那么安装已经结束; 如果安装的是advanced版, 那么
还要进行额外的插件配置, 进入vi后输入如下命令:
    *:PluginInstall*

**注意:**  Windows下安装可以使用git的bash模式, 此模式可以执行bash脚本, 所以不再
针对Windows系统编写安装脚本。

## Docs

具体文档，请在进入**Vim**后, 输入:*help* *cvimrc*来了解关于此插件的一切。如果您的vi不支持*help*命令, 那么请在repository的doc目录下查看coder-vim-rc.cnx文档。
