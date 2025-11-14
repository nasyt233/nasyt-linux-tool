#!/bin/bash
# 本脚本由NAS油条制作
# NAS油条的实用脚本
#欢迎加入NAS油条赤石技术交流群
#有什么赤石技术可以进来交流
#赤石群号:610699712

time_date="2025/11/1"
version="v2.4.1.7"
nasyt_dir="$HOME/.nasyt" #脚本工作目录
source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置
bin_dir="usr/bin" #bin目录

# 主菜单
menu_jc() {
    menu() {
        clear
        while true
        do
            clear; clear
            echo
            # 根据时间返回问候语
            get_greeting
            version_update >/dev/null 2>&1
            if command -v figlet >/dev/null 2>&1; then
                figlet N A S
            fi
            check_Script_Install
            br
            echo "感谢QQ:2738136724做出贡献。"
            br
            if command -v nasyt &> /dev/null
            then
               echo "1) Linux工具箱 (更新)"
               echo "2) Linux工具箱 (启动)"
            else
               echo "1) Linux工具箱 (安装)"
               echo "2) Linux工具箱 (启动)"
            fi
            if command -v nasyt >/dev/null 2>&1; then
                echo "3) Linux工具箱 (卸载)"
            fi
            echo "0) 退出"
            br
            gx_show 
            read -p "请选择(回车键默认): " menu
            clear
            case $menu in
                1)
                    gx; esc ;;
                2) 
                    break ;;
                3)
                    shell_uninstall;esc ;;
                0) 
                    exit 0 ;;
                *)
                    break ;;
            esac
        done
    }
    
    menu
}

# 检查包管理器的函数
check_pkg_install() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release #加载变量
    fi
    if command -v termux-info >/dev/null 2>&1; then
        sys="(Termux 终端)"
        PRETTY_NAME="Termux终端"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list >/dev/null
        pkg_install="pkg install"
        pkg_remove="pkg remove"
        pkg_update="pkg update"
        deb_sys="pkg"
        yes_tg="-y"
        
    elif command -v apt-get >/dev/null 2>&1; then
        sys="(Debian/Ubuntu 系列)"
        pkg_install="sudo apt install"
        pkg_remove="sudo apt remove"
        pkg_update="sudo apt update"
        sudo_setup="sudo"
        deb_sys="apt"
        yes_tg="-y"
        
    elif command -v dnf >/dev/null 2>&1; then
        sys="(Fedora/RHEL/CentOS 8 及更高版本)"
        pkg_install="sudo dnf install"
        pkg_remove="sudo dnf remove"
        pkg_update="sudo dnf update"
        sudo_setup="sudo"
        deb_sys="dnf"
        yes_tg="-y"
        
    elif command -v yum >/dev/null 2>&1; then
        sys="(Fedora/RHEL/Rocky/CentOS 7 及更早版本)"
        pkg_install="sudo yum install"
        pkg_remove="sudo yum remove"
        pkg_update="sudo yum update"
        sudo_setup="sudo"
        deb_sys="yum"
        yes_tg="-y"
        
    elif command -v pacman >/dev/null 2>&1; then
        sys="(Arch Linux 系列)"
        pkg_install="sudo pacman -S"
        pkg_remove="sudo pacman -R"
        sudo_setup="sudo"
        deb_sys="pacman"
        yes_tg="-y"
        
    elif command -v zypper >/dev/null 2>&1; then
        sys="(openSUSE 系列)"
        pkg_install="sudo zypper in -y"
        pkg_remove="sudo zypper rm"
        sudo_setup="sudo"
        deb_sys="zypper"
        yes_tg="-y"
        
    elif command -v apk >/dev/null 2>&1; then
        sys="(Alpine/PostmarketOS系统)"
        sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
        pkg_install="sudo apk add"
        pkg_remove="sudo apk del"
        sudo_setup="sudo"
        deb_sys="apk"
        yes_tg=""
        
    elif command -v emerge >/dev/null 2>&1; then
        sys="(gentoo/funtoo 系统)"
        pkg_install="sudo emerge -avk"
        pkg_remove="sudo emerge -C"
        sudo_setup="sudo"
        deb_sys="emerge"
        yes_tg="-y"
        
    elif command -v brew >/dev/null 2>&1; then
        sys="(MacOS 系统)"
        pkg_install="sudo brew install"
        sudo_setup="sudo"
        deb_sys="brew"
        yes_tg="-y"
        read -p "抱歉，目前没有完全适配MacOS系统"
        
    else
        echo -e "$(info) >_<未检测到支持的系统。"
        read -p "但是脚本依然可以运行。"
        br
    fi
}

# 全部变量
# 定义颜色变量
color_variable() {
    color='\033[0m'
    green='\033[0;32m'
    blue='\033[0;34m'
    red='\033[31m'
    yellow='\033[33m'
    grey='\e[37m'
    pink='\033[38;5;218m'
    cyan='\033[96m'
}

all_variable() {
    
    OUTPUT_FILE="nasyt" # 下载文件名
    time_out=10  # curl超时时间（秒）
    urls=(
      "https://gitee.com/nasyt/nasyt-linux-tool/raw/master/nasyt.sh"   # 主链接
      "https://linux.class2.icu/shell/nasyt.sh"  # 备用链接1
      "https://nasyt.hoha.top/shell/nasyt.sh" # 备用链接2
      "https://nasyt2.class2.icu/shell/nasyt.sh"  # 备用链接3
      
    )
    
}



# 函数
server_ip() {
    server_ip=$(hostname -i) # 服务器IP
    $habit --msgbox "当前IP为: $server_ip" 0 0
}

info() {
    echo -e "$cyan[$(date +"%r")]$color $green[INFO]$color" $*
}
uptime_cn() {
    uptime_sc=$(uptime | sed 's/up/运行/; s/days/天/; s/day/天/; s/hours/小时/; s/hour/小时/; s/minutes/分钟/; s/minute/分钟/; s/users/用户/; s/user/用户/; s/load average/平均负载/')
    $habit --msgbox "系统: $uptime_sc" 0 0
}

br() {
    echo -e "\e[1;34m--------------------------\e[0m"
}

esc() {
    echo -e "$(info) 按$green回车键$color$blue返回$color,按$yellow Ctrl+C$color$red退出$color"
    read
}

#错误处理
cw() {
    if [ $cw_test -ne 0 ]; then
       break
    fi
}

#监控服务器资源
resources_show() {
    if command -v termux-info >/dev/null 2>&1; then
        resources_show_notermux="termux不支持查看CPU占用"
    fi
    echo -e "$(info) 正在读取随机中"
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*,*([-9.)* id.*/\1/" | awk '{print 100}' >/dev/null 2>&1)
    mem_usage=$(free | awk '/Mem/ {print $3/$2*100.0}') >/dev/null 2>&1
    ps_quantity=$(ps -e --no-headers | wc -l) >/dev/null 2>&1
    echo -e "$(info) $green 读取数据完毕$color"
    $habit --msgbox "操作系统: $PRETTY_NAME \n$resources_show_notermux \nCPU使用率：$cpu_usage% \n内存使用率：$mem_usage% \n进程数量: $ps_quantity" 0 0
}

# 根据时间返回问候语
get_greeting() {
    local hour=$(date +"%H")
    case $hour in
        05|06|07|08|09|10|11)
            echo "🌅 早上好！欢迎使用Linux工具箱"
            ;;
        12|13|14|15|16|17|18)
            echo "☀️ 下午好！欢迎使用Linux工具箱"
            ;;
        *)
            echo "🌙 晚上好！欢迎使用Linux工具箱"
            ;;
    esac
}

test_termux() {
    if command -v termux-info >/dev/null 2>&1; then
        $habit --msgbox "不支持termux终端" 0 0
        break
    fi
}

# 检查dialog whiptail figlet安装
test_install_jc() {
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 安装失败。$color"
    else
        echo -e "$(info) $green 安装成功。$color"
    fi
}

test_dialog() {
        if command -v dialog &> /dev/null
        then
            echo -e "$green ◉ dialog 已经安装，跳过安装步骤。 $color"
        else 
            echo "$(info) 正在安装dialog"
            $pkg_install dialog $yes_tg
            if [ $? -ne 0 ]; then
                echo -e "$(info) 安装完成"
            fi
            echo -e "$red 安装失败。 $color"
        fi
}

test_figlet() {
    if command -v figlet >/dev/null 2>&1; then
        echo -e "$green ◉ figlet 已经安装，跳过安装步骤。$color"
    else 
        echo "$(info) 正在安装figlet"
        $pkg_install figlet $yes_tg
        if [ $? -ne 0 ]; then
            echo -e "$(info) 安装完成"
        fi
            echo -e "$red 安装失败。 $color"
    fi
}
test_toilet() {
    if command -v toilet >/dev/null 2>&1; then
        echo -e "$green ◉ toilet已安装，跳过安装步骤 $color"
    else
        echo "$(info) toilet未安装，正在安装"
        $pkg_install toilet $yes_tg
    fi
}

test_whiptail() {
    if command -v whiptail &> /dev/null
    then
        echo -e "$(info) ◉ whiptail已安装, 跳过安装步骤。"
    else
        echo -e "$(info) whiptail未安装，正在安装。"
        if command -v pacman >/dev/null 2>&1; then
            echo -e "$(info) 检测到Arch系统，正在安装libnewt软件包"
            $pkg_install libnewt $yes_tg
        else
            $pkg_install whiptail $yes_tg
                if [ $? -ne 0 ]; then
                    echo "$(info) 安装完成"
                fi
                echo -e "$red 安装失败。 $color"
        fi
    fi
}
    
