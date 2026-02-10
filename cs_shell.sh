#! /bin/bash

system_info() {
if [ -f /etc/os-release ]; then
    source /etc/os-release
elif command -v termux-info >/dev/null 2>&1; then
    PRETTY_NAME="Termux"
else
    echo "-_-无法获取操作系统信息。"
fi
}

check_pkg_install() {
    clear
    if command -v termux-info >/dev/null 2>&1; then
        sys="(Termux 终端)"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
        pkg_install="pkg install"
        deb_sys="pkg"
        yes_tg="-y"
        
    elif command -v apt-get >/dev/null 2>&1; then
        sys="(Debian/Ubuntu 系列)"
        pkg_install="sudo apt install"
        deb_sys="apt"
        yes_tg="-y"
        
    elif command -v yum >/dev/null 2>&1; then
        sys="(RHEL/Rocky/CentOS 7 及更早版本)"
        pkg_install="sudo yum install"
        deb_sys="yum"
        yes_tg="-y"
        
    elif command -v dnf >/dev/null 2>&1; then
        sys="(Fedora/RHEL/CentOS 8 及更高版本)"
        pkg_install="sudo dnf install"
        deb_sys="dnf"
        yes_tg="-y"
        
    elif command -v pacman >/dev/null 2>&1; then
        sys="(Arch Linux 系列)"
        pkg_install="sudo pacman -S"
        deb_sys="pacman"
        yes_tg="-y"
        
    elif command -v zypper >/dev/null 2>&1; then
        sys="(openSUSE 系列)"
        pkg_install="sudo zypper install"
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
        
    else
        echo ">_<未检测到支持的系统。"
        read -p "但是脚本依然可以运行。"
        br
    fi
}

dialog_install() {
        if command -v dialog &> /dev/null
        then
            echo "◉ dialog 已经安装，跳过安装步骤。"
        else 
            echo "正在安装dialog"
            $pkg_install dialog $yes_tg
            if [ $? -ne 0 ]; then
               echo "安装dialog失败"
            fi
        fi
}

cs_dir() {
   if [ -d "赤石科技1" ]; then
    dialog --msgbox "你目录里有石,是否铲石？" 0 0
    rm -rf 赤石科技*
    dialog --msgbox "石铲完了" 0 0
   fi
}

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

head1() {
  echo -e "$green                  $i $color"
  echo -e "$yellow              ╔════════╗$color"
  echo -e "$yellow              ║  ○  ○  ║$color"
  echo -e "$yellow              ║        ║$color"
  echo -e "$yellow              ║   ﹀   ║$color"
  echo -e "$yellow              ╚════════╝$color"
  
}

head2() {
  echo -e "$yellow             ╔═══════════╗$color"
  echo -e "$yellow             ║           ║$color"
  echo -e "$yellow             ║  ○    ○   ║$color"
  echo -e "$yellow             ║           ║$color"
  echo -e "$yellow             ║    ﹀     ║$color"
  echo -e "$yellow             ╚═══════════╝$color"
}

body1() {
  echo "╔═══════════╗             ╔═══════════╗ "
  echo "║           ║ ╔════════╗  ║           ║ "
  echo "║           ║ ║        ║  ║           ║ "
  echo "║           ║ ║        ║  ║           ║ "
  echo "║           ║ ║        ║  ║           ║ "
  echo "╚═══════════╝ ╚════════╝  ╚═══════════╝"
}

body2() {
  echo "             ╔═══════════╗                 "
  echo "╔════════╗   ║           ║  ╔════════╗"
  echo "║        ║   ║           ║  ║        ║"
  echo "║        ║   ║           ║  ║        ║"
  echo "║        ║   ║           ║  ║        ║"
  echo "╚════════╝   ║           ║  ╚════════╝"
  echo "             ╚═══════════╝                 "
}

leg1() {
  echo "              ╔════════╗"
  echo "              ║        ║"
  echo "              ║        ║"
  echo "              ║        ║"
  echo "              ╚════════╝"
}

leg2() {
  echo "             ╔═══════════╗"
  echo "             ║           ║"
  echo "             ║           ║"
  echo "             ║           ║"
  echo "             ║           ║"
  echo "             ╚═══════════╝"
}

index1() {
  head1
  body1
  leg1
}

index2() {
  head2
  body2
  leg2
}

main() {
  time=$(dialog --title "赤石科技" \
    --inputbox "本赤石科技由NAS油条制作 2.0版\n当前系统$PRETTY_NAME\n赤石交流群:610699712\n全部由echo命令制作\n请输入赤石间隔时间(推荐0.3)\n输入完成后点确定食用" 0 0 \
    2>&1 1>/dev/tty)
  if [ $? -ne 0 ]; then
    exit
  fi
  i=1
  cs_sl=$(dialog --title "赤石量" \
    --inputbox "请输入赤石次数（推荐50）" 0 0 \
    2>&1 1>/dev/tty)
  if [ $? -ne 0 ]; then
     cs_sl=50
  fi
  while [ ${i} -le ${cs_sl} ]
  do
  mkdir "赤石科技$i"
  clear
    index1
  sleep $time
  clear
    index2
  sleep $time
  i=$((i + 1))
  done
  dialog --msgbox "你赤了$((i - 1))坨石，赤饱了" 0 0
}

check_pkg_install
system_info
dialog_install
color_variable
cs_dir
main
  