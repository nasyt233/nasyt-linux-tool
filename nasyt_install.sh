#!/bin/bash
# 本脚本由NAS油条制作
# NAS油条的实用脚本
#欢迎加入NAS油条赤石技术交流群
#有什么赤石技术可以进来交流
#赤石群号:610699712
#gum_tool

habit() {
if command -v dialog >/dev/null 2>&1; then
    habit=dialog
elif command -v whiptail >/dev/null 2>&1; then
    habit=whiptail
else
    test_install dialog
    habit=dialog
fi
}

cd $HOME
nasyt_dir="$HOME/.nasyt" #脚本工作目录
source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置

# 检查包管理器的函数
check_pkg_install() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release #加载变量
    fi
    if [[ -n $TERMUX_VERSION ]]; then
        sys="(Termux 终端)"
        PRETTY_NAME="Termux终端"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list >/dev/null
        pkg_install="pkg install"
        pkg_remove="pkg remove"
        pkg_update="pkg update"
        deb_sys="pkg"
        yes_tg="-y"
        
        termux-toast "欢迎使用NAS油条termux脚本" &
        
    elif command -v apt-get >/dev/null 2>&1; then
        sys="(Debian/Ubuntu 系列)"
        pkg_install="apt install"
        pkg_remove="apt remove"
        pkg_update="apt update"
        sudo_setup="sudo"
        deb_sys="apt"
        yes_tg="-y"
        
    elif command -v dnf >/dev/null 2>&1; then
        sys="(Fedora/RHEL/CentOS 8 及更高版本)"
        pkg_install="dnf install"
        pkg_remove="dnf remove"
        pkg_update="dnf update"
        sudo_setup="sudo"
        deb_sys="dnf"
        yes_tg="-y"
        
    elif command -v yum >/dev/null 2>&1; then
        sys="(Fedora/RHEL/Rocky/CentOS 7 及更早版本)"
        pkg_install="yum install"
        pkg_remove="yum remove"
        pkg_update="yum update"
        sudo_setup="sudo"
        deb_sys="yum"
        yes_tg="-y"
        
    elif command -v pacman >/dev/null 2>&1; then
        sys="(Arch Linux 系列)"
        pkg_install="pacman -S"
        pkg_remove="pacman -R"
        pkg_update="pacman -Syu"
        sudo_setup="sudo"
        deb_sys="pacman"
        yes_tg="-y"
        
    elif command -v zypper >/dev/null 2>&1; then
        sys="(openSUSE 系列)"
        pkg_install="zypper in -y"
        pkg_remove="zypper rm"
        sudo_setup="sudo"
        deb_sys="zypper"
        yes_tg="-y"
        
    elif command -v apk >/dev/null 2>&1; then
        sys="(Alpine/PostmarketOS系统)"
        sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
        pkg_install="apk add"
        pkg_remove="apk del"
        pkg_update="apk update"
        sudo_setup="sudo"
        deb_sys="apk"
        yes_tg=""
        
    elif command -v emerge >/dev/null 2>&1; then
        sys="(gentoo/funtoo 系统)"
        pkg_install="emerge -avk"
        pkg_remove="emerge -C"
        sudo_setup="sudo"
        deb_sys="emerge"
        yes_tg="-y"
        
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        brew_install #brew安装检测
        sys="(MacOS 系统)"
        pkg_install="brew install"
        sudo_setup="sudo"
        deb_sys="brew"
        yes_tg="-y"
        read -p "抱歉，目前没有完全适配MacOS系统"
        
    else
        echo -e "$(info) >_<未检测到支持的系统。"
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

#更新查看
gx_show() {
    if [[ $new_version == $version ]]; then
        echo -e "$green 当前版本已是最新。 $color"
    else
        echo -e "$red 有新版本更新$new_version $color"
    fi
}

#更新链接来源
version_update() {
    new_version=$(curl "https://raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/version.txt") 
}

info() {
    echo -e "$cyan[$(date +"%r")]$color $green[INFO]$color" $*
}

br() {
    echo -e "\e[1;34m----------------------------\e[0m"
}

esc() {
    echo -e "$(info) 按$green回车键$color$blue返回$color,按$yellow Ctrl+C$color$red退出$color"
    read
}

