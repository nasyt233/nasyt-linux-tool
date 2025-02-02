#!/bin/bash
clear
echo "1) 安装curl"
echo "2) 安装git"
echo "3) 安装nginx"
echo "4) 安装sl"
echo "5) 安装alist"
echo "6) 安装frp内网穿透"
echo "11) 切换清华源"
echo "0) 退出"
read -p "请选择:" xz
case $xz in
1) pkg install -y curl ;;
2) pkg install -y git ;;
3) pkg install -y nginx ;;
4) pkg install -y sl ;;
5) pkg install -y alist ;;
6) echo 暂未更新。 ;;
11) sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list ;;
0) exit ;;
*) echo "无效的输入。" ;;
esac
bash nasyt-linux-tool/tool/tool.sh
sleep 1s
