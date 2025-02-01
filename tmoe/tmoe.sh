clear
echo "1) 启动tmoe"
echo "2) 安装tmoe"
echo "0) 退出"
read -p "请选择: " opt
case $opt in
1) tmoe ;;
2) bash -c "$(curl -L gitee.com/mo2/linux/raw/2/2)" ;;
0) cd ../nasyt-linux-tool.sh
*) bash tmoe.sh ;;
esac
echo 脚本结束。