test_curl() {
    if command -v curl >/dev/null 2>&1; then
        echo -e "$green ◉ curl已安装,跳过安装$color"
    else
        echo "$(info) 正在安装curl"
        $pkg_install curl $yes_tg >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "$red curl安装失败 $color"
        else
            echo "$(info) curl安装成功"
        fi
    fi
}

test_wget() {
    if command -v wget >/dev/null 2>&1; then
        echo -e "$green ◉ wget已安装，跳过安装 $color"
    else
        echo "$(info) 正在安装wget"
        $pkg_install wget $yes_tg
    fi
}

test_eatmydata() {
    if command -v eatmydata >/dev/null 2>&1; then
        echo -e "$green ◉ eatmydata已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装eatmydata"
        $pkg_install eatmydata $yes_tg
    fi
}

test_python() {
    if command -v python >/dev/null 2>&1; then
       echo -e "$green ◉ python已安装,跳过安装$color"
    else
       echo -e "$(info) 正在安装python"
       $pkg_install python $yes_tg
    fi
}

test_pip() {
    if command -v pip >/dev/null 2>&1; then
       echo -e "$green ◉ pip已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装pip"
        $pkg_install pip $yes_tg
    fi
}

test_git() {
    if command -v git >/dev/null 2>&1; then
        echo -e "$green ◉ git已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装git"
        $pkg_install git $yes_tg
    fi
}

test_tmux() {
    if command -v tmux >/dev/null 2>&1; then
        echo -e "$green ◉ tmux已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装tmux工具"
        $pkg_install tmux $yes_tg
    fi
}

test_neofetch() {
    if command -v neofetch >/dev/null 2>&1; then
        echo -e "$green ◉ neofetch已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装neofetch工具"
        $pkg_install neofetch $yes_tg
    fi
}

test_fastfetch() {
    if command -v fastfetch >/dev/null 2>&1; then
        echo -e "$green ◉ fastfetch已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装 fastfetch"
        $pkg_install fastfetch $yes_tg
    fi
}

test_hashcat() {
    if command -v hashcat >/dev/null 2>&1; then
        echo -e "$green ◉ hashcat已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装hashcat工具"
        $pkg_install hashcat $yes_tg
    fi
}

test_burpsuite() {
    if command -v burpsuite >/dev/null 2>&1; then
        echo -e "$green ◉ burpsuite已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装burpsuite工具"
        $pkg_install burpsuite $yes_tg
    fi
}

test_nmap() {
    if command -v nmap >/dev/null 2>&1; then
        echo -e "$green ◉ nmap已安装，跳过安装。$color"
    else
        echo -e "$(info) 正在安装nmap"
        $pkg_install nmap $yes_tg
    fi
}

test_htop() {
    if command -v htop >/dev/null 2>&1; then
        echo -e "$green ◉ htop已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装htop"
        $pkg_install htop $yes_tg
    fi
}

test_ncdu() {
    if command -v ncdu >/dev/null 2>&1; then
        echo -e "$green ◉ ncdu已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装curl"
        $pkg_install ncdu $yes_tg
    fi
}

test_bastet() {
    echo "111"
}
#通用安装
test_install() {
    if command -v $* >/dev/null 2>&1; then
        echo -e "$green ◉ $*已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装$*"
        $pkg_install $* $yes_tg
        install_error=$?
        if [ $install_error -ne 0 ]; then
            echo -e "$(info) $red $*安装失败。$color"
            echo -e "$(info) 正在处理软件包"
        else
            echo -e "$(info) $green $*安装成功。$color"
        fi
    fi
}

pip_mcstatus() {
    if pip show "mcstatus" > /dev/null 2>&1; then
       echo -e "$green ◉ mcstatus已安装,跳过安装$color"
    else
       echo -e "$(info) 正在使用pip安装mcstatus"
       pip install mcstatus -y
    fi
}

pip_colorama() {
    if pip show "colorama" > /dev/null 2>&1; then
       echo -e "$green ◉ colorama已安装,跳过安装$color"
    else
       echo -e "$(info) 正在使用pip安装mcstatus"
       pip install colorama
    fi
}

ad_gg () {
    echo -e "$pink金牌cpu云服务器9.9元起 ^o^$color"
    echo "国内高配服务器99元   云电脑4元起"
    echo "虚拟主机免费送 >_<"
    echo -e "地址 - $pink coyjs.cn $color  百度 - $pink创欧云$color"
}

#错误函数处理
error() {
    echo -e "\e[31m错误: $1\e[0m"
    echo -e "$(info) 错误代码为: $?"
    exit 1
}

#工作环境
termux_PATH () {
    if command -v termux-info >/dev/null 2>&1; then
        if ! grep -q "^export PATH=$HOME/.nasyt:" $HOME/.bashrc; then
            echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
        else
            echo -e "$(info) PATH 已存在于 $nasyt_dir，跳过添加"
        fi
        chmod 777 $nasyt_dir/nasyt #给予权限
    else
        if ! grep -q "^export PATH="$nasyt_dir:"" $HOME/.bashrc; then
            echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
        else
            echo -e "$(info) PATH 已存在于 .bashrc  跳过添加"
        fi
    fi
}

PATH_set () {
# PATH 行变量
if ! grep -q "^export PATH=" $nasyt_dir/config.txt; then
    echo "export PATH="$nasyt_dir:$PATH"" >> $nasyt_dir/config.txt
else
    echo -e "$(info) PATH 已存在于 $nasyt_dir，跳过添加"
fi
}

# 检查脚本文件夹。
check_script_folder () {
   if [ -d "$nasyt_dir" ]; then
      echo -e "$(info) 工作文件夹已创建"
   else
      mkdir -p "$nasyt_dir"
   fi
}

# 检查本脚本是否已安装
check_Script_Install() {
    if command -v nasyt >/dev/null 2>&1; then
        echo "◉ 可直接输入nasyt进入本界面"
    else 
        if [ -e "$nasyt_dir/nasyt" ]; then
            echo "◉ 变量环境已安装,可直接输入nasyt进入本界面"
        else
            echo "$(info) 脚本未安装"
        fi
    fi
}

# 菜单使用习惯选择
habit_menu () {
    clear
    echo "功能都支持使用箭头进行选择"
    br
    echo "1) dialog屏幕点击(适合鼠标)"
    echo "2) whiptail屏幕滑动（适合触屏)"
    echo "3) 重置选择"
    br
    read -p "请选择菜单使用习惯: " habit_menu_xz
}

#习惯选择
habit_xz () {
    if [ -z "$habit" ]; then
        habit_menu
        case $habit_menu_xz in
           1)
               test_dialog
               echo "export habit="dialog"" >  $nasyt_dir/config.txt
               ;;
           2) 
               test_whiptail
               echo "export habit="whiptail"" > $nasyt_dir/config.txt
               ;;
           3) sed -i '/^export=*/d' $nasyt_dir/config.txt ;;
           0) cw;break ;;
        esac
    elif [ -n "$habit" ]; then
        echo -e "菜单方式为: $yellow$habit$color"
    fi
    if command -v $habit >/dev/null 2>&1; then
        echo -e "$green $habit 已安装，跳过安装步骤$color"
    else
        echo "$habit 未安装，正在安装。"
        $pkg_install $habit $yes_tg
        if [ $? -ne 0 ]; then
            echo -e "$red 安装失败 $color"
        fi
    fi
    
}

# 主菜单
show_menu() {
    choice=$($habit --title "NAS油条Linux工具箱" \
    --menu "当前版本:$version $time_date\n本工具箱由NAS油条制作\nQQ群:610699712\n请使用方向键+回车键进行操作\n请选择你要启动的项目：" \
    0 0 10 \
    1 "本机信息" \
    2 "系统工具" \
    3 "网络工具" \
    4 "基础工具" \
    5 "软件安装" \
    6 "其它脚本" \
    7 "更新脚本" \
    8 "更新历史" \
    9 "脚本设置" \
    0 "退出脚本" \
    2>&1 1>/dev/tty) 
    cw_test=$?;cw
    
    
}

