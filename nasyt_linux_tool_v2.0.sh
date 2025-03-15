#!/bin/bash
#本脚本由NAS油条制作
dialog --title "菜单" --msgbox "欢迎使用NAS油条工具箱2.0"  15 20
clear
# 检查是否以 root 权限运行
if [[ $EUID -ne 0 ]]; then
   echo "建议使用 root 权限运行此脚本。" 
   read -p "回车键继续"
fi



uptime=$(uptime -p)
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


#简介
introduce() {
clear
echo -e "\e[1;34m       ______________\e[0m"
echo -e "\e[1;34m      ╱  NAS油条制作  ╲\e[0m"
echo -e "\e[1;34m     |  QQ:3213631396 |\e[0m"
echo -e "\e[1;34m      ╲QQ群:610699712 ╱\e[0m"
echo -e "\e[1;34m        ￣￣￣￣￣￣￣\e[0m"
}


#主菜单
show_menu() {
echo "欢迎使用NAS油条Linux工具箱"
echo
echo "请选择你要启动的项目："
br
echo "csh) 工具箱初始化"
echo "1) 系统查看菜单"
echo "2) 系统操作菜单"
echo "3) 网络工具"
echo "4) 暂无"
echo "10) 更多工具"
echo "0) 退出工具箱"
br
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
read -p "请输入选项: " show
     case $show in
       csh)
          csh;;
          #工具箱初始化
       1)
          #查看功能
          while true
          do
          look_menu
          read -p "请选择:" look_menu_xz
            case $look_menu_xz in
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
                    10) change_centos_to_aliyun;;
                    11) change_ubuntu_to_aliyun;;
                    12) change_debian_to_aliyun;;
                    13) create_user;;
                    14) show_connected_ips_count;;
                    15) change_hostname;;
                    16) update_repo;;
                    17) show_login_ips;;
                    0) break;;
                    *) echo "无效的输入。";;
                esac
            done
          ;;
       3)
          Internet_tool
          read -p "请输入选项: " Internet_tool
             case $Internet_tool in
               1) ping2;;
               2) cc;;
             esac
          ;;
       0)
          #退出循环
          break
          ;;
       *)
          echo "无效的输入。"
          esc
          ;;
     esac
done