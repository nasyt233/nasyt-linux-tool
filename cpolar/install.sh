clear
# 用户选择穿透类型
echo "选择你的框架"
echo "1) AMD通用安装"
echo "2) Aarch64"
echo "0) 退出"
read -p "请输入选项（1-2）: " opt
case $opt in
1) curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash ;;
2) bash nasyt-linux-tool/cpolar/aarch64.sh ;;
0) exit 1 ;;
*) echo "无效的输入。" ;;
esac
sleep 1s
echo "脚本结束。"
