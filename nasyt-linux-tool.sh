#!/bin/bash
#本脚本由NAS油条制作
clear
cd nasyt-linux-tool
bash ./neofetch
cd ..
echo -e "\e[1;34m       ______________\e[0m"
echo -e "\e[1;34m      ╱  NAS油条制作  ╲\e[0m"
echo -e "\e[1;34m     |  QQ:3213631396 |\e[0m"
echo -e "\e[1;34m      ╲QQ群:610699712 ╱\e[0m"
echo -e "\e[1;34m        ￣￣￣￣￣￣￣\e[0m"
#read -p "回车键启动↘"
#clear
echo "欢迎使用NAS油条Linux工具箱"
echo
echo "请选择你要启动的项目："
echo -e "\e[1;34m------------------\e[0m"
echo "1) 工具箱初始化"
echo "2) TMOE工具"
echo "3) 启动Linux<tmoe>"
echo "4) 内网穿透工具"
echo "5) 启动ping工具"
echo "6) 安装DDOS攻击"
echo "7) 启动CC攻击"
echo "8) 安装宝塔面板"
echo "9) 安装Docker容器"
echo "10) 安装云崽机器人"
echo "11) 更多工具"
echo "0) 退出工具箱"
echo -e "\e[1;34m------------------\e[0m"
read -p "请输入选项（0-11）: " opt
case $opt in
1)
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
apt upgrade ;;
1) clear | startvnc ;;
2) bash nasyt-linux-tool/tmoe/tmoe.sh ;;
3) clear | debian ;;
4) bash nasyt-linux-tool/cpolar/install.sh ;;
5)
clear
read -p "网站地址:" ping
ping $ping ;;
6) bash nasyt-linux-tool/ddos/ddos.sh ;;
7) bash nasyt-linux-tool/cc/cc.sh ;;
8) bash nasyt-linux-tool/bt/bt_install.sh ;;
9) bash <(curl -sSL https://linuxmirrors.cn/docker.sh) ;;
10) clear | bash <(curl -L gitee.com/TimeRainStarSky/TRSS_AllBot/raw/main/Install-Docker.sh) ;;
11) bash nasyt-linux-tool/tool/tool.sh ;;
0) exit 0 ;;
*) echo "无效的选项，请输入1-14之间的数字。" ;;
esac
echo "脚本结束。"
sleep 1s
bash nasyt-linux-tool/nasyt-linux-tool.sh
