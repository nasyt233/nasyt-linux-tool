#!/bin/bash
# 文件路径
FILE="cpolar_3.3.19-1_aarch64.deb"
# 检查文件是否存在
if [ -f "$FILE" ]; then
    echo "文件 $FILE 已存在。"
else
    echo "文件 $FILE 不存在，开始下载..."
# 文件不存在，执行下载操作
# 显示欢迎信息和联系方式
      clear
      echo -e "\e[1;34m-------------------------------------------------------\e[0m"
      echo -e "\e[1;34mNAS油条制作\e[0m"
      echo -e "\e[1;34mQQ:3213631396\e[0m"
      echo "按回车开始安装..."
      read
      clear
    curl -o "$FILE" http://termux.cpolar.com/dists/termux/extras/binary-aarch64/cpolar_3.3.19-1_aarch64.deb
    # 安装cpolar主体
    echo "开始安装cpolar主体..."
    dpkg -i cpolar_3.3.19-1_aarch64.deb
    if [ $? -ne 0 ]; then
    echo "安装失败，请检查错误信息。"
    exit 1
fi
echo "主体安装完成。"
clear
    if [ $? -ne 0 ]; then
        echo "下载失败，请检查网络连接。"
        exit 1
    fi
    echo "下载完成。"
fi
clear

cd cpolar
ll
yml="cpolar.yml"
if [ -f "$yml" ]; then
    echo "文件 $yml 已存在"
else
    echo "文件 $yml 不存在."


# 安装密钥并启动cpolar服务
read -p "请输入cpolar密钥:" my
cpolar authtoken $my
if [ $? -ne 0 ]; then
    echo "密钥安装失败，请检查错误信息。"
    bash cpolar/aarch64.sh
fi
clear
# 用户选择穿透类型
echo "请选择你要穿透的项目："
echo "1) http开网站"
echo "2) tcp联机用"
echo "3) ftp传文件"
echo "4) 退出"
read -p "请输入选项（1-4）: " opt
case $opt in
    1)
        echo 网站默认80
        echo "请输入端口号："
        read ht
        cpolar http $ht
        ;;
    2)
        echo MC默认25565
        
        echo "请输入端口号："
        read tc
        cpolar tcp $tc
        ;;
    3)
        echo 不知道用21
        echo "请输入端口号："
        read dk
        cpolar ftp $dk
        ;;
    4)
        echo "退出程序。"
        exit 0
        ;;
    *)
        echo "无效的选项，请输入1-4之间的数字。"
        exit 1
        ;;
esac
echo "脚本结束。"