# 查看菜单
look_menu() {
    
    look_choice=$($habit --title "查询菜单" \
    --menu "请选择" 0 0 10 \
    1 "当前时间" \
    2 "配置信息" \
    3 "当前 IP" \
    4 "本机logo" \
    5 "地理位置" \
    6 "进程列表" \
    7 "运行时间" \
    8 "监控资源" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 系统操作
system_menu() {
    system_choice=$($habit --title "系统菜单" \
    --menu "请选择" 0 0 10 \
    1 "软件包管理" \
    2 "更换镜像源(大多数系统)" \
    3 "更新软件包" \
    4 "文件解压缩" \
    5 "ssh管理工具" \
    6 "安装jvav（debian系列)" \
    7 "系统语言设置" \
    8 "磁盘挂载设置" \
    9 "虚拟内存设置" \
    10 "清理系统日志"  \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 安装常用工具。
often_tool() {
   often_tool_linux() {
    often_tool_choice=$($habit --title "安装linux常用工具" \
    --menu "请选择" 0 0 10 \
    2 "🖥各种面板" \
    3 "🤖bot机器人" \
    4 "👾娱乐游戏" \
    5 "🚀各种服务端" \
    6 "🌍穿透工具" \
    7 "其他工具" \
    0 "◀返回上层菜单" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
    }
    
   often_tool_termux() {
    often_tool_choice=$($habit --title "安装termux常用工具" \
    --menu "请选择" 0 0 10 \
    3 "🤖bot机器人相关" \
    4 "👾娱乐相关" \
    6 "🌍穿透工具" \
    7 "其他工具" \
    0 "◀返回上层菜单" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
    }
    
    #检查当前系统
    often_tool_main() {
    if command -v termux-info >/dev/null 2>&1; then
        if [[ $shell_skip == 1 ]]; then
            echo -e "$(info) 已跳过"
            often_tool_linux
        else
            often_tool_termux
        fi
    else
       often_tool_linux
    fi
    }
    often_tool_main
}

# 软件安装
app_install() {
   app_install_linux() {
    app_install_xz=$($habit --title "安装软件" \
    --menu "请选择" 0 0 10 \
    1 "安装桌面中文输入法" \
    2 "安装Blender建模软件" \
    3 "安装linux系统应用商店" \
    4 "安装bleachbit清理工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw
    }
   app_install_termux() {
      $habit --msgbox "此区域只支持linux系统\n抱歉,不支持Termux终端>_<" 0 0
      break
   }
   app_install_main() {
   if command -v termux-info >/dev/null 2>&1; then
      app_install_termux
   else
      app_install_linux
   fi
   }
   app_install_main
}

# 网络常用工具
Internet_tool() {
    Internet_tool_xz=$($habit --title "网络常用工具" \
    --menu "请选择" 0 0 10 \
    1 "Ping工具" \
    2 "CC攻击" \
    3 "Tmux终端工具" \
    4 "TMOE实用工具" \
    5 "nmap端口扫描工具" \
    6 "ranger文件管理工具" \
    7 "hashcat暴力破解工具" \
    8 "burpsuite渗透工具" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 各种脚本。
Linux_shell() {
    linux_shell_linux() {
    Linux_shell_xz=$($habit --title "各种脚本" \
    --menu "请选择" 0 0 10 \
    1 "亚洲云LinuxTool脚本工具" \
    2 "木空云LinuxTool脚本工具" \
    3 "MC 压力测试 脚本工具" \
    4 "Docker 安装与换源脚本" \
    5 "赤石脚本 (⁎⚈᷀᷁ᴗ⚈᷀᷁⁎)" \
    7 "TMOE脚本工具" \
    8 "git管理脚本" \
    9 "kejilion脚本工具" \
    10 "v2ray一键安装脚本" \
    91 "欢迎联系作者添加" \
    0 "返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
    
    }
    linux_shell_termux() {
    Linux_shell_xz=$($habit --title "各种termux脚本" \
    --menu "请选择" 0 0 10 \
    3 " MC 压力测试 脚本工具" \
    5 "赤石脚本good" \
    6 "Termux版kali一键安装脚本" \
    7 "TMOE脚本工具" \
    8 "git管理脚本" \
    9 "kejilion脚本工具" \
    91 "欢迎联系作者添加" \
    0 "返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
    
    }
    linux_shell_main() {    
    if command -v termux-info >/dev/null 2>&1; then
        if [[ $shell_skip == 1 ]]; then
            echo -e "$(info) 已跳过"
            linux_shell_linux
        else
            linux_shell_termux
        fi
    else
       linux_shell_linux
    fi
   }
   linux_shell_main
}

panel_menu() {
    panel_menu_xz=$($habit --title "各种服务器面板" \
    --menu "请选择" 0 0 10 \
    1 "安装宝塔(bt.cn)面板" \
    2 "安装AMH面板" \
    3 "安装1panel面板" \
    4 "安装MCSManager面板" \
    5 "安装小皮面板" \
    6 "安装GMSSH面板" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw
}

bot_install_menu() {
    bot_install_xz=$($habit --title "bot安装" \
    --menu "请选择:" 0 0 10 \
    1 "安装Secluded机器人" \
    2 "安装TRSS机器人" \
    3 "安装Astrbot机器人" \
    4 "安装Napcat适配器" \
    5 "安装OneBot适配器" \
    6 "安装Easybot机器人" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 脚本设置
nasyt_setup_menu () {
   nasyt_setup_choice=$($habit --title "脚本设置" \
   --menu "脚本设置" 0 0 10 \
   1 ">_<个性化" \
   2 "remove卸载脚本" \
   3 "github加速(暂未开发)" \
   4 "脚本空间占用" \
   5 "脚本备份/恢复" \
   8 "补全完整功能" \
   9 "删除脚本配置文件" \
   0 "◀返回" \
   2>&1 1>/dev/tty)
   cw_test=$?;cw
}

# 调试模式
ts_menu() {
    br
    echo "1) 命令输出"
    echo "2) 函数输出"
    echo "3) 变量输出"
    echo "4) 补全文件"
    echo "0) ◀返回"
    br
}
server_install_menu() {
    server_install_xz=$($habit --title "各种服务端" \
    --menu "请选择" 0 0 10 \
    1 "安装SFS服务端" \
    2 "安装phira服务端" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

game_menu() {
    game_menu_xz=$($habit --title "娱乐菜单" \
    --menu "请选择" 0 0 10 \
    1 "⬜俄罗斯方块" \
    2 "🐍贪吃蛇" \
    3 "🌌太空入侵" \
    4 "黑客帝国屏保" \
    5 "🪴盆栽艺术" \
    6 "可视化音频" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 文件解压缩
zip_menu() {
    br
    echo "1) zip文件"
    echo "2) tar.gz文件"
    echo "0) ◀返回"
    br
}

# ssh工具
ssh_tool_menu() {
    br
    echo "1) 连接SSH"
    echo "2) 启动SSH"
    echo "3) 修改密码"
    echo "0) ◀返回"
    br
}

#java安装
java_install_menu () {
    java_install_xz=$($habit --title "jvav安装" \
    --menu "Debian系列用,请选择🤓jvav版本" 0 0 5 \
    22 "java22" \
    21 "java21" \
    20 "java20" \
    19 "java19" \
    17 "java17" \
    11 "java11" \
    8 "java8" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

termux_kali_install() {
  termux_kali_install_xz=$($habit --title "安装源选择" \
  --menu "采用proot运行rootfs并且构建\n请选择kali的安装方式\n官方源:kali官方rootfs镜像（完整|最新|可能速度慢）\n国内源:来自国内大佬整合出来的kali优化版(速度快|已停更) \n官方修改:作者自己维护的脚本（同步官方|汉化|安全|自定义)\n" 0 0 5 \
  1 "官方源(kali.download)" \
  2 "国内源(gitee.com/zhang-955/clone)" \
  3 "官方修改 (推荐|方便)" \
  4 "如果有更多安装方式可以提交给我们。" \
  0 "◀返回" \
  2>&1 1>/dev/tty)
  if [ $? -ne 0 ]; then
    break
  fi
}
# 废弃
csh() {
    clear
    echo -e "$(info) 正在使用 $deb_sys 更新中"
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syyu
    else
        $deb_sys upgrade $yes_tg
        echo 正在使用 $deb_sys 安装curl git dialog figlet中
        $pkg_install curl git dialog figlet $yes_tg
        $habit --msgbox "安装完成" 0 0
        esc
    fi
}

# ping命令
ping2() {
    ping_sr=$($habit --title "请输入地址" \
    --inputbox "ip" 0 0 \
    2>&1 1>/dev/tty)
    ping $ping_sr
}

# CC攻击命令
cc() {
    echo -e "$(info) 无"
}

# tmux命令
tmux_tool() {
    tmuxtool=$($habit --title "tmux工具" \
    --menu "请选择" 0 0 10 \
    1 "新建tmux窗口" \
    2 "全部tmux窗口" \
    3 "重命名tmux窗口" \
    4 "进入tmux窗口" \
    5 "杀死tmux窗口" \
    6 "查看tmux快捷键" \
    7 "全部tmux命令" \
    0 "退出" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# tmux快捷键
tmux_keys() {
    echo -e "$(info) Ctrl+b c：创建一个新窗口，状态栏会显示多个窗口的信息。"
    echo -e "$(info) Ctrl+b p：切换到上一个窗口（按照状态栏上的顺序）。"
    echo -e "$(info) Ctrl+b n：切换到下一个窗口。"
    echo -e "$(info) Ctrl+b <number>：切换到指定编号的窗口，其中的<number>是状态栏上的窗口编号。"
    echo -e "$(info) Ctrl+b w：从列表中选择窗口。"
    echo -e "$(info) Ctrl+b ,：窗口重命名。"
}

# cpolar内网穿透一键安装。
cpolar_instell() {
    while true
    do
    cpolar_install_xz=$($habit --title "cpolar.com" \
    --menu "选择你的框架" 0 0 10\
    1 "x86_64通用安装" \
    2 "Termux安装" \
    3 "卸载cpolar" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw
    case $cpolar_install_xz in
        1) curl --progress-bar -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash ;;
        2) test_install dnsutils;bash https://gitee.com/nasyt/nasyt-linux-tool/raw/master/cpolar/aarch64.sh ;;
        3) curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash -s -- --remove ;;
        0) break;;
        *) echo -e "$(info) 无效的输入"; esc;;
    esac
    esc
    sleep 1s
    done
}

# 安装1panel面板
1panel_menu() {
    br
    echo "1) RedHat / CentOS系统"
    echo "2) Ubuntu系统"
    echo "3) Debian系统"
    echo "4) OpenEuler / 其他"
    echo "0) ◀返回"
    br
}

# Secluded菜单
Secluded_menu() {
    Secluded_menu_xz=$($habit --title "Secluded菜单" \
    --menu "欢迎使用Secluded机器人\n本脚本由NAS油条制作" 0 0 5 \
    1 "安装" \
    2 "启动" \
    3 "卸载" \
    4 "问题" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    cw_test=$?;cw
}

# 安装TRSS机器人
TRSS() {
    br
    echo "1) 安装TRSS机器人docker版(Linux推荐)"
    echo "2) 安装tmoe_proot/chroot容器(Termux推荐)"
    echo "d) docker打开TRSS机器人(前提1)"
    echo "0) ◀返回"
    br
}

# 安装Astrbot机器人
astrbot() {
    echo "官网: https://astrbot.app"
    echo "提示: 宝塔上面的docker应用上有现成的"
    echo "注意: Astrbot以Python为主体"
    br
    echo "1) CentOS系统安装"
    echo "2) Debian/Ubuntu安装"
    echo "3) python手动安装(兼容)"
    echo "4) 启动Astrbot(前提3)"
    echo "0) ◀返回"
    br
}

# CC攻击
cc() {
    echo "------CC攻击------"
    cc_url=$($habit --title "CC攻击" \
    --inputbox "请输入攻击地址" 0 0 \
    2>&1 1>/dev/tty)
    cc_sl=$($habit --title "CC攻击" \
    --inputbox "请输入攻击数量" 0 0 \
    2>&1 1>/dev/tty)
    echo 正在攻击ing...
    for ((i=0; i<$cc_sl; i++)); do
        echo -e "$(info) 正在攻击$i"
        curl -s $cc_url > /dev/null     
    done
    echo -e "$(info) CC攻击完成"
}


nmap_menu() {
    tsab_nmap
    echo "提示: 暂时只有一个功能"; br
    echo "1) 扫描IP开发端口"
    echo "0) ◀返回"
    br
}

# deb软件包安装
deb_install() {
    deb_install_xz=$($habit --title "软件包管理" \
    --menu "软件包管理" 0 0 10 \
    1 "安装网络软件包" \
    2 "安装本地软件包" \
    3 "卸载本地软件包" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#软件包安装
deb_install_Internet() {
    br
    read -p "请输入软件包名字: " deb_install_pkg
    br
    if command -v $deb_install_pkg &> /dev/null
    then
        echo -e "$(info) 软件包 $deb_install_pkg 已安装。"
    else 
        echo -e "$(info) 正在使用 $pkg_install 安装 $deb_install_pkg 中"
        $pkg_install $deb_install_pkg $yes_tg
    fi
    br
}

#本地软件包安装
deb_install_localhost() {
    echo -e "$(info) 提示: 暂时只能安装deb软件包"
    br
    read -p "请输入软件包地址: " deb_localhost_xz
    br
    dpkg -i $deb_localhost_xz
    esc
}

#软件包卸载
deb_remove() {
    echo -e "$(info) 卸载但是保留配置文件。"
    br
    deb_remove_xz=$($habit --title "请输入软件包" \
    --inputbox "请输入软件包" 0 0 \
    2>&1 1>/dev/tty)
    clear
    br
    $pkg_install remove $deb_remove_xz $yes_tg
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 安装失败$color"
    else
        echo -e "$(info) $green 安装成功$color"
    fi
    esc
}

# ranger文件管理工具
ranger_install() {
    if command -v ranger &> /dev/null
    then
        read -p "ranger 已安装。按回车键进入。"
        ranger
    else 
        echo -e "$(info) 未安装ranger正在安装。"
        $pkg_install ranger $yes_tg
        echo -e "$(info) ranger安装完成。"
        read-p "按回车键启动。"
        ranger
    fi
}

#脚本卸载
shell_uninstall() {
    $habit --yesno "此操作会删除本脚本\n以及本脚本目录下的工具\n你确定要删除(>_<)本脚本吗？" 0 0
    rm $PREFIX/bin/nasyt >/dev/null 2>&1
    rm -rf /usr/bin/nasyt >/dev/null 2>&1
    rm -rf $nasyt_dir
    $habit --msgbox "删除完成\n再见，感谢你的支持。" 0 0
}

#更新查看
gx_show() {
    if [ $new_version == $version ]; then
        echo -e "$green 当前版本已是最新。 $color"
    else
        echo -e "$red 有新版本更新$new_version $color"
    fi
}

#更新链接来源
version_update() {
    new_version=$(curl "https://gitee.com/nasyt/nasyt-linux-tool/raw/master/version.txt") 
}

#更新以及安装
gx() {
    # 下载安装更新
    br
    shell_backup
    echo "$(info) 正在获取脚本"
    for url in "${urls[@]}"; do
        echo "$(info) 正在下载脚本"
        if curl --progress-bar -L -o "$HOME/nasyt" --retry 3 --retry-delay 2 --max-time $time_out "$url" >/dev/null 2>&1 ; then
            echo -e "$(info)$green 脚本下载成功! $color"
            cp nasyt /usr/bin/ >/dev/null 2>&1
            cp nasyt $PREFIX/bin >/dev/null 2>&1
            mv nasyt $nasyt_dir/nasyt >/dev/null 2>&1
            echo -e "$(info) 正在给予脚本权限 $color"
            chmod 777 $nasyt_dir/nasyt
            chmod 777 /usr/bin/* >/dev/null 2>&1
            chmod 777 $PREFIX/bin/* >/dev/null 2>&1
            echo -e "$(info) 正在写入启动文件 $color"
            source $HOME/.bashrc >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "$red [✗] 写入失败 $color"
            fi
            if command -v nasyt >/dev/null 2>&1; then
                echo -e "$(info)$green 脚本更新成功 $color"
                #rm $nasyt_dir/nasyt.bak >/dev/null 2>&1
                #rm /usr/bin/nasyt.bak >/dev/null 2>&1
                #rm $PREFIX/bin/nasyt.bak >/dev/null 2>&1
            else
                echo -e "$(info)$green 脚本安装失败，正在还原备份文件 $color"
                shell_
            fi
            echo -e "$(info) 正在安装必要文件"
            test_install figlet >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "$(info) $red figlet软件包安装失败，请手动安装figlet软件包$color"
                
            fi
            echo "$(info) 如果不行请重新连接终端"
            echo -e "$(info) 启动命令为$yellow nasyt$color"
            source $HOME/.bashrc >/dev/null 2>&1
            exit 0
        else
            echo "$(info)✗ 当前链接下载失败，3秒后尝试下一个链接..."
            sleep 3
        fi
    done
    echo -e "$(info) $red 所有链接均下载失败，请检查网络或链接有效性$color"
    echo "跳过下载本地,使用在线模式。" 0 0
}

shell_backup_menu() {
    shell_backup_xz=$($habit --title "备份/恢复" \
    --menu "请选择" 0 0 5 \
    1 "脚本备份" \
    2 "脚本恢复" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#脚本备份
shell_backup() {
    echo "$(info) 正在备份脚本文件";sleep 0.5s
    cp $nasyt_dir/nasyt $nasyt_dir/nasyt.bak >/dev/null 2>&1
    if command -v termux-info >/dev/null 2>&1; then
        cp $PREFIX/bin/nasyt $PREFIX/bin/nasyt.bak >/dev/null 2>&1
    else
        cp /usr/bin/nasyt /usr/bin/nasyt.bak>/dev/null 2>&1 >/dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 脚本备份失败，跳过备份环节$color"
    else
        echo -e "$(info) $green 脚本备份成功$color"
    fi
}

#脚本恢复功能
shell_recover() {
    cp $nasyt_dir/nasyt.bak $nasyt_dir/nasyt >/dev/null 2>&1
    chmod 777 $nasyt_dir/*
    if command -v termux-info >/dev/null 2>&1; then
        cp $PREFIX/bin/nasyt.bak $PREFIX/bin/nasyt
        chmod 777 $PREFIX/bin/*
    else
        cp /usr/bin/nasyt.bak /usr/bin/nasyt
        chmod 777 /usr/bin/* >/dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 脚本恢复失败$color"
    else
        echo -e "$(info) $green 脚本恢复成功$color"
    fi
}

# DDOS攻击安装
ddos() {
    cd ddos; python ddos.py
    dialog --msgbox "按回车开始安装。" 0 0; clear
    test_figlet; clear
    echo "$(info) 正在安装 python"; echo 途中可能会停止请输入y继续
    echo "等的时间可能有点长,请耐心等待。"; test_python; clear
    echo "正在安装下载 ddos"; curl --progress-bar -o ddos.zip https://cccimg.com/down.php/576c81c114e3a3c1b3e702bd19117594.zip; unzip ddos.zip; clear
    echo "清理安装包中"; rm ddos.zip
    echo "以后请输入以下命令启动"; echo "python ddos/ddos.py"; read -p "回车键继续"
    cd ddos; python ddos.py
    
}

upsource() {
    read -p "$(info) 确定更换下载源(y/n)" upsource_sz
    if [ $upsource_sz == n ]; then
        exit
    fi
    if command -v termux-change-repo >/dev/null 2>&1; then
        termux-change-repo
    else
        if [ -d $nasyt_dir/mirrors.sh ];then
            echo -e "$(info) 正在下载脚本文件。"
            curl -sSLo $nasyt_dir/mirrors.sh https://linuxmirrors.cn/main.sh >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "$(info) $red 下载文件失败。$color"
            else
                echo -e "$(info) $green 下载文件成功。$color"
            fi
        else
            chmod 777 $nasyt_dir/*
            bash $nasyt_dir/mirrors.sh
        fi
    fi
    esc
}

#tmux工具
tmux_tool_index() {
  while true
  do
  tmux_ls=$(tmux ls) >/dev/null 2>&1 # tmux转中文
  tmux_ls_cn=$(echo "$tmux_ls" | sed -E 's/windows//g; s/created/创建于/g; s/^( *)创建于 /\1创建于\\/; s/^/窗口名字: /')
  clear
  test_tmux
  tmux_tool
  case $tmuxtool in
    1) 
        clear
        new_tmux=$($habit --title "窗口名字" \
        --inputbox "请输入窗口名字" 0 0 \
        2>&1 1>/dev/tty)
            echo "创建 $new_tmux 窗口成功。"
            echo "Ctrl+B D离开窗口"
            read -p "回车键进入。"
            tmux new -t "$new_tmux"
        esc ;;
    2) 
        clear; br
        echo "$tmux_ls_cn"; br
        esc
        ;;
    3)
        clear; br
            echo "$tmux_ls_cn"; br
        read -p "请输入要重命名的窗口: " rename_tmux_1
        read -p "重命名为: " rename_tmux_2
            tmux rename-session -t $rename_tmux_1 $rename_tmux_2
            echo "将 $rename_tmux_1 重命名 $rename_tmux_2 成功"
        esc
        ;;
    4)
        clear; br
            echo "$tmux_ls_cn"; br
        read -p "请输入要进入的窗口号: " join_tmux
            tmux attach-session -t $join_tmux
        esc
        ;;
    5)
        clear; br
            echo "$tmux_ls_cn"; br
        read -p "请输入要杀死的窗口: " kill_tmux
            tmux kill-session -t $kill_tmux
        echo "杀死 $kill_tmux 窗口成功"
        esc
        ;;
    7)
        tmux list-commands; br
        esc
        ;;
    6)
        clear
        tmux_keys
        esc
        ;;
    0)
        break
        read
        ;;
    *)
        $habit --msgbox "无效的输入。" 0 0
        esc
        ;;
  esac
done
}

# 显示服务器配置信息
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
    fi
    echo "内存信息:"
    free -h
    echo "硬盘信息:"
    df -h
    esc
}

# neofetch工具
ifneofetch() {
  #检查neofetch/fastfetch
    test_neofetch
    test_fastfetch
  #显示内容
    clear;br
    echo "neofetch"
    neofetch
    br;echo "fastfetch"
    fastfetch
    br;read -p "回车键返回。"
}

# 一键修改密码
change_password() {
    username=$(whoami)
    sudo passwd "$username"
    echo "$(info) 密码已成功修改。"
}


# 同步上海时间函数
sync_shanghai_time() {
    install_ntpdate
    echo "$(info) 正在同步上海时间..."
    sudo timedatectl set-timezone Asia/Shanghai
    sudo ntpdate cn.pool.ntp.org
    echo "时间同步完成。"
}

# 获取操作系统信息的函数
get_os_info() {
    br
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo -e "操作系统: $green $PRETTY_NAME $color"
        echo "ID: $ID"
        echo "版本: $VERSION_ID"
        echo "软件包管理方式: $deb_sys"
    elif command -v termux-info >/dev/null 2>&1; then
        set PRETTY_NAME="Termux终端"
        echo -e "操作系统: $green Android (Termux) $color"
        echo "当前系统: $sys"
        if command -v neofetch >/dev/null 2>&1; then
            neofetch -l
        fi
    else
        echo "-_-无法获取操作系统信息。"
    fi
    br

}


# 检查
introduce() {
    #export LANG=zh_CN.UTF-8 # 设置编码为中文。
    termux_PATH #termux环境变量设置
    PATH_set #环境变量设置
    source $nasyt_dir/config.txt >/dev/null # 加载脚本配置
    #check_pkg_install # 检查包管理器。
    check_script_folder # 检查脚本文件夹。
    #test_figlet # 检查figletl是否安装。
    check_Script_Install # 检查本脚本是否安装。
}

# 开始
index_main() {
    introduce # 检查
    if [[ $shell_skip == 1 ]]; then
        echo "已跳过"
    else
        menu_jc # 菜单发布页
        get_os_info # 获取操作系统
        ad_gg #广告
        habit_xz #选择使用习惯。
        br
        read -p "回车键启动脚本,Ctrl+C退出" 
    fi
    source $nasyt_dir/config.txt >/dev/null # 加载脚本配置
    source $HOME/.bashrc >/dev/null # 加载用户启动文件
    clear
    while true
    do
        clear
        show_menu  # 主菜单
        case $choice in
            csh)
                csh ;;
                # 工具箱初始化
            1)
                # 查看功能
                while true
                do
                    clear
                    look_menu
                    case $look_choice in
                        1) $habit --msgbox "$(date +"%r")" 0 0;;
                        2) show_server_config;;
                        3) dialog --msgbox "$(curl iplark.com)" 0 0 ;;
                        4) ifneofetch ;;
                        5) $habit --msgbox "$(curl -sSL https://slow-api.class2.icu/ip.php)" 0 0;;
                        6) test_htop;htop ;;
                        7) uptime_cn;;
                        8) resources_show;esc;;
                        0) break ;;
                        *) break ;;
                    esac
                done
                ;;
            2)
                while true
                do
                    clear
                    system_menu
                    case $system_choice in
                        1)
                            while true
                            do
                                clear
                                deb_install
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
                                        cw_test=$?;cw
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        2)
                            upsource
                            ;;
                        3)
                            $habit --title "确认操作" --yesno "确定更新软件包及系统吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            fi
                            br
                            echo -e "$(info) $green 正在获取更新 $color"
                            $pkg_install update $yes_tg >/dev/null 2>&1
                            echo -e "$(info) 正在开始更新软件包"
                            $pkg_install upgrade $yes_tg
                            if [ $? -ne 0 ]; then
                                echo -e "$(info) $red 软件包更新失败$color"
                            else
                                echo -e "$(info) $green 软件包更新成功$color"
                            esc
                            fi
                            ;;
                        4)
                            while true
                            do
                                clear
                                zip_menu
                                read -p "请选择: " zip_menu_xz
                                case $zip_menu_xz in
                                    1)
                                        clear
                                        ls_input_2=$(ls)
                                        ls_print=$ls_input2
                                        echo "可能没啥用";br
                                        ls;
                                        zip_zip=$(dialog --title "zip解压" \
                                        --inputbox "$ls_print请输入文件地址" 10 50 \
                                        2>&1 1>/dev/tty)
                                        echo $zip_zip
                                        unzip $zip_zip; br
                                        echo "$(info) 解压文件成功"; esc
                                        ;;
                                    2)
                                        clear; br; ls; br
                                        echo "请输入文件地址(/**/**.tar.gz)"
                                        read tar_gz_xz; br
                                        tar -xzvf $tar_gz_xz; br
                                        echo "解压文件完成"; esc
                                        ;;
                                    0)
                                        break
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        5)
                            while true
                            do
                                clear
                                ssh_tool_menu
                                read -p "请选择:" ssh_tool_xz
                                case $ssh_tool_xz in
                                    1)
                                        clear; br
                                        read -p "请输入IP: " ssh_tool_ip
                                        read -p "请输入端口: " ssh_tool_port
                                        read -p "请输入用户: " ssh_tool_user; br
                                        echo "正在连接 $ssh_tool_ip 服务器中。"; br
                                        ssh -p $ssh_tool_port $ssh_tool_user@ssh_tool_ip; br
                                        echo "连接已断开"; esc
                                        ;;
                                    2)
                                        echo "正在启动ssh中"
                                        sshd; echo "启动完成。"; esc
                                        ;;
                                    3)
                                        clear; br
                                        ssh_tool_passwd=$($habit --title "设置密码" \
                                        --inputbox "请输入要修改的密码" 0 0 \
                                        2>&1 1>/dev/tty)
                                        sudo passwd $ssh_tool_passwd
                                        if [ $? -ne 0 ]; then
                                            $habit --msgbox "密码修改失败" 0 0
                                            break
                                        fi
                                        $habit --msgbox "修改密码为 $ssh_tool_passwd 成功。" 0 0
                                        esc
                                        ;;
                                    0)
                                        break
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        6)
                           java_install_menu
                           $habit --yesno "你确定要安装java_$java_install_xz 吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            fi
                           $pkg_install openjdk-$java_install_xz-jre-headless $yes_tg;;
                        7)
                            language_menu () {
                            clear; br
                            dialog --msgbox "当前只适配了基于 CentOS/Debian的系统\n其他系统的可以尝试一下。" 0 0
                            case $deb_sys in
                               apt)
                                  echo "正在使用 $deb_sys 下载中文汉化包。"
                                  sudo apt install task-chinese-s task-chinese-t >/dev/null 2>&1
                                  if [ $? -ne 0 ]; then
                                    echo -e "$(info) $red 汉化包下载失败$color"
                                  else
                                    echo -e "$(info) $green 汉化包下载成功$color"
                                  fi;sleep 1s
                                  $habit --msgbox "请在接下来的页面内\n切换到zh_CN.UTF-8选项" 0 0
                                  sudo dpkg-reconfigure locales
                                  ;;
                               dnf)
                                  $habit --msgbox "确定安装" 0 0
                                  sudo dnf install glibc-all-langpacks glibc-langpack-zh -y
                                  sudo dnf install google-noto-sans-cjk-*.noarch -y
                                  sudo dnf groupinstall "Chinese Support"
                                  ;;
                               yum)
                                  $habit --msgbox "确定安装" 0 0
                                  sudo yum install glibc-common glibc-langpack-zh -y
                                  ;;
                               pacman)
                                    sudo pacman -S glibc
                                    sudo pacman -S glibc-locales
                                    sudo locale-gen
                                    sudo sed -i '/^#zh_CN.UTF-8 UTF-8/s/^#//' /etc/locale.gen && sudo locale-gen && sudo tee /etc/locale.conf <<< 'LANG=zh_CN.UTF-8'
                                    echo -e "$(info) 正在设置gnome桌面语言"
                                    gsettings set org.gnome.desktop.interface region 'zh_CN.UTF-8' >/dev/null 2>&1
                                    gsettings set org.gnome.desktop.interface language 'zh_CN:en_US' >/dev/null 2>&1
                                    ;;
                               *)
                                  $habit --msgbox "不支持的系统" 0 0
                                  ;;
                            esac
                                echo -e "$(info) 正在设置语言"
                                sudo localectl set-locale LANG=zh_CN.UTF-8 >/dev/null 2>&1
                                update-locale LANG=zh_CN.UTF-8
                                echo -e "$(info) $green语言设置完成$color"
                            esc
                            $habit --msgbox "脚本执行结束" 0 0
                            $habit --title "确认操作" --yesno "是否现在重启系统" 0 0
                                    if [ $? -ne 0 ]; then
                                        break
                                    else
                                        reboot
                                    fi
                            }
                            language_menu
                            ;;
                            
                        8)
                            if command -v termux-info >/dev/null 2>&1; then
                                $habit --msgbox "不支持termux设置" 0 0
                            else
                                test_wget #检查wget函数
                                $habit --title "确认操作" --yesno "本服务由宝塔面板（bt.cn)提供挂载服务\n默认挂载到/www目录\n数据丢失作者不提供任何赔偿" 0 0
                                if [ $? -ne 0 ]; then
                                    break
                                fi
                                wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh
                                sudo bash auto_disk.sh
                                esc
                                exit
                            fi
                            ;;
                        9)
                            if command -v termux-info >/dev/null 2>&1; then
                                $habit --msgbox "不支持termux设置" 0 0
                            else
                                  clear;br
                                  echo "1) 安装虚拟内存"
                                  echo "2) 卸载虚拟内存"
                                  echo "0) 退出"
                                  br
                                  read -p "请选择: " swap_shell
                                  case $swap_shell in
                                     1)
                                        sudo bash -c "$(curl -L https://gitee.com/nasyt/nasyt-linux-tool/raw/master/swap-install.sh)"
                                        esc
                                        ;;
                                     2) 
                                        sudo bash -c "$(curl -L https://gitee.com/nasyt/nasyt-linux-tool/raw/master/swap-uninstall.sh)"
                                        esc
                                        ;;
                                     0) 
                                        break
                                        ;;
                                     *) 
                                        break
                                        ;;
                                  esac
                            fi
                            ;;
                        10)
                            if command -v termux-info >/dev/null 2>&1; then
                                echo -e "$(info) 检测到termux终端正在清理日志文件"
                                find $PREFIX/var/log/ -type f -mtime +30 -exec rm -f {}
                            else
                                find /var/log/ -type f -mtime +30 -exec rm -f {}
                            fi
                            ;;
                        0)
                            clear
                            break
                            ;;
                        *)
                            break
                            ;;
                    esac
                done
                ;;
            
            3)
                while true
                do
                    Internet_tool
                    case $Internet_tool_xz in
                        1) 
                            ping2
                            esc
                            ;;
                        2)
                            cc
                            esc
                            ;;
                        3)
                            # tmux工具
                            tmux_tool_index
                            esc
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
                            $habit --msgbox "目前只有安装服务" 0 0
                            test_hashcat
                            esc
                            ;;
                        8)
                            $habit --msgbox "目前只有安装服务" 0 0
                            test_burpsuite
                            esc
                            ;;
                        0) 
                            break
                            ;;
                        *)
                            break
                            ;;
                    esac
                done
                ;;
            4)
                while true
                do
                    clear
                    often_tool
                    case $often_tool_choice in
                        1)
                            clear
                            curl -fsSL "https://alist.nn.ci/v3.sh" -o v3.sh
                            bash v3.sh
                            esc
                            ;;
                        2)
                            while true
                            do
                            panel_menu
                            case $panel_menu_xz in
                                1)
                                    if [ -f /usr/bin/curl ];then
                                        curl -sSO https://download.bt.cn/install/install_panel.sh
                                    else
                                        wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh
                                    fi
                                    bash install_panel.sh ed8484bec
                                    read -p "$(info) 安装bt完成 回车键返回。"
                                    ;;
                                2) 
                                    wget http://dl.amh.sh/amh.sh
                                    bash amh.sh acc 48677
                                    esc
                                    ;;
                                3)
                                    while true
                                    do
                                        test_termux
                                        clear
                                        1panel_menu
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
                                                echo "$(info) 安装 docker中"
                                                bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
                                                clear; echo "$(info) 安装 1Panel中"
                                                curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                                                esc
                                                ;;
                                            0)
                                                break
                                                ;;
                                            *)
                                                clear
                                                $habit --msgbox "无效的输入。" 0 0
                                                esc
                                                ;;
                                        esac
                                    done
                                    ;;
                                4)
                                    sudo su -c "wget -qO- https://script.mcsmanager.com/setup_cn.sh | bash"
                                    esc
                                    ;;
                                5)
                                    habit --title "确认操作" --yesno "你确定要安装小皮面板吗？" 0 0
                                    if [ $? -ne 0 ]; then
                                        break
                                    fi
                                    if [ -f /usr/bin/curl ]; then
                                        curl --progress-bar -O https://dl.xp.cn/dl/xp/install.sh
                                    else
                                        wget --progress-bar -O install.sh https://dl.xp.cn/dl/xp/install.sh
                                    fi
                                    bash install.sh
                                    esc
                                    ;;
                                6)
                                    $habit --title "确认操作" --yesno "你确定要安装GMSSH面板吗？" 0 0
                                    if [ $? -ne 0 ]; then
                                        break
                                    fi
                                    test_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                                    DATA_DIR="$HOME/gmssh_data"
                                    mkdir -p "$DATA_DIR/config" "$DATA_DIR/logs"
                                    docker pull docker-rep.gmssh.com/gmssh/gs-main-x86:latest
                                    docker run -d --name gm-service-latest -p 8090:80 --restart always docker-rep.gmssh.com/gmssh/gs-main-x86:latest
                                    docker cp gm-service-latest:/app/config/config.json "$DATA_DIR/config"
                                    docker stop gm-service-latest
                                    docker rm gm-service-latest
                                    docker run -d --name gm-service -p 8090:80 --restart always -v "$DATA_DIR/logs:/gs_logs" -v "$DATA_DIR/config:/app/config" docker-rep.gmssh.com/gmssh/gs-main-x86:latest
                                    esc
                                    ;;
                                0)
                                    break
                                    ;;
                            esac
                            done
                            ;;
                        3)
                            while true
                            do
                                bot_install_menu
                                case $bot_install_xz in
                                    1)
                                        while true
                                        do
                                            test_termux
                                            Secluded_menu
                                            case $Secluded_menu_xz in
                                            1)
                                                test_git #检查git是否安装函数
                                                if [ -e "$nasyt_dir/Secluded/SecludedLauncher.out.sh" ]; then
                                                    $habit --msgbox "Secluded已安装>_<" 0 0
                                                else
                                                    $habit --title "确认操作" --yesno "确定安装Secluded吗？\nSecluded将会安装到以下目录\n$nasyt_dir/Secluded" 0 0
                                                    if [ $? -ne 0 ]; then
                                                        $habit --msgbox "取消操作" 0 0
                                                        break
                                                    fi
                                                    cd $HOME #切换到根目录。
                                                    $habit --title "确认操作" --yesno "你的服务器位于 <国外>还是<国内>？\n国内请选择yes 国外请选择no" 0 0
                                                    if [ $? -ne 0 ]; then
                                                        git clone https://github.com/MCSQNXY/Secluded-x64-linux.git $nasyt_dir/Secluded
                                                    else
                                                        git clone https://ghfast.top/https://github.com/MCSQNXY/Secluded-x64-linux.git $nasyt_dir/Secluded
                                                    fi
                                                    echo "chmod 777 "$nasyt_dir/Secluded/SecludedLauncher.out"" > $nasyt_dir/sec
                                                    echo "LD_LIBRARY_PATH=$HOME/.nasyt/Secluded; cd $nasyt_dir/Secluded && ./SecludedLauncher.out" >> $nasyt_dir/sec
                                                    chmod 777 "$nasyt_dir/sec"
                                                    $habit --msgbox "Secluded安装完成,请重启终端以生效\n启动命令为sec" 0 0
                                                fi
                                                ;;
                                            2)
                                                bash sec
                                                br
                                                esc
                                                ;;
                                            3)
                                                $habit --title "确认操作" --yesno "你确定要删除Secluded吗？" 0 0
                                                if [ $? -ne 0 ]; then
                                                    break
                                                fi
                                                echo "正在删除Secluded"
                                                rm $nasyt_dir/sec
                                                rm -rf $nasyt_dir/Secluded
                                                if [ $? -ne 0 ]; then
                                                    $habit --msgbox "删除失败,请手动删除。" 0 0
                                                else
                                                    $habit --msgbox "Secluded删除成功>_<" 0 0
                                                fi
                                                ;;
                                            4)
                                                $habit --msgbox "fp命令设置端口\n推荐使用tmux工具后台启动" 0 0
                                                ;;
                                            0)
                                                break
                                                ;;
                                            *)
                                                break
                                                ;;
                                        esac
                                        done
                                        ;;
                                    2)
                                        while true
                                        do
                                            clear
                                            TRSS
                                            read -p "请选择: " TRSS_xz
                                            case $TRSS_xz in
                                                1)
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
                                    3)
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
                                                3)
                                                    clear;echo "正在克隆github仓库。"
                                                    git clone https://github.com/AstrBotDevs/AstrBot
                                                    cd AstrBot
                                                    echo "添加python环境"
                                                    python3 -m venv ./venv
                                                    source venv/bin/activate
                                                    br;echo "正在安装依赖。"
                                                    python3 -m pip install -r requirements.txt -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
                                                    clear;br;echo "正在启动astrbot";python main.py
                                                    ;;
                                                4)
                                                    cd AstrBot
                                                    source venv/bin/activate
                                                    clear;br;echo "正在启动astrbot";python3 main.py
                                                    ;;
                                                0)
                                                    break
                                                    ;;
                                                *)
                                                    $habit --msgbox "无效的输入。" 0 0
                                                    esc
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    4)
                                        curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh
                                        bash napcat.sh --docker n --cli y
                                        esc
                                        ;;
                                    5)
                                        bash <(curl -L gitee.com/TimeRainStarSky/TRSS_OneBot/raw/main/Install.sh)
                                        esc
                                        ;;
                                    6)
                                        test_termux
                                        if [ $(uname -m) == x86_64 ]; then
                                            if [ -e $nasyt_dir/easybot/EasyBot ]; then
                                                $habit --msgbox "Easybot已安装" 0 0
                                            else
                                                test_wget
                                                test_unzip
                                                wget https://files.inectar.cn/d/ftp/easybot/1.4.0-c5859/linux-x64/easybot-1.4.0-c5859.zip -O easybot.zip
                                                unzip easybot.zip -d $nasyt_dir/easybot
                                            fi
                                            sudo chmod +x $nasyt_dir/easybot/*
                                            cd $nasyt_dir/easybot
                                            ./EasyBot
                                            read -p "脚本运行结束"
                                            exit
                                        else
                                            $habit --msgbox "不支持当前系统框架$(uname -m)" 0 0
                                        fi
                                        ;;
                                    0)
                                        cw
                                        break
                                        ;;
                                    *)
                                        break
                                        ;;
                            esac
                            done
                            ;;
                        4)
                            while true
                            do
                                game_menu
                                case $game_menu_xz in
                                    1)
                                        test_install bastet
                                        bastet
                                        esc
                                        ;;
                                    2)
                                        test_install nsnake
                                        nsnake
                                        esc
                                        ;;
                                    3)
                                        test_install ninvaders
                                        ninvaders
                                        esc
                                        ;;
                                    4)
                                        test_install cmatrix
                                        cmatrix
                                        esc
                                        ;;
                                    5)
                                        test_install cbonsai
                                        cbonsai -l
                                        esc
                                        ;;
                                    6)
                                        test_install cava
                                        cava
                                        esc
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        5)
                            while true
                            do
                                server_install_menu
                                case $server_install_xz in
                                    1)
                                        $habit --msgbox "欢迎使用SFS服务器安装脚本" 0 0
                                        echo "脚本作者:NAS油条"
                                        echo "感谢:"
                                        echo "SFSGamer(QQ:3818483936)"
                                        echo "(๑•॒̀ ູ॒•́๑)啦啦(QQ:2738136724)"
                                        echo "github地址:https://github.com/AstroTheRabbit/Multiplayer-SFS"; br
                                        $habit --title "确认操作" --yesno "回车键开始安装。" 0 0
                                        if [ $? -ne 0 ]; then
                                            break
                                        fi
                                        curl --progress-bar --output sfs -o /$HOME/sfs https://linux.class2.icu/shell/sfs_server
                                        mv sfs /usr/bin
                                        chmod +x /usr/bin/sfs
                                        echo "$(info) 快捷启动命令为: sfs"
                                        clear; echo "$(info) 正在运行。"; br
                                        sfs; br
                                        esc
                                        ;;
                                    2)
                                        if [ -e $nasyt_dir/phira/phira_linux_server_amd64 ]; then
                                            echo "$(info) 正在给予文件权限"
                                            chmod 777 $nasyt_dir/phira >/dev/null 2>&1
                                            if [ $? -ne 0 ]; then
                                                echo -e "$(info)$red 给予权限失败 $color"
                                                exit
                                            fi
                                            echo -e "$(info)$green phira已安装,正在启动 $color"
                                            phira
                                            esc
                                        else
                                            $habit --title "确认操作" --yesno "你确定要安装phira服务端吗？" 0 0
                                            if [ $? -ne 0 ]; then
                                                break
                                            fi
                                            test_curl #curl安装检测
                                            echo "$(info) 正在下载服务端文件(48.35MB)"
                                            echo -e "$pink 感谢 创欧云(coyjs.cn) 提供直链支持 $color"
                                            echo -e "$green 请耐心等待 $color"
                                            mkdir -p "$nasyt_dir/phira_server"
                                            curl --progress-bar -L -o "$nasyt_dir/phira_server/phira_linux_server_amd64" "http://api-lxtu.hydun.com/phira-mp-server-Linux_AMD64"
                                            if [ $? -ne 0 ]; then
                                                echo -e "$red 文件下载失败 $color"
                                                echo "[x] 请检查你的网络后重试"
                                                exit
                                            else
                                                echo -e "$(info)$green 文件下载成功 $color"
                                                echo "$(info) 正在给予权限"
                                                chmod 777 $nasyt_dir/phira_server/*
                                                if [ $? -ne 0 ]; then
                                                    echo -e "$(info) $red 给予失败 $color"
                                                    exit
                                                fi
                                                echo "$(info) 正在制作启动脚本"
                                                echo "cd $nasyt_dir/phira_server; chmod 777 phira_linux_server_amd64; ./phira_linux_server_amd64" > $nasyt_dir/phira
                                                chmod 777 $nasyt_dir/*
                                                echo -e "$(info)$green 请输入phira启动服务端 $color"
                                                echo -e "$(info) 推荐搭配tmux工具使用"
                                                exit
                                            fi
                                        fi
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        6) 
                            cpolar_instell
                            esc
                            ;;
                        0)
                            break
                            ;;
                        *)
                            cw
                            break
                            ;;
                    esac
                done
                ;;
            5)
                while true
                do
                    clear
                    app_install
                    case $app_install_xz in
                        1)
                            $habit --msgbox "检测到当前系统为 $sys 是否开始安装？" 0 0
                            $pkg_install ibus-libpinyin $yes_tg
                            $habit --msgbox "安装完成\n请打开桌面查看。" 0 0
                            ;;
                        2)
                            echo -e "$(info) 正在安装Blender建模软件"
                            $pkg_install Blender $yes_tg
                            $habit --msgbox "安装完成\n请打开桌面查看。" 0 0
                            esc
                            ;;
                        3)
                            $habit --title "确认操作" --yesno "你确定要安装linux应用商店吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            else
                                sudo $pkg_install gnome-software $yes_tg
                            fi
                            $habit --msgbox "安装完成\n请打开桌面查看。" 0 0
                            esc
                            ;;
                        4)
                            test_install bleachbit
                            bleachbit
                            esc
                            ;;
                        0)
                            cw
                            break
                            ;;
                        *)
                            cw
                            break
                            ;;
                    esac
                done
                ;;
            6)
                while true
                do
                    clear
                    Linux_shell
                    case $Linux_shell_xz in
                        1) 
                            if [ -e $nasyt_dir/yzy.sh ]; then
                               chmod +x $nasyt_dir/yzy.sh
                               bash $nasyt_dir/yzy.sh
                            else
                               curl -L https://gitee.com/krhzj/LinuxTool/raw/main/Linux.sh -o Linux.sh
                               chmod +x $nasyt_dir/yzy.sh
                               bash $nasyt_dir/yzy.sh
                            fi
                            esc
                            ;;
                        2) 
                            if [ -e $nasyt_dir/mky.sh ]; then
                               chmod +x $nasyt_dir/mky.sh
                               bash $nasyt_dir/mky.sh
                            else
                               curl -O mky.sh https://linux.mukongyun.com/linux.sh
                               chmod +x mky.sh
                               bash $nasyt_dir/mky.sh
                            fi
                            esc
                            ;;
                        3)
                            if [ -e "$nasyt_dir/MinecraftMotdStressTest/motd_stress_test_optimized.py" ]; then
                               test_python;test_pip #调用函数检测
                               pip_mcstatus;pip_colorama  #调用函数安装/检测
                               br;sleep 1
                               mc_test_ip=$($habit --title "服务器地址" \
                               --inputbox "NAS油条制作\n作者肝疼>_<\n请输入IP或域名" 0 0 \
                               2>&1 1>/dev/tty);
                               if [ $? -ne 0 ];then
                                  break
                               fi
                               mc_test_port=$($habit --title "端口" \
                               --inputbox "请输入服务器端口" 0 0 \
                               2>&1 1>/dev/tty);
                               mc_test_total=$($habit --title "数量" \
                               --inputbox "请输入要测压的数量（1000" 0 0 \
                               2>&1 1>/dev/tty);
                               python $nasyt_dir/MinecraftMotdStressTest/motd_stress_test_optimized.py --host $mc_test_ip --port $mc_test_port --total $mc_test_total
                               read -p "按回车键返回。"
                               $habit --msgbox "脚本运行结束" 0 0
                            else
                               echo -e "$(info) 正在克隆github仓库"
                               git clone https://github.com/konsheng/MinecraftMotdStressTest.git $nasyt_dir/MinecraftMotdStressTest 
                               if [ $? -ne 0 ]; then
                               echo -e "$(info) $red 克隆失败$color"
                               else
                               echo -e "$(info) $green 克隆成功$color"
                               fi
                               echo -e "$(info) 正在检查,脚本所需资源"
                               test_python;test_pip #调用函数安装/检测
                               pip_mcstatus;pip_colorama  #调用函数安装/检测
                               $habit --msgbox "安装完成,请重新打开脚本" 0 0
                            fi
                            ;;
                        4)
                            $habit --title "确认操作" --yesno "确定运行Docker 安装与换源脚本吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            fi
                            bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
                            ;;
                        5)
                            bash -c "$(curl -L https://gitee.com/nasyt/nasyt-linux-tool/raw/master/cs_shell.sh)"
                            ;;
                        6)
                            while true
                            do
                            termux_kali_install
                            case $termux_kali_install_xz in
                                1)
                                    wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh
                                    if [ $? -ne 0 ]; then
                                        $habit --msgbox "网络错误" 0 0
                                        exit
                                    fi
                                    $habit --title "确认操作" --yesno "脚本下载完成是否启动？" 0 0
                                    if [ $? -ne 0 ]; then
                                        break
                                    fi
                                    bash kali.sh
                                    ;;
                                2)
                                    test_git #git检查函数
                                    if [ -e $nasyt_dir/kali_install/AutoInstallKali/kalinethunter ]; then
                                        $habit --title "确认操作" --yesno "当前脚本已安装是否直接启动？" 0 0
                                        if [ $? -ne 0 ]; then
                                            break
                                        fi
                                        chmod 777 $nasyt_dir/kali_install/AutoInstallKali/*
                                        bash $nasyt_dir/kali_install/AutoInstallKali/kalinethunter
                                        esc
                                        $habit --msgbox "脚本执行完毕" 0 0
                                    else
                                        git clone https://gitee.com/zhang-955/clone.git $nasyt_dir/kali_install
                                        chmod 777 $nasyt_dir/kali_install/AutoInstallKali/*
                                        bash $nasyt_dir/kali_install/AutoInstallKali/kalinethunter
                                        esc
                                        $habit --msgbox "脚本执行完毕" 0 0
                                    fi
                                    ;;
                                3)
                                    bash -c "$(curl -L https://gitee.com/nasyt/termux_install_kali/raw/master/termux_install_kali.sh)"
                                    esc
                                    ;;
                                0)
                                    break
                                    ;;
                            esac
                            done
                            ;;
                        7)
                            awk -f <(curl -L gitee.com/mo2/linux/raw/2/2.awk)
                            esc
                            ;;
                        8)
                            echo -e "$(info) $blue 正在从Github拉取脚本文件$color"
                            bash -c "$(curl -L "https://ghfast.top/https://raw.githubusercontent.com/mohong-furry/mohong-furry/refs/heads/main/Tool_%E5%B7%A5%E5%85%B7/Utility_%E8%BE%85%E5%8A%A9%E7%AE%A1%E7%90%86/Git.sh")"
                            esc
                            ;;
                        9)
                            echo -e "$(info) 正在下载脚本"
                            curl -sS -O https://kejilion.pro/kejilion.sh >/dev/null 2>&1
                            if [ $? -ne 0 ]; then
                                echo -e "$(info) $red 脚本下载失败$color"
                            else
                                echo -e "$(info) $green 脚本下载成功$color"
                            fi
                            mv kejilion.sh $nasyt_dir
                            chmod +x $nasyt_dir/kejilion.sh
                            sleep 1s
                            bash $nasyt_dir/kejilion.sh
                            esc
                            ;;
                        10)
                            test_install wget curl
                            echo -e "$(info) 正在下载安装脚本"
                            wget -P $nasyt_dir/v2ray_shell.sh -N --no-check-certificate "https://ghfast.top/https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh"
                            if [ $? -ne 0 ]; then
                                echo -e "$(info) $red 文件下载失败$color"
                            else
                                echo -e "$(info) $green 文件下载成功$color"
                            fi
                            chmod 777 $nasyt_dir/*
                            $sudo_setup bash $nasyt_dir/v2ray_shell.sh
                            esc
                            ;;
                        0) 
                            break
                            ;;
                        *)
                            $habit --msgbox "无效的输入" 0 0
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
                bash -c "$(curl -L https://gitee.com/nasyt/nasyt-linux-tool/raw/master/up_history.sh)" #更新日志
                esc
                ;;
            9)
                while true
                do
                nasyt_setup_menu
                case $nasyt_setup_choice in
                    1)
                        habit_menu
                        case $habit_menu_xz in
                            1) echo "export habit="dialog"" >  $nasyt_dir/config.txt ;;
                            2) echo "export habit="whiptail"" > $nasyt_dir/config.txt ;;
                            3) sed -i '/^export=*/d' $nasyt_dir/config.txt ;;
                            0) break ;;
                        esac
                        echo -e "$(info) $green 习惯设置成功,请重新进入脚本$color"
                        exit
                        ;;
                    2)  
                        shell_uninstall
                        exit 1
                        ;;
                    3)
                        if ! grep -q "^export github_speed=" $nasyt_dir/config.txt; then
                           $habit --msgbox "已存在github加速地址\n并且地址为:\n$github_speed\n是否删除？" 0 0
                           sed -i '/export github_speed=/d' $nasyt_dir/config.txt
                        else
                           github_speed_address=$($habit --title "github加速地址" \
                           --inputbox "例如: https://ghfast.top/ \n\n请输入" 0 0 \
                           2>&1 1>/dev/tty)
                           if [ $? -ne 0 ]; then
                              break
                           fi
                        fi
                        echo "export github_speed=https://ghfast.top/" >> $nasyt_dir/config.txt
                        $habit --msgbox "地址添加成功，请重启脚本。" 0 0
                        exit 0
                        ;;
                    4)
                        test_ncdu
                        echo -e "$green正在扫描中$color"
                        sleep 1s
                        ncdu $nasyt_dir
                        esc
                        ;;
                    5)
                        while true
                        do
                            shell_backup_menu
                            case $shell_backup_xz in
                                1) shell_backup;esc;;
                                2) shell_recover;esc;;
                                0) break;;
                                *) break;;
                            esac
                        done
                        ;;
                    8)
                        echo -e "$(info) 正在补全文件中"
                        test_figlet
                        test_dialog
                        test_whiptail
                        test_curl
                        test_git
                        test_wget
                        echo -e "$(info) 命令运行完毕"
                        esc
                        ;;
                    9)  
                        rm $nasyt_dir/config.txt
                        $habit --msgbox "删除配置文件完成。" 0 0
                        exit
                        ;;
                    0)  break;;
                    *)  cw;break;;
                esac
                done
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
                break
                ;;
        esac
    done
    clear
}
#
#
#
color_variable # 定义颜色变量
all_variable # 全部变量
check_pkg_install # 检测包管理器
# 启动参数
if [ $# -ne 0 ]; then
    case $1 in
    -g|--gx)
      gx
      ;;
    -u|--upsource)
      upsource
      exit
      ;;
    -t|--tmux)
      tmux_tool
      tmux_tool_index
      echo -e "$(info) 执行完毕。"
      exit
      ;;
    -s|--skip)
      shell_skip=1
      ;;
    -v|-version|--version)
      echo
      echo "名称: nasyt"
      echo "版本: $version"
      echo "操作系统: $PRETTY_NAME"
      echo "位于目录: "
      command -v nasyt
      echo
      exit
      ;;
    -h|-help|--help)
      echo
      echo "用法:"
      echo "  nasyt [参数]"
      echo "参数:"
      echo "  -g, --gx 快捷更新脚本"
      echo "  -u, -upsource 快捷换软件源"
      echo "  -t, --tmux 快捷进入tmux管理"
      echo "  -s, --skip 直接进入菜单部分"
      echo "  -v, --version 输出脚本版本"
      echo "  -h, --help  输出命令帮助"
      echo
      echo "有关更多详细信息，请参见https://gitee.com/nasyt/nasyt-linux-tool"
      exit
      ;;
    *)
      echo "无效的参数"
      echo "$@"
      exit
    esac
fi
index_main # 脚本主程序