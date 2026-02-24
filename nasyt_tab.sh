#!/usr/bin/env bash

# 定义补全函数
_nasyt_completions() {
    # 手动初始化变量
    local cur prev words cword
    # COMP_WORDS 是一个数组，包含了当前命令行的所有词
    # COMP_CWORD 是当前光标所在的词的索引
    # 通过以下方式手动提取
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD
    cur="${words[$cword]}"
    prev="${words[$((cword - 1))]}"

    # 根据不同的上下文生成补全列表
    case "$prev" in
        -e|--edge-tts|edge-tts)
            COMPREPLY=$(compgen -W "help" "$cur")
            return 0
            ;;
        -a|--acg)
            COMPREPLY=$(compgen -W "pc pe help" "$cur")
            return 0
            ;;
        -x|--dowx|--twitter)
            COMPREPLY=$(compgen -W "http:// https:// help" "$cur")
            return 0
            ;;
        -i|--input)   # 如果前一个词是 -i 或 --input，补全文件路径
            COMPREPLY=($(compgen -f -X '!*.txt' -- "$cur"))
            return 0
            ;;
        -o|--output)  # 如果前一个词是 -o 或 --output，补全目录
            COMPREPLY=($(compgen -d -- "$cur"))
            return 0
            ;;
        -m|--mode)   # 如果前一个词是 -m 或 --mode，补全固定选项
            COMPREPLY=($(compgen -W "fast slow medium" -- "$cur"))
            return 0
            ;;
        start|stop|restart) # 子命令的补全
            COMPREPLY=($(compgen -W "start stop restart status" -- "$cur"))
            return 0
            ;;
        *)
            # 默认情况：补全主命令的子命令或全局选项
            COMPREPLY=($(compgen -W "--acg --backup --docker --edge-ttsp --help --mirror --ncdu --remove --skip --tmux --update --version --twitter"  "$cur"))
            return 0
            ;;
    esac
}

# 注册补全函数
complete -F _nasyt_completions nasyt
