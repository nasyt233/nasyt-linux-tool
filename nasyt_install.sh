#!/bin/bash
# 本脚本由NAS油条制作
# NAS油条的实用脚本
#欢迎加入NAS油条赤石技术交流群
#有什么赤石技术可以进来交流
#赤石群号:610699712
#gum_tool
cd $HOME
time_date="2026/1/8"
version="v2.4.2.3"
nasyt_dir="$HOME/.nasyt" #脚本工作目录
source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置
bin_dir="usr/bin" #bin目录
nasyt_from="gitcode" #来源
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
    echo -e "\e[1;34m----------------------------\e[0m"
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

#MacOS_brew软件包安装。
brew_install() {
    if command -v brew >/dev/null 2>&1; then
        echo "break已安装"
    else
        xcode-select --install
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

}

#文件选择器
file_xz() {
    #处理
    file_browser_xz() {
        #第一个目录参数
        current_dir="${1:-.}"
        #第二个变量参数
        file_var="${2:-file_index}"
        
        # 检查目录是否存在
        if [[ ! -d "$current_dir" ]]; then
            echo "目标目录 '$current_dir' 不存在" >&2
            return 1
        fi
            #循环
            while true
            do
                local menu_items=()
                
                #如果不是根目录，添加返回选项
                if [[ "$current_dir" != "." ]]; then
                    menu_items+=(".." "📁 ◀返回上级目录")
                fi
                
                #添加当前目录内容
                while IFS= read -r item; do
                    if [[ -n "$item" ]]; then
                        if [[ -d "$current_dir/$item" ]]; then
                            menu_items+=("$item" "📁 $item/")
                        else
                            menu_items+=("$item" "📄 $item")
                        fi
                    fi
                done < <(ls -a "$current_dir" --group-directories-first)
                
                dir_xz=$($habit --title "文件选择器" \
                --menu "文件浏览器: $current_dir 🤓👇" 0 0 15 \
                "${menu_items[@]}" \
                2>&1 1>/dev/tty)
                
                if [[ -z "$dir_xz" ]]; then
                    break
                fi
                
                if [[ "$dir_xz" == ".." ]]; then
                    current_dir=$(dirname "$current_dir")
                elif [[ -d "$current_dir/$dir_xz" ]]; then
                    current_dir="$current_dir/$dir_xz"
                else
                    $habit --yesno "确认文件: $current_dir/$dir_xz" 0 0
                    if [ $? -eq 0 ]; then
                        eval "$file_var"="$current_dir/$dir_xz"
                        break
                    fi
                fi
            done    
        }
    file_browser_xz "$@"
    #输出
    #if [[ -n $file_index ]]; then
    #    echo $file_index
    #else
    #    echo $file_var
    #fi
}


#通用安装
test_install() {
    if command -v $* >/dev/null 2>&1; then
        echo -e "$(info) $green $*已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装$*"
        $sudo_setup $pkg_install $* $yes_tg
        install_error=$?
        if [ $install_error -ne 0 ]; then
            echo -e "$(info) $red $*安装失败。$color"
            echo -e "$(info) 正在更新软件包"
            $pkg_update $yes_tg
            if [ $? -ne 0 ]; then
                echo -e "$(info) $red 更新软件包失败$color"
                esc
            else
                echo -e "$(info) $green 更新软件包成功,正在尝试重新安装。$color"
                $sudo_setup $pkg_install $* $yes_tg
            fi
        else
            echo -e "$(info) $green $*安装成功。$color"
        fi
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
        shell_backup
    fi
    for url in "${urls[@]}"; do
        echo "$(info) 正在下载脚本"
        if curl --progress-bar -L -o "$HOME/nasyt" --retry 3 --retry-delay 2 --max-time $time_out "$url" >/dev/null 2>&1 ; then
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

#脚本恢复
shell_recover() {
    echo -e "$(info) 正在恢复脚本文件";sleep 0.5s
    file_xz $nasyt_dir/version shell_recover_var
    cp $shell_recover_var $nasyt_dir/nasyt >/dev/null 2>&1
    chmod 777 $nasyt_dir/*
    if command -v termux-info >/dev/null 2>&1; then
        cp $shell_recover_var $PREFIX/bin/nasyt
        chmod 777 $PREFIX/bin/nasyt
    else
        cp $shell_recover_var /usr/bin/nasyt
        chmod 777 /usr/bin/nasyt >/dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 脚本恢复失败$color"
    else
        echo -e "$(info) $green 脚本恢复成功$color"
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
    check_script_folder
    check_pkg_install
    color_variable
    all_variable
    gx
}

main