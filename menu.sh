while true
do
clear
echo "请选择要安装的脚本。"
echo -e "\e[1;34m------------------\e[0m"
echo "1) 安装NAS油条Termux_Linux工具箱(旧)"
echo "2) 安装NAS油条Linux工具箱(最新)"
echo "0) 退出"
echo -e "\e[1;34m------------------\e[0m"
read -p "请选择:" menu
case $menu in
1) git clone https://gitee.com/nasyt/nasyt-linux-tool.git;bash nasyt-linux-tool/nasyt-linux-tool.sh;;
2) sudo curl -o /usr/bin/nasyt nasyt.class2.icu/shell/nasyt_linux_tool_v2.0.sh;sudo chmod 777 /usr/bin/nasyt;sudo nasyt ;;
0) break;;
*) echo "";echo "无效的输入。";read -p "回车键返回。"
esac
done