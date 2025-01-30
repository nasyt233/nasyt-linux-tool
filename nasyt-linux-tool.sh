clear #清屏
echo 欢迎使用NAS油条Linux工具箱
echo -e "\e[1;34m-------------------------------------------------------\e[0m"
echo -e "\e[1;34m-------------------------------------------------------\e[0m"
echo -e "\e[1;34mNAS油条制作\e[0m"
echo -e "\e[1;34mQQ:3213631396\e[0m"
echo -e "\e[1;34mQQ群:610699712\e[0m"
read -p 回车键启动
# 用户选择穿透类型
clear
echo "请选择你要启动的项目："
echo "1) 启动Ubuntu桌面"
echo "2) 启动TMOE管理工具"
echo "3) 启动Linux系统"
echo "4) 启动内网穿透"
echo "5) 启动ping工具"
echo "6) 退出工具箱"
read -p "请输入选项（1-4）: " opt
case $opt in
    1)
        echo 正在启动桌面。
        clear
        startvnc
        bash /data/data/com.termux/files/启动.sh
        ;;
    2)
        echo 正在启动Linux工具。
        clear
        tmoe
        ;;
    3)
        echo 正在启动Linux系统。
        debian
        ;;
    4)
        echo 正在启动内网穿透
        clear
        bash cpolar.sh
        bash /data/data/com.termux/files/启动.sh
        ;;
    5)
        echo 正在启动ping
        clear
        read -p "网站地址:" ping
        ping $ping
        bash /data/data/com.termux/files/启动.sh
        ;;
    6)
        echo 退出程序
        exit 0
        ;;
    *)
        echo "无效的选项，请输入1-4之间的数字。"
        exit 1
        ;;
esac
sleep 1s
echo "脚本结束。"
sleep 2s
clear
sleep 1s
bash /data/data/com.termux/files/启动.sh