#国内外检查
country() {
    country=$(curl -s https://myip.ipip.net | grep -oE "中国|China" 2>/dev/null)
    if [ -n "$country" ]; then
        echo "当前在中国"
        github_speed=https://ghfast.top/
    else
        echo "当前不在中国"
        github_speed=
    fi
}
#错误处理
cw() {
    if [ $cw_test -ne 0 ]; then
       break
    fi
}

#MacOS_brew软件包安装。
brew_install() {
    if command -v brew >/dev/null 2>&1; then
        echo "break已安装"
    else
        xcode-select --install
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

}

#通用安装
test_install() {
    if command -v $* >/dev/null 2>&1; then
        echo -e "$(info) $green $*已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装$*"
        if command -v eatmydata >/dev/null 2>&1; then
            eatmydata_setup=eatmydata
        fi
        $sudo_setup $eatmydata_setup $pkg_install $* $yes_tg
        install_error=$?
        if [ $install_error -ne 0 ]; then
            echo -e "$(info) $red $*安装失败。$color"
            echo -e "$(info) $red 错误代码$install_error $color"
            echo -e "$(info) 正在尝试更新软件包"
            $sudo_setup $pkg_update $yes_tg
            if [ $? -ne 0 ]; then
                echo -e "$(info) $red 更新软件包失败$color"
                esc
            else
                echo -e "$(info) $green 更新软件包成功,正在尝试重新安装。$color"
                $sudo_setup $eatmydata_setup $pkg_install $* $yes_tg
            fi
        else
            echo -e "$(info) $green $*安装成功。$color"
        fi
    fi
}

#通用卸载函数
test_remove() {
    if command -v $* >/dev/null 2>&1; then
        $sudo_setup $pkg_remove $* $yes_tg
        remove_error=$?
        if [[ $remove_error -ne 0 ]]; then
            echo -e "$(info) $red $* 软件包卸载失败,按回车键继续。 $color";read
        fi
    else
        echo -e "$(info) $green 不存在这个软件包，无需卸载$color"
    fi
}

check_script_folder () {
    if [ -d "$nasyt_dir" ]; then
        echo
    else
        mkdir -p "$nasyt_dir"
    fi
    if [ -d "$nasyt_dir/version" ]; then
        echo
    else
        mkdir -p "$nasyt_dir/version"
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






#更新以及安装
gx() {
    # 下载安装更新
    br
    if command -v nasyt >/dev/null 2>&1; then
        echo -e "$(info) 检测到已安装nasyt脚本"
        shell_backup
    fi
    for url in "${urls[@]}"; do
        echo "$(info) 正在下载脚本"
        if curl --progress-bar -L -o "$HOME/nasyt" --retry 1 --retry-delay 2 --max-time $time_out "$url" >/dev/null 2>&1 ; then
            cp nasyt /usr/bin/ >/dev/null 2>&1
            cp nasyt $PREFIX/bin >/dev/null 2>&1
            mv nasyt $nasyt_dir/nasyt >/dev/null 2>&1
            echo -e "$(info) 正在给予权限 $color"
            chmod 777 $nasyt_dir/nasyt >/dev/null 2>&1
            chmod 777 /usr/bin/nasyt >/dev/null 2>&1
            chmod 777 $PREFIX/bin/nasyt >/dev/null 2>&1
            echo -e "$(info) 正在写入启动文件 $color"
            source $HOME/.bashrc >/dev/null 2>&1
            if command -v nasyt >/dev/null 2>&1; then
                echo -e "$(info)$green 脚本更新成功 $color"
                #rm $nasyt_dir/nasyt.bak >/dev/null 2>&1
                #rm /usr/bin/nasyt.bak >/dev/null 2>&1
                #rm $PREFIX/bin/nasyt.bak >/dev/null 2>&1
            else
                echo -e "$(info)$green 脚本安装失败，正在还原备份文件 $color"
                shell_recover
            fi
            # echo -e "$(info) 正在安装必要文件"
            echo "$(info) 如果不行请重新连接终端"
            echo -e "$(info) 启动命令为$yellow nasyt$color"
            source $HOME/.bashrc >/dev/null 2>&1
            exit 0
        else
            echo "$(info)✗ 当前链接下载失败，2秒后尝试下一个链接..."
            sleep 3
        fi
    done
    echo -e "$(info) $red 所有链接均下载失败，请检查网络或链接有效性$color"
    exit
}

#脚本备份
shell_backup() {
    echo "$(info) 正在备份脚本文件";sleep 0.5s
    cp $nasyt_dir/nasyt $nasyt_dir/version/nasyt$version.bak >/dev/null 2>&1
    #if command -v termux-info >/dev/null 2>&1; then
    #    cp $PREFIX/bin/nasyt $PREFIX/bin/nasyt$version.bak >/dev/null 2>&1
    #else
    #    cp /usr/bin/nasyt /usr/bin/nasyt$version.bak>/dev/null 2>&1 >/dev/null 2>&1
    #fi
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 脚本备份失败，跳过备份环节$color"
    else
        echo -e "$(info) $green脚本备份成功$color"
    fi
}


all_variable() {
    OUTPUT_FILE="nasyt" # 下载文件名
    time_out=10  # curl超时时间（秒）
    urls=(
      "https://nasyt.hoha.top/shell/nasyt.sh"
      "https://raw.githubusercontent.com/nasyt233/nasyt-linux-tool/refs/heads/master/nasyt.sh"
      "https://ghfast.top/https://raw.githubusercontent.com/nasyt233/nasyt-linux-tool/refs/heads/master/nasyt.sh"
      "https://nasyt2.class2.icu/shell/nasyt.sh"
    )
    
}

main() {
    habit
    country >/dev/null 2>&1
    check_script_folder
    check_pkg_install
    color_variable
    all_variable
    gx
}

main