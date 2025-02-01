clear
echo "<NAS油条制作宝塔安装>"
echo "1) 通用安装"
echo "2) Centos OpenCloud Alibaba系统"
echo "3) Debian系统"
echo "4) Ubuntu或Deepin系统"
echo "5) Windows系统bt安装包"
echo "0) 返回"
read -p "请选择安装方式" btinstall
case $btinstall in
1) if [ -f /usr/bin/curl ];then curl -sSO https://download.bt.cn/install/install_panel.sh;else wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh;fi;bash install_panel.sh ed8484bec ;;
2) url=https://download.bt.cn/install/install_panel.sh;if [ -f /usr/bin/curl ];then curl -sSO $url;else wget -O install_panel.sh $url;fi;bash install_panel.sh ed8484bec ;;
3) wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh && bash install_panel.sh ed8484bec ;;
4) wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh && sudo bash install_panel.sh ed8484bec ;;
5) curl -o BTSoft.zip https://download.bt.cn/win/panel/BtSoft.zip ;;
0) exit 0 ;;
esac
echo 脚本结束。