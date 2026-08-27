#!/usr/bin/env bash

# nasyt 命令 bash 补全脚本
_nasyt_completions() {
    local cur prev words cword
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD
    cur="${words[$cword]}"
    prev="${words[$((cword - 1))]}"

    case "$prev" in
        # acg 图片输出，子参数：pc横屏、pe竖屏、help帮助
        -a|--acg)
            COMPREPLY=($(compgen -W "pc pe help" -- "$cur"))
            return 0
            ;;
        # 文字转语音，仅补全help
        -e|--edge_tts)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # twitter视频下载，补全链接前缀和帮助
        -x|--dowx)
            COMPREPLY=($(compgen -W "http:// https:// help" -- "$cur"))
            return 0
            ;;
        # 备份恢复脚本
        -b|--backup)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 多线程下载
        -c|--aria2c)
            COMPREPLY=($(compgen -W "http:// https://" -- "$cur"))
            return 0
            ;;
        # docker管理
        -d|--docker)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 文件搜索工具
        -f|--find)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # JM本子下载
        -j|--jmcomic)
            COMPREPLY=($(compgen -W "350234 350235" -- "$cur"))
            return 0
            ;;
        # 跳过检测设置
        -k|--skip)
            COMPREPLY=($(compgen -W "true false" -- "$cur"))
            return 0
            ;;
        # 彩色输出模式
        -l|--lolcat)
            COMPREPLY=($(compgen -W "true false" -- "$cur"))
            return 0
            ;;
        # 快捷换软件源
        -m|--mirror)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 生成网页目录结构
        -n|--nlist)
            COMPREPLY=($(compgen -W "\$HOME" -- "$cur"))
            return 0
            ;;
        # proot容器管理
        -p|--proot)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 卸载本脚本工具
        -r|--remove)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # ssh管理工具
        -s|--ssh)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # tmux后台管理
        -t|--tmux)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 更新脚本至最新
        -u|--update)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 输出脚本版本
        -v|--version)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # B站YT视频下载
        -y|--bili)
            COMPREPLY=($(compgen -W "http:// https://" -- "$cur"))
            return 0
            ;;
        # shell管理工具
        -z|--zsh)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        # 独立长选项参数
        --astrbot|--cpolar|--color|--stop|--sh|--sfs|--lang|--log|--jv|--sec|--turn|--test|--debug|--config|--yml|--ps)
            COMPREPLY=($(compgen -W "help" -- "$cur"))
            return 0
            ;;
        *)
            # 所有选项补全
            COMPREPLY=($(compgen -W "\
-a --acg \
-b --backup \
-c --aria2c \
-d --docker \
-e --edge_tts \
-f --find \
-h --help \
-j --jmcomic \
-k --skip \
-l --lolcat \
-m --mirror \
-n --nlist \
-p --proot \
-r --remove \
-s --ssh \
-t --tmux \
-u --update \
-v --version \
-x --dowx \
-y --bili \
-z --zsh \
--astrbot \
--cpolar \
--color \
--stop \
--sh \
--sfs \
--lang \
--log \
--js \
--jv \
--sec \
--turn \
--test \
--debug \
--config \
--yml \
--ps" -- "$cur"))
            return 0
            ;;
    esac
}

# 绑定补全函数到 nasyt 命令
complete -F _nasyt_completions nasyt
