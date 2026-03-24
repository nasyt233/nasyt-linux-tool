#!/bin/bash
# 禁止用于任何非法攻击行为
# 使用者需遵守当地法律法规

# 本脚本由NAS油条制作
# NAS油条的实用脚本
# 欢迎加入NAS油条技术交流群
# 有什么技术可以进来交流
# 群号:610699712
# gum_tool dust

cd $HOME
time_date="2026/3/24"
version="v2.4.3.2"
nasyt_dir="$HOME/.nasyt" #脚本工作目录
source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置
#bin_dir="usr/bin" #bin目录
#nasyt_from="gitcode" # 脚本来源
#> $nasyt_dir/shell.log
#exec > >(tee -a "$nasyt_dir/shell.log") 2>&1

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
            echo "感谢QQ:2738136724提供下载服务"
            br
            if command -v nasyt &> /dev/null
            then
               echo "1) Linux工具箱 (更新)"
               echo "2) Linux工具箱 (启动)"
            else
               echo "1) Linux工具箱 (安装)"
               #echo "2) Linux工具箱 (启动)"
            fi
            if command -v chafa >/dev/null 2>&1; then
                echo "3) 随机美图"
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
                1145)
                    nasyt_body=$(curl https://api.github.com/repos/nasyt233/nasyt-linux-tool/releases/latest | grep -m1 '"body":' | sed -E 's/.*"([^"]+)".*/\1/')
                    $habit --msgbox "$nasyt_body" 0 0
                    esc ;;
                3)
                    tp_curl=https://www.loliapi.com/acg/pe
                    acg pe ;;
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
    if [[ -z $PRETTY_NAME ]]; then
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
        pkg_update="sudo pacman -Syu"
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

all_variable() {
    OUTPUT_FILE="nasyt" # 下载文件名
    time_out=5  # curl超时时间（秒）
    urls=(
      "https://nasyt.hoha.top/shell/nasyt.sh"
      "https://raw.githubusercontent.com/nasyt233/nasyt-linux-tool/refs/heads/master/nasyt.sh"
      "https://ghfast.top/https://raw.githubusercontent.com/nasyt233/nasyt-linux-tool/refs/heads/master/nasyt.sh"
      "https://nasyt2.class2.icu/shell/nasyt.sh"
    )
    
}



# 函数

default_habit() {
    if [[ -n $habit ]]; then
        echo
    else
        test_install dialog
        habit=dialog
    fi
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

br_2() {
    echo "----------------------------"
}

esc() {
    echo -e "$(info) 按$green回车键$color$blue返回$color,按$yellow Ctrl+C$color$red退出$color"
    read
}

bash_url() {
    bash -c "$(curl -fsL $@)"
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 拉取脚本失败$color"
    fi
}


#国内外检测
country() {
    country=$(curl -s https://myip.ipip.net | grep -oE "中国|China" 2>/dev/null)
    if [ -n "$country" ]; then
        echo "当前在中国"
        github_speed="ghfast.top"
    else
        echo "当前不在中国"
        github_speed=""
    fi
}

# 网络工具使用限制检查
disclaimer() {
    if [[ -f "$nasyt_dir/disclaimer" ]]; then
        return 0
    fi
    
    $habit --title "免责声明" \
    --yesno "本工具仅限合法使用\n带来的后果由使用者承担全部责任\n你是否同意使用条款？" 0 0

    if [ $? -eq 0 ]; then
        touch "$nasyt_dir/disclaimer"
        return 0
    else
        $habit --msgbox "未同意使用条款,脚本退出。" 0 0
        clear
        exit 0
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

#监控服务器资源
resources_show() {
    echo -e "$(info) 正在读取数据中"
    if [[ -z $PRETTY_NAME ]]; then
        resources_show_notermux="CPU 使用率：不支持termux"
    else
        cpu_usage=$(grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; print "" sprintf("%.1f%%", u/t*100)}') >/dev/null 2>&1
        resources_show_notermux="CPU 使用率：$cpu_usage%"
        cpu_core=grep 'cpu[0-9]' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; printf "CPU核心%s：%.1f%%\n", substr($1,4), u/t*100}'
    fi
    #cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*,*([-9.)* id.*/\1/" | awk '{print 100}' >/dev/null 2>&1)
    mem_total=$(grep MemTotal /proc/meminfo | awk '{printf "%.1fGiB", $2/1024/1024}'); >/dev/null 2>&1
    mem_available=$(grep MemAvailable /proc/meminfo | awk '{printf "%.1fGiB", $2/1024/1024}'); >/dev/null 2>&1
    mem_usage=$(free | awk '/Mem/ {print $3/$2*100.0}') >/dev/null 2>&1
    #mem_used=$(grep MemTotal /proc/meminfo | awk '{t=$2} END {grep MemAvailable /proc/meminfo | awk -v t=t "{printf \"%.1fGiB\", (t-$2)/1024/1024}"}') >/dev/null 2>&1
    swap_total=$(grep SwapTotal /proc/meminfo | awk '{if($2==0){print "0.0GiB"}else{printf "%.1fGiB", $2/1024/1024}}'); >/dev/null 2>&1
    swap_free=$(grep SwapFree /proc/meminfo | awk '{if($2==0){print "0.0GiB"}else{printf "%.1fGiB", $2/1024/1024}}'); >/dev/null 2>&1
    #swap_used=$(grep SwapTotal /proc/meminfo | awk '{t=$2} END {grep SwapFree /proc/meminfo | awk -v t=t "{if(t==0){print \"0.0GiB\"}else{printf \"%.1fGiB\", (t-$2)/1024/1024}}"}'); >/dev/null 2>&1
    ps_quantity=$(ps -e --no-headers | wc -l) >/dev/null 2>&1
    swap_usage=$(grep -E 'SwapTotal|SwapFree' /proc/meminfo | awk -v total=$(grep SwapTotal /proc/meminfo | awk '{print $2}') '{if($1=="SwapFree:"){if(total==0){printf "利用率：0.0%%\n"}else{printf "利用率：%.1f%%\n", (total-$2)/total*100}}}') >/dev/null 2>&1
    echo -e "$(info) $green 读取数据完毕$color"
    $habit --msgbox "操作系统: $PRETTY_NAME \n\n$resources_show_notermux \n    $cpu_core\n内存总量：$mem_total 使用率：$mem_usage%\n    可用：$mem_available  \n\nSwap总量：$swap_total $swap_usage\n    可用：$swap_free \n\n进程数量: $ps_quantity" 0 0
}

# 根据时间返回问候语
get_greeting() {
    local hour=$(date +"%H")
    if [[ -z $PRETTY_NAME ]]; then
        get_sys=termux
    else
        get_sys=linux
    fi
    case $hour in
        05|06|07|08|09|10|11)
            echo "🌅 早上好！欢迎使用$get_sys工具箱"
            ;;
        12|13|14|15|16|17|18)
            echo "☀️ 下午好！欢迎使用$get_sys工具箱"
            ;;
        *)
            echo "🌙 晚上好！欢迎使用$get_sys工具箱"
            ;;
    esac
}

test_termux() {
    if [[ -z $PRETTY_NAME ]]; then
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
            test_install libnewt
        elif command -v dnf >/dev/null 2>&1; then
            echo "检测到dnf软件包管理系统，正在安装newt软件包"
            test_install newt
        else
            test_install whiptail
        fi
    fi
}

test_eatmydata() {
    if command -v eatmydata >/dev/null 2>&1; then
        echo -e "$green ◉ eatmydata已安装,跳过安装$color"
    else
        if [[ -e /etc/os-release ]]; then
            echo -e "$(info) 正在安装eatmydata"
            $pkg_install 'eatmydata' $yes_tg
        fi
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

# docker安装脚本
test_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "docker已安装"
    else
        curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    fi
}

test_bastet() {
    echo "111"
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
            echo -e "$(info) $red 错误代码$install_error $color"
            echo -e "$(info) 正在尝试更新软件包"
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

#pip通用安装
pip_install() {
    echo -e "$(info) 正在搜索本地pip库"
    if pip show "$*" > /dev/null 2>&1; then
       echo -e "$(info) $green ◉ $*已安装,跳过安装$color"
    else
        echo -e "$(info) 正在使用pip安装$*"
        pip install $*
        if [ $? -ne 0 ]; then
            echo -e "$(info) $red pip安装$*失败$color"
        else
            echo -e "$(info) $green $*安装成功$color"
        fi
    fi
}

pipx_install() {
    eval PATH=$PATH:$HOME/.local/bin >/dev/null 2>&1
    
    test_install python*-pip
    pip install pipx
    echo -e "$(info) 正在搜索本地pip库"
    if pip show "$*" > /dev/null 2>&1; then
       echo -e "$(info) $green  $*已安装,跳过安装$color"
    else
        echo -e "$(info) 正在安装$*中"
        pipx install $* --force --break-system-packages
        if [ $? -ne 0 ]; then
            echo -e "$(info) $red $*安装失败$color"
        else
            echo -e "$(info) $green $*安装成功$color"
        fi
    fi
}

pip_mcstatus() {
    if pip show "mcstatus" > /dev/null 2>&1; then
       echo -e "$green ◉ mcstatus已安装,跳过安装$color"
    else
       echo -e "$(info) 正在使用pip安装mcstatus"
       pip install mcstatus
    fi
}

pip_colorama() {
    if pip show "colorama" > /dev/null 2>&1; then
       echo -e "$green ◉ colorama已安装,跳过安装$color"
    else
       echo -e "$(info) 正在使用pip安装colorama"
       pip install colorama
    fi
}

ad_gg () {
    echo -e "$pink本脚本由创欧云提供直链支持 ^o^$color"
    echo "感谢创欧云coyjs.cn赞助"
}

#错误函数处理
error() {
    echo -e "\e[31m错误: $1\e[0m"
    echo -e "$(info) 错误代码为: $?"
    exit 1
}

#工作环境
termux_PATH () {
    if [[ -z $PRETTY_NAME ]]; then
        if ! grep -q "^export PATH=$HOME/.nasyt:" $HOME/.bashrc; then
            echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
        else
            echo -e "PATH 已存在于 $nasyt_dir，跳过添加"
        fi
    else
        if ! grep -q "^export PATH="$nasyt_dir:"" $HOME/.bashrc; then
            echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.bashrc
        else
            echo -e "PATH 已存在于 .bashrc  跳过添加"
        fi
    fi
    #对zsh检测
    if [ -e $HOME/.zshrc ]; then
        if [[ -z $PRETTY_NAME ]]; then
            if ! grep -q "^export PATH=$HOME/.nasyt:" $HOME/.zshrc; then
                echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.zshrc
            else
                echo -e "$(info) PATH 已存在于 $nasyt_dir，跳过添加"
            fi
    else
            if ! grep -q "^export PATH="$nasyt_dir:"" $HOME/.zshrc; then
                echo "export PATH="$nasyt_dir:"$PATH""" >> $HOME/.zshrc
            else
                echo -e "$(info) PATH 已存在于 .zshrc  跳过添加"
            fi
        fi
    fi
    chmod +x $nasyt_dir/* >/dev/null 2>&1 #给予权限
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
        echo
    else
        mkdir -p "$nasyt_dir"
    fi
    if [ -d "$nasyt_dir/version" ]; then
        echo
    else
        mkdir -p "$nasyt_dir/version"
    fi
    if [ -d "$nasyt_dir/acg" ]; then
        echo
    else
        mkdir -p "$nasyt_dir/acg"
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
               test_install dialog
               echo "export habit="dialog"" >  $nasyt_dir/config.txt
               ;;
           2) 
               test_whiptail
               echo "export habit="whiptail"" > $nasyt_dir/config.txt
               ;;
           3) sed -i '/^export=*/d' $nasyt_dir/config.txt ;;
           *) break ;;
        esac
    elif [ -n "$habit" ]; then
        echo -e "菜单方式为: $yellow$habit$color"
    fi
    if command -v $habit >/dev/null 2>&1; then
        echo -e "$green $habit 已安装，跳过安装步骤$color"
    else
        echo "$habit 未安装，正在安装。"
        test_install $habit
        if [ $? -ne 0 ]; then
            echo -e "$red 安装失败 $color"
        fi
    fi
    
}

# 主菜单
show_menu() {
    index_menu_xz=$($habit --title "NAS油条Linux工具箱" \
    --backtitle "版本:$version    更新时间:$time_date"\
    --menu "本工具箱由NAS油条制作\nQQ群:610699712\n请使用方向键+回车键进行操作\n请选择你要启动的项目：" \
    0 0 10 \
    1 "系统信息" \
    2 "系统工具" \
    3 "网络工具" \
    4 "常用工具" \
    5 "软件安装" \
    6 "其它脚本" \
    7 "更新脚本" \
    8 "更新历史" \
    9 "脚本设置" \
    10 "随机美图" \
    0 "退出脚本" \
    2>&1 1>/dev/tty)
    
}

# 查看菜单
look_menu() {
    
    look_choice=$($habit --title "查询菜单" \
    --menu "请选择" 0 0 10 \
    1 "当前时间" \
    2 "配置信息" \
    3 "当前 IP" \
    4 "系统logo" \
    5 "地理位置" \
    6 "进程列表" \
    7 "运行时间" \
    8 "监控资源" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
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
    7 "language设置" \
    8 "磁盘挂载设置" \
    9 "虚拟内存设置" \
    10 "系统清理"  \
    11 "切换pip国内源" \
    12 "同步上海时间" \
    13 "系统密码设置" \
    14 "修改主机名" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

# 安装常用工具。
often_tool() {
   often_tool_linux() {
    often_tool_choice=$($habit --title "安装linux常用工具" \
    --menu "请选择" 0 0 10 \
    1 "🐳docker管理"\
    2 "🖥各种面板" \
    3 "🤖bot机器人" \
    4 "👾娱乐游戏" \
    5 "🚀各种服务端" \
    6 "🌍穿透工具" \
    7 "📄编辑工具" \
    8 "📥下载工具" \
    9 "🔄转换工具" \
    10 "☰ 其他工具" \
    0 "◀返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    
   often_tool_termux() {
    often_tool_choice=$($habit --title "安装termux常用工具" \
    --menu "请选择" 0 0 10 \
    3 "🤖bot机器人相关" \
    4 "👾娱乐相关" \
    6 "🌍穿透工具" \
    7 "📄编辑工具" \
    8 "📥下载工具" \
    9 "🔄转换工具" \
    10 "其他工具" \
    0 "◀返回上层菜单" \
    2>&1 1>/dev/tty)
    }
    
    #检查当前系统
    often_tool_main() {
    if [[ -z $PRETTY_NAME ]]; then
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
        1 "🎶 Multimedia:小说/图像/影音 (gimp,mpv,chafa)" \
        2 "📦 Model:建模/设计/制图 (blender,freeCAD)" \
        3 "📄 office:办公/PPT/流程图 (wps,LibreOffice)" \
        4 "🛠 system:软件管理/系统管理 (flatpak,bleachbit)" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
    }
    
    image_menu() {
        image_menu_xz=$($habit --clear --title "🎶 图像与影音" \
        --menu "GNU和DE分别指的是桌面环境\nTUI指的终端环境\n请选择:" 0 0 10 \
        1 "GIMP (GNU 图像处理程序)" \
        2 "feh  (DE 轻量级图片查看工具)" \
        3 "chafa (TUI 图像显示工具)" \
        4 "MPV (开源、跨平台的音视频播放器)" \
        5 "w3m (TUI 网页浏览器)" \
        6 "calibre (DE 最受欢迎的电子书应用)" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
    }
    
    model_menu() {
        model_menu_xz=$($habit --clear --title "建模/绘图/制图" \
        --menu "请选择:" 0 0 10 \
        1 "💡 Blender (工业级,用于电影制作和设计3D模型)" \
        2 "🔩 FreeCAD (免费开源,多功能CAD建模机械软件)" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
    }
    
    work_menu() {
    work_menu_xz=$($habit --clear --title "办公" \
    --menu "请选择：" 0 0 10 \
    1 "📋 WPS 365linux (WPS公司的办公软件)" \
    2 "📄 LibreOffice (开源免费社区办公套件)" \
    9 "更多内容可联系作者添加" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    
    }
    
    system_app_menu() {
        system_app_menu_xz=$($habit --clear --title "标题" \
        --menu "文字" 0 0 10 \
        1 "📦 Flatpak  (跨平台包管理应用商店)" \
        2 "📦 gnome-software (系统软件商店)" \
        3 "🗑 bleachbit  (linux垃圾清理工具)" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
    }
    app_install_termux() {
        $habit --msgbox "此区域只支持linux系统\n抱歉,不支持Termux终端>_<" 0 0
        break
    }
    app_install_main() {
        if [[ $shell_skip -eq 1 ]]; then
            app_install_linux
        elif [[ -z $PRETTY_NAME ]]; then
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
    2 "网络连通性测试工具" \
    3 "Tmux终端工具" \
    4 "TMOE实用工具" \
    6 "ranger文件管理工具" \
    7 "hashcat工具" \
    8 "burpsuite工具" \
    9 "glow md文件浏览工具" \
    10 "服务器邮箱端口开放检测" \
    0 "返回上层菜单" \
    2>&1 1>/dev/tty)
}

# 各种脚本。
Linux_shell() {
    more_shell_menu() {
    more_shell_menu_xz=$($habit --title "服务器脚本" \
    --menu "请选择:" 0 0 10 \
    1 "亚洲云LinuxTool脚本工具" \
    2 "木空云LinuxTool脚本工具" \
    3 "失控LinuxTool脚本工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    }
    
    linux_shell_linux() {
    Linux_shell_xz=$($habit --title "各种脚本" \
    --menu "请选择" 0 0 10 \
    1 "更多服务器管理脚本工具" \
    3 "MC 压力测试 脚本工具" \
    4 "Docker 安装与换源脚本" \
    5 "神秘脚本 (纯整活)" \
    7 "TMOE脚本工具" \
    8 "git管理脚本" \
    9 "kejilion脚本工具" \
    10 "v2ray一键安装脚本" \
    91 "欢迎联系作者添加" \
    0 "返回" \
    2>&1 1>/dev/tty)
    
    }
    linux_shell_termux() {
    Linux_shell_xz=$($habit --title "各种termux脚本" \
    --menu "请选择" 0 0 10 \
    3 " MC 压力测试 脚本工具" \
    5 "神秘脚本 (纯整活)" \
    6 "Termux版kali一键安装脚本" \
    7 "TMOE脚本工具" \
    8 "git管理脚本" \
    9 "kejilion脚本工具" \
    11 "naster脚本(termux)" \
    91 "欢迎联系作者添加" \
    0 "返回" \
    2>&1 1>/dev/tty)
    
    }
    linux_shell_main() {    
        if [[ $shell_skip -eq 1 ]]; then
            linux_shell_linux
        elif [[ -z $PRETTY_NAME ]]; then
            linux_shell_termux
        else
            linux_shell_linux
        fi
   }
   linux_shell_main
}

panel_menu() {
    panel_menu_xz=$($habit --title "各种服务器面板" \
    --menu "请选择" 0 0 10 \
    1 "宝塔(bt.cn)面板" \
    2 "AMH面板" \
    3 "1panel面板" \
    4 "MCSManager面板" \
    5 "小皮面板" \
    6 "GMSSH面板" \
    7 "Dpanel面板" \
    8 "青龙面板" \
    9 "Ajenti面板" \
    10 "Cockpit面板" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

bot_install_menu() {
    bot_linux_menu() {
    bot_install_xz=$($habit --title "bot安装" \
    --menu "请选择:" 0 0 10 \
    1 "Secluded机器人" \
    2 "TRSS 系列脚本" \
    3 "Astrbot机器人" \
    4 "Napcat框架" \
    5 "TRSS OneBot脚本" \
    6 "Easybot机器人" \
    7 "koishi机器人" \
    8 "MaiBot机器人" \
    9 "Karin机器人" \
    10 "nonebot框架" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    }
    bot_termux_menu() {
    bot_install_xz=$($habit --title "bot安装" \
    --menu "请选择:" 0 0 10 \
    1 "Secluded机器人" \
    3 "Astrbot机器人" \
    4 "Napcat框架" \
    5 "TRSS OneBot脚本" \
    9 "Karin机器人" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    }
    if [[ $shell_skip -eq 1 ]]; then
        bot_linux_menu
    elif [[ -z $PRETTY_NAME ]]; then
        bot_termux_menu
    else
        bot_linux_menu
    fi
}

# docker管理工具
docker_menu() {
    if [[ -z $PRETTY_NAME ]]; then
        $habit --msgbox "termux爬一边去" 0 0
        exit
    fi
    while true
    do
        if command -v docker >/dev/null 2>&1; then
            docker_menu_xz=$($habit --title "docker管理" \
            --menu "docker管理 部分功能开发中... \n请选择" 0 0 10 \
            1 "docker信息" \
            2 "容器管理" \
            3 "镜像管理" \
            4 "下载系统镜像" \
            5 "清理容器/镜像" \
            6 "卸载docker" \
            0 "◀返回" \
            2>&1 1>/dev/tty)
        else
            $habit --title "docker管理" --yesno "docker未安装是否安装?" 0 0
            if [ $? -ne 0 ]; then
                return 0
                continue
                break
            else
                test_docker
            fi
        fi
        case $docker_menu_xz in
            1)
                # Docker 信息
                clear
                echo -e "${CYAN}${BOLD}Docker 信息${PLAIN}"
                br
                docker version
                br
                docker info
                br
                esc
                ;;
            2)
                while true
                do
                    containers=()
                    while IFS=' ' read -r docker_id docker_image; do
                        containers+=("$docker_id" "$docker_image" )
                    done < <(docker ps -a --format "{{.ID}} {{.Image}}")
                    docker_repo_xz=$($habit --menu "请选择要管理的容器：" 0 0 0 "${containers[@]}" 0 "◀返回" 3>&1 1>&2 2>&3)
                    if [ $docker_repo_xz -eq 0 ]; then
                        break
                    fi
                    while true
                    do
                        docker_image=$(docker inspect --format='{{.Name}}' $docker_repo_xz )
                        docker_run="$(docker inspect --format='{{.State.Status}}' $docker_repo_xz)"
                        if [ "$docker_run" = "running" ]; then
                            docker_run_status="✓ 当前容器正在运行"
                        else
                            docker_run_status="✗ 当前容器未运行"
                        fi
                        docker_repo_gl=$($habit --title "容器管理" \
                        --menu "当前容器名字:$docker_image \n当前容器状态: $docker_run_status \n请选择" 0 0 0\
                        1 "启动容器" \
                        2 "停止容器" \
                        3 "重启容器" \
                        4 "删除容器" \
                        5 "查看日志" \
                        6 "进入终端"\
                        0 "◀返回" \
                        2>&1 1>/dev/tty)
                        case $docker_repo_gl in
                            1)
                                docker start $docker_repo_xz
                                $habit --msgbox "$docker_run_status" 0 0
                                esc
                                ;;
                            2)
                                docker stop $docker_repo_xz
                                esc
                                ;;
                            3)
                                docker restart $docker_repo_xz
                                esc
                                ;;
                            4)
                                docker rm $docker_repo_xz
                                esc
                                ;;
                            5)
                                docker logs $docker_repo_xz
                                esc
                                ;;
                            6)
                                docker exec -it $docker_repo_xz /bin/bash || docker exec -it $docker_repo_xz /bin/sh
                                esc
                                ;;
                            *)
                                break
                                ;;
                        esac
                    done
                done
                ;;
            3)
                $habit --msgbox "开发中" 0 0
                ;;
            4)
                $habit --msgbox "开发中" 0 0
                ;;
            5)
                $habit --msgbox "开发中" 0 0
                ;;
            114514)
                while true
                do
                    containers=()
                    while IFS=' ' read -r docker_id docker_image; do
                        containers+=("$docker_id" "$docker_image" )
                    done < <(docker ps -a --format "{{.ID}} {{.Image}}")
                    docker_image_xz=$($habit --menu "请选择要管理的镜像：" 0 0 0 "${containers[@]}" 0 "◀返回" 3>&1 1>&2 2>&3)
                    if [ $docker_repo_xz -eq 0 ]; then
                        break
                    fi
                    while true
                    do
                        docker_image=$(docker inspect --format='{{.Name}}' $docker_repo_xz )
                        docker_run="$(docker inspect --format='{{.State.Status}}' $docker_repo_xz)"
                        if [ "$docker_run" = "running" ]; then
                            docker_run_status="✓ 当前容器正在运行"
                        else
                            docker_run_status="✗ 当前容器未运行"
                        fi
                        docker_image_gl=$($habit --title "容器管理" \
                        --menu "当前镜像名字:$docker_image \n 请选择" 0 0 0\
                        1 "删除镜像" \
                        0 "◀返回" \
                        2>&1 1>/dev/tty)
                        case $docker_image_gl in
                            1)
                                docker image rm $docker_repo_xz
                                esc
                                ;;
                            *)
                                break
                                ;;
                        esac
                    done
                done
                ;;
            6)
                $pkg_remove docker
                ;;
            *)
                break
                ;;
        esac
    done
}

frp_menu() {
    frp_menu_xz=$($habit --clear --title "穿透工具" \
    --menu "请选择:" 0 0 10 \
    1 "cpolar穿透工具" \
    2 "tunnelto穿透工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}



#tunnelto_工具
tunnelto_tool() {
    PATH=$HOME/.cargo/bin:$PATH
    tunnelto_menu() {
        if command -v tunnelto >/dev/null 2>&1; then
            tunnelto_test="tunnelto已安装"
        else
            tunnelto_test="tunnelto未安装"
        fi
        tunnelto_menu_xz=$($habit --clear --title "tunnelto工具" \
        --menu "项目官网: tunnelto.dev \n https://github.com/agrinman/tunnelto \n$tunnelto_test\n 请选择" 0 0 10 \
        1 "安装tunnelto" \
        2 "启动tunnelto" \
        3 "卸载tunnelto" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
    }
    
    while true
    do
        tunnelto_menu
        case $tunnelto_menu_xz in
            1)
                tunnelto_install_menu_xz=$($habit --clear --title "安装tunnelto" \
                --menu "请选择安装方式" 0 0 10 \
                1 "tunnelto官方安装" \
                2 "cargo从源码构建" \
                0 "◀返回" \
                2>&1 1>/dev/tty)
                case $tunnelto_install_menu_xz in
                    1)
                        echo -e "$(info) 正在通过官方链接进行安装"
                        curl -sL https://tunnelto.dev/install.sh | sh
                        esc
                        ;;
                    2)
                        echo -e "$(info) 正在构建 tunnelto 中"
                        test_install cargo
                        cargo install tunnelto
                        echo -e "$(info) $yellow 请自行添加bin环境变量$color"
                        esc
                        ;;
                    *)
                        break
                        ;;
                esac
                ;;
            2)
                tunnelto_key=$($habit --clear --title "key设置" \
                --inputbox "请输入你的 tunnelto 上面的key密钥" 0 0 \
                2>&1 1>/dev/tty)
                tunnelto_port=$($habit --clear --title "port设置" \
                --inputbox "请输入你要映设的端口" 0 0 \
                2>&1 1>/dev/tty)
                echo -e "$(info) 正在启动中"
                tunnelto --port $tunnelto_port --key $tunnelto_key
                esc
                ;;
            3)
                rm $(command -v tunnelto)
                echo -e "$(info) $green 卸载完成$color"
                esc
                ;;
            *)
                break
                ;;
        esac    
    done
}


#转换工具
change_tool_menu() {
    change_tool_menu_xz=$($habit --clear --title "转换工具" \
    --menu "请选择:" 0 0 10 \
    1 "edge-tts文字转语音" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#edge-tts安装函数
edge-tts_install() {
    eval PATH=$PATH:$HOME/.local/bin >/dev/null 2>&1
    if command -v edge-tts >/dev/null 2>&1; then
        echo -e "$(info)$green edge-tts已安装$color"
    else
        echo -e "$(info) $yellow edge-tts未安装$color"
        pipx_install edge-tts
        echo -e "$(info) 请重新运行本脚本"
    fi
}

#voice语音列表
edge_tts_voice_list() {
    test_install dialog
    edge_tts_3=$(eval dialog --clear --title "音色选择" \
                --menu "选择的音色与文字应相对应-请选择音色：" 0 0 0 \
                $(edge-tts --list-voices | awk '
                    /^[a-z]/ {print $1 "\t[" $1 "]"}
                ' | sort -r | sed 's/\t/ /g') \
                2>&1 1>/dev/tty)
                if [ $? -ne 0 ]; then
                    exit 1
                fi
}

#edge-tts文字转语音工具
edge_tts() {
    edge-tts_install
    if [[ -n $@ ]]; then
        edge_tts_3=${3:-zh-CN-XiaoxiaoNeural}
        edge_tts_1=$1
        edge_tts_2=$2
    else
        edge_tts_voice_list
        edge_tts_1=$($habit --clear --title "edge-tts文字转语音工具" \
        --inputbox "请输入要转语音的文字:" 0 0 "点击输入文字" \
        2>&1 1>/dev/tty)
        edge_tts_2=$($habit --clear --title "语音导出" \
        --inputbox "请输入导出的文件名字:" 0 0 "test.mp3" \
        2>&1 1>/dev/tty)
    fi
    echo -e "$(info) 当前音色为:$blue $edge_tts_3 $color"
    echo;echo -e "$(info) 正在生成中。"
    edge-tts --text "$edge_tts_1" --write-media "$edge_tts_2" --voice "$edge_tts_3" >/dev/null 2>&1
    cw_test=$?
    if [ $cw_test -ne 0 ]; then
        echo -e "$(info) $red 错误代码: $cw_test $color"
        echo -e "$(info) $red 文件生成失败，请检查你的网络或输入的文字。$color"
    else
        echo;echo -e "$(info) $green 文件导出成功 $color"
        echo -e "位于: $blue$PWD/$edge_tts_2 $color"
    fi
    
    if [[ -n $@ ]]; then
        exit 0
    fi
}


#nlist工具
nlist_tool() {
    chmod +x $nasyt_dir/* >/dev/null 2>&1
    nlist_version_new=1.1
    if command -v nlist >/dev/null 2>&1; then
        nlist_version=$(grep version $nasyt_dir/nlist | cut -d'=' -f2 )
    fi
    if [[ $nlist_version_new == $nlist_version ]]; then
        echo -e "$(info) 正在运行脚本"
        nlist $1 $2 $3
    else
        echo -e "$(info) 正在下载或更新脚本文件"
        curl --progress-bar -o $nasyt_dir/nlist "https://raw.gitcode.com/nasyt/nlist/raw/main/nlist.sh"
        cw_test=$?
        if ! [ $cw_test -ne 0 ]; then
            echo -e "$(info) $green 脚本下载成功$color"
            echo -e "$(info) 正在给予权限。"
            echo -e "$(info) 输入$blue nlist help$color 查看帮助"
            chmod +x $nasyt_dir/*
        else
            echo -e "$(info) $red 脚本下载失败，请检查你的网络$color"
            esc
        fi
    fi
}

#其他工具
other_tool_menu() {
    other_tool_xz=$($habit --title "其他工具" \
    --menu "请选择" 0 0 10 \
    1 "Alist资源挂载工具" \
    2 "OpenList挂载工具" \
    3 "nweb 高性能web服务"\
    4 "cloudreve云盘系统" \
    5 "nasfq番茄小说下载器" \
    6 "bilibili-TUI版" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
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

#openlist安装
openlist_menu(){
    openlist_menu_xz=$($habit --title "openlist管理" \
    --menu "openlist_termux管理\n提示: 使用前请先设置密码\n推荐: 如果需要后台运行推荐使用tmux工具" 0 0 10 \
    1 "启动openlist服务" \
    2 "设置openlist密码" \
    3 "卸载openlist" \
    4 "更新openlist" \
    0 "◀返回" \
    2>&1 1>/dev/tty)

}

nweb_menu(){
    if command -v nweb >/dev/null 2>&1; then
        nweb_install="nweb已安装"
    else
        nweb_install="nweb未安装"
    fi
    nweb_menu_xz=$($habit --title "nweb安装" \
    --menu "nweb一个由Rust 语言构建的\n轻量级高性能 静态Web 服务\n仓库地址https://gitcode.com/nasyt/nweb \n由作者 NAS油条 制作\n推荐搭配tmux工具使用\n $nweb_install 请选择:" 0 0 10\
    1 "安装nweb" \
    2 "启动nweb" \
    3 "卸载nweb" \
    4 "tmux工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#编辑工具菜单
edit_tool_menu() {
    edit_tool_menu_xz=$($habit --clear --title "编辑工具" \
    --menu "请选择:" 0 0 10 \
    1 "nvim(lazy)编辑工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

# nvim配置菜单
nvim_menu() {
    nvim_menu_xz=$($habit --clear --title "nvim管理" \
    --menu "推荐安装LazyVim整合插件\n请选择:" 0 0 10 \
    Lazy "安装LazyVim整合插件" \
    1 "启动nvim" \
    2 "备份nvim" \
    3 "恢复nvim" \
    3 "卸载nvim" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#下载工具菜单
dow_tool_menu() {
    dow_tool_menu_xz=$($habit --clear --title "下载工具" \
    --menu "请选择:" 0 0 10 \
    1 "nfq番茄小说下载工具" \
    2 "twitter视频下载工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

cloudreve_menu() {
    cloudreve_menu_xz=$($habit --title "cloudreve云盘" \
    --menu "Cloudreve - 部署公私兼备的网盘系统\n 来源 https://cloudreve.org/ \n脚本作者:NAS油条\n本安装方式釆用docker安装\n docker镜像来源于社区" 0 0 10 \
    1 "安装cloudreve" \
    2 "更新cloudreve" \
    3 "运行cloudreve" \
    4 "停止cloudreve" \
    5 "删除cloudreve" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

server_install_menu() {
    server_install_xz=$($habit --title "各种服务端" \
    --menu "请选择" 0 0 10 \
    1 "安装SFS服务端" \
    2 "安装phira服务端" \
    3 "tmux工具" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
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
    7 "MOSS智能终端" \
    8 "终端galgame" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

galgame_menu() {
    galgame_menu_xz=$($habit --clear --title "galgame" \
    --menu "请选择" 0 0 10 \
    1 "原神vs鸣朝" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
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
        case $cpolar_install_xz in
            1) curl --progress-bar -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash ;;
            2) test_install dnsutils;bash -c "$(curl raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/cpolar/aarch64.sh)" ;;
            3) curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash -s -- --remove ;;
            *) break;;
        esac
        esc
    done
}

bt_menu() {
    bt_menu_xz=$($habit --title "bt管理" \
    --menu "请选择" 0 0 5 \
    1 "安装宝塔面板" \
    2 "卸载宝塔面板" \
    3 "管理宝塔面板" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

dpanel_menu() {
    dpanel_menu_xz=$($habit --title "dpanel管理" \
    --menu "请选择" 0 0 10\
    1 "安装dpanel面板" \
    2 "管理dpanel面板" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
    if [ $? -ne 0 ]; then
       break
    fi
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

qinglong_menu() {
    qinglong_menu_xz=$($habit --title "青龙面板安装" \
    --menu "提示: 在bt和1p面板也可以快捷安装\n这里仅提供安装服务\n请选择安装方式" 0 0 5 \
    1 "docker安装" \
    2 "shell安装" \
    0 "◀返回"\
    2>&1 1>/dev/tty)
}

Ajenti_menu() {
    Ajenti_menu_xz=$($habit --title "Ajenti安装" \
    --menu "请选择:" 0 0 10 \
    1 "安装Ajenti" \
    2 "打开配置文件" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
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
astrbot_menu() {
    astrbot_menu_xz=$($habit --title "AstrBot安装与管理" \
    --menu "来自官网: https://astrbot.app\n提示: 雨云/宝塔/1p面板有快捷的安装方式\n请选择" 0 0 10\
    1 "docker安装(官方/方便/推荐)" \
    2 "Kubernetes部署(官方/测试中/不推荐)" \
    3 "python安装(作者/兼容/推荐)" \
    4 "社区提供的脚本(社区/丰富/其他)" \
    5 "python启动Astrbot(推荐和tmux工具一起使用)" \
    6 "常见问题(欢迎提出问题)" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

astrbot_docker_menu() {
    astrbot_docker_menu_xz=$($habit --title "docker安装" \
    --menu "1 2者使用的Docker Compose 部署\n3 使用的Docker 部署请选择" 0 0 5 \
    1 "同时部署NapCat和AstrBot" \
    2 "只部署AstrBot" \
    3 "docker部署AstrBot" \
    4 "查看Astrbot日志" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

napcat_menu() {
    napcat_menu_xz=$($habit --title "napcat安装" \
    --menu "此内容全部来自napcat官网，NAS油条 整合\n此外还可以在1panel,Railway,Railway,Nix上找到\n有问题欢迎反馈\n请选择安装方式" 0 0 10 \
    1 "Linux通用安装" \
    2 "Tui可视化安装" \
    3 "Docker 安装" \
    4 "Docker 重装" \
    5 "TUI-CLI 安装"\
    6 "Termux 安装" \
    7 "自定义参数运行" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

astrbot_community_menu() {
    astrbot_community_xz=$($habit --title "社区提供的脚本" \
    --menu "提示:这些脚本来自github\n官方不保证这些部署方式的安全性和稳定性\n请选择" 0 0 5\
    1 "Linux 一键部署(zhende1113/Antlia)" \
    2 "Linux 一键部署(基于Docker)(railgun19457/AstrbotScript)" \
    3 "Android Astrbot部署(zz6zz666/AstrBot-Android-App)" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

koishi_menu(){
    koishi_menu_xz=$($habit --title "标题" \
    --menu "koishi机器人(koishi.chat)\n请选择" 0 0 5\
    1 "docker安装" \
    2 "AppImage安装" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#MaiBot机器人
MaiBot_menu(){
    MaiBot_menu_xz=$($habit --title "MaiBot管理" \
    --menu "请选择:" 0 0 10\
    1 "手动安装MaiBot" \
    2 "自动化安装MaiBot" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

MaiBot_install() {
    MaiBot_install_xz=$($habit --title "MaiBot安装" \
    --menu "请选择" 0 0 10 \
    3 "社区脚本安装" \
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

#nonobot机器人
nonebot_menu() {
    nonebot_menu_xz=$($habit --title "nonobot管理" \
    --menu "请选择:" 0 0 10 \
    1 "shell安装" \
    2 "docker安装"\
    0 "◀返回" \
    2>&1 1>/dev/tty)
}

# 网络连通测试工具
curl_connect_tool() {
    echo "-------网络连通测试工具-------"
    curl_connect_tool_url=$($habit --title "网络连通测试工具\n⚠️ 注意：仅用于合法网络诊断" \
    --inputbox "请输入测试地址" 0 0 \
    2>&1 1>/dev/tty)
    curl_connect_tool_sl=$($habit --title "curl" \
    --inputbox "请输入测试数量" 0 0 \
    2>&1 1>/dev/tty)
    echo "正在测试中ing..."
    for ((i=0; i<$curl_connect_tool_sl; i++)); do
        echo -e "$(info) 正在访问$i"
        curl -s $curl_connect_tool_url > /dev/null     
    done
    echo -e "$(info) 测试完成"
}


nmap_menu() {
    test_install nmap
    echo "提示: 暂时只有一个功能"; br
    echo "1) 扫描IP开放端口"
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

clear_waste_menu() {
    clear_waste_menu_xz=$($habit --title "垃圾清理" \
    --menu "请选择" 0 0 5 \
    1 "清理日志" \
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
    source $HOME/.bashrc >/dev/null 2>&1 #加载配置文件
    if [[ -n $habit ]]; then
        $habit --yesno "此操作会删除本脚本\n你确定要删除(>_<)本脚本吗？" 0 0
        if [ $? -ne 0 ]; then
            echo ""
        else
            rm $PREFIX/bin/nasyt >/dev/null 2>&1
            rm /usr/bin/nasyt >/dev/null 2>&1
        fi
        $habit --title "确认操作" --yesno "是否删除脚本目录下的所有项目？\n $(br_2) \n$(ls $nasyt_dir/) \n $(br_2)" 0 0
        if [ $? -ne 0 ]; then
            echo ""
        else
            rm -rfv $nasyt_dir
            exit 0
        fi
        $habit --msgbox "操作完成\n感谢你的支持。" 0 0
    else
        rm $nasyt_dir/nasyt >/dev/null 2>&1
        rm usr/bin/nasyt >/dev/null 2>&1
        rm $PREFIX/bin/nasyt >/dev/null 2>&1
        echo -e "$(info) 删除完成"
    fi
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

#更新以及安装
gx() {
    # 下载安装更新
    br
    if command -v nasyt >/dev/null 2>&1; then
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
            echo -e "$(info) 正在后台安装必要文件"
            test_install figlet & >/dev/null 2>&1
            test_eatmydata >/dev/null 2>&1
            echo "$(info) 如果不行请重新连接终端"
            echo -e "$(info) 启动命令为$yellow nasyt$color"
            source $HOME/.bashrc >/dev/null 2>&1
            source $HOME/.zshrc >/dev/null 2>&1
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
    cp $nasyt_dir/nasyt $nasyt_dir/version/nasyt$version.bak >/dev/null 2>&1
    #if [[ -z $PRETTY_NAME ]]; then
    #    cp $PREFIX/bin/nasyt $PREFIX/bin/nasyt$version.bak >/dev/null 2>&1
    #else
    #    cp /usr/bin/nasyt /usr/bin/nasyt$version.bak>/dev/null 2>&1 >/dev/null 2>&1
    #fi
    if [ $? -ne 0 ]; then
        echo -e "$(info) $red 脚本备份失败，跳过备份环节$color"
    else
        echo -e "$(info) $green 脚本备份成功$color"
    fi
}

#脚本恢复功能
shell_recover() {
    echo -e "$(info) 正在恢复脚本文件";sleep 0.5s
    file_xz $nasyt_dir/version shell_recover_var
    cp $shell_recover_var $nasyt_dir/nasyt >/dev/null 2>&1
    chmod 777 $nasyt_dir/*
    if [[ -z $PRETTY_NAME ]]; then
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

nasyt_backup() {
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
}


upsource() {
    read -p "$(info) 确定更换下载源(y/n)" upsource_sz
    if [ $upsource_sz == n ]; then
        exit
    fi
    if command -v termux-change-repo >/dev/null 2>&1; then
        termux-change-repo
    else
        if [ -e $nasyt_dir/mirrors.sh ];then
            chmod 777 $nasyt_dir/*
            bash $nasyt_dir/mirrors.sh
        else
            echo -e "$(info) 正在下载脚本文件。"
            curl -sSLo $nasyt_dir/mirrors.sh https://linuxmirrors.cn/main.sh >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "$(info) $red 下载文件失败。$color"
            else
                echo -e "$(info) $green 下载文件成功。$color"
                bash $nasyt_dir/mirrors.sh
            fi
        fi
    fi
    esc
}

#tmux工具
tmux_tool() {
    # 获取所有tmux会话
    tmux_get() {
        tmux_ls=$(mktemp) #tmux临时文件
        tmux list-sessions -F "#S" 2>/dev/null > "$tmux_ls" #输出到临时文件
    }
    # tmux菜单
    tmux_menu() {
        tmux_menu_xz=$($habit --clear \
        --title "tmux工具" \
        --menu "请选择" 0 0 10 \
        1 "🆕 新建会话" \
        2 "🔧 会话管理" \
        3 "❓ 使用说明" \
        4 "🌌 美化窗口" \
        0 "◀退出" \
        2>&1 1>/dev/tty)
    }
    
    while true
    do
        test_install tmux
        tmux_menu
        case $tmux_menu_xz in
            1) 
                tmux_new=$($habit --clear --title "🆕新建窗口🆕" \
                --inputbox "请输入窗口名字:" 0 0 \
                2>&1 1>/dev/tty)
                if [ $? -ne 0 ]; then
                    echo
                else
                    tmux new-session -d -s "$tmux_new"
                    $habit --title "确认操作" --yesno "创建 $tmux_new 窗口成功\n\n是否连接会话" 0 0
                    if [ $? -ne 0 ]; then
                        echo
                    else
                        tmux attach-session -t $tmux_new
                    fi
                fi
                ;;
            2)
                while true
                do
                    tmux_get #获取会话列表
                    # 检查tmux会话
                    if [ ! -s "$tmux_ls" ]; then
                        $habit --title "警告" --msgbox "没有找到可用会话\n请先创建会话!" 10 30
                        
                    fi
                    
                    tmux_list=()
                    tmux_number=1
                    while IFS= read -r session; do
                        tmux_list+=("$tmux_number" "$session")
                        ((tmux_number++))
                    done < "$tmux_ls"
                    
                    tmux_list_xz=$($habit --clear \
                    --title "窗口管理" \
                    --menu "请选择一个会话:" 0 0 10 \
                    "${tmux_list[@]}" \
                    0 "◀返回" \
                    2>&1 1>/dev/tty)
                    cw_test=$?
                    if [[ $tmux_list_xz -eq 0 ]]; then
                        return 0
                    elif [[ $cw_test -eq 1 ]]; then
                        return 0
                    fi
                    tmux_name=$(echo "${menu_items[@]}" | awk -v idx="$tmux_list_xz" '{for(i=1;i<=NF;i+=2) if ($i == idx) print $(i+1)}')
                    tmux_session_menu=$($habit --title "管理" \
                    --menu "请选择" 0 0 10 \
                    1 "🔗 连接到会话" \
                    2 "🔴 结束此会话" \
                    3 "📝 重命名会话" \
                    0 "◀返回" \
                    2>&1 1>/dev/tty)
                    case $tmux_session_menu in
                        1)
                            if [[ -n "$TMUX" ]]; then
                                tmux switch-client -t "$tmux_name"
                            else
                                tmux attach -t "$tmux_name"
                            fi
                            esc
                            ;;
                        2)
                            tmux kill-session -t "$session"
                            $habit --msgbox "✅ 已结束会话" 0 0
                            ;;
                        3)
                            tmux_new_name=$($habit --title "重命名" \
                                --inputbox "为会话 '$tmux_name' 输入新名称:" \
                                0 0 "$tmux_name" \
                                3>&1 1>&2 2>&3)
                            if [[ $? -eq 0 ]] && [[ -n "$new_name" ]]; then
                                if tmux rename-session -t "$tmux_name" "$tmux_new_name"; then
                                    $habit --msgbox "✅ 会话已重命名为 '$tmux_new_name'" 0 0
                                fi
                            fi
                            ;;
                        *)
                            break
                            ;;
                    esac
                    rm -f "$tmux_ls"
                done
                ;;
            3)
                $habit --msgbox '介绍:\n  本工具由 NAS油条 制作\n\n常用快捷键:\n• Ctrl+b %   垂直分割窗格\n• Ctrl+b \"   水平分割窗格\n• Ctrl+b 方向键  切换窗格\n• Ctrl+b c   新建窗口\n• Ctrl+b n/p 切换窗口\n• Ctrl+b d   分离会话 ' 0 0
                ;;
            4)
                cd $HOME
                echo -e "$(info) $blue 正在克隆oh my tmux项目 $color"
                if [[ -d $HOME/.tmux ]]; then
                    echo -e "$(info) $yellow 仓库已克隆，正在进入安装步骤。 $color"
                else
                    git clone --single-branch https://gitcode.com/gh_mirrors/tm/.tmux.git
                    cw_test=$?
                    echo $cw_test
                    if [ $cw_test -eq 128 ]; then
                        echo -e "$(info) $yellow 仓库克隆失败 $color"
                    elif [ $cw_test -ne 0 ]; then
                        echo -e "$(info) $red 仓库克隆失败，请检查你的网络后重试。$color"
                        esc
                        break
                    else
                        echo -e "$(info) $green 仓库克隆成功$color"
                    fi
                fi
                ln -s -f .tmux/.tmux.conf
                echo -e "$(info)  正在覆盖配置文件"
                cp .tmux/.tmux.conf.local .
                echo -e "$(info) $green tmux美化安装完成$color"
                esc
                ;;
            *)
                break
                ;;
        esac
    done
}

# 下载视频（curl自带进度）
download_video() {
    local video_url="$1"
    local output_name="$2"
    local download_path="${PWD}/${output_name}"

    echo "正在下载：$video_url"
    echo "保存到：$download_path"

    curl --progress-bar -L "$video_url" -o "$download_path"

    if [ -f "$download_path" ]; then
        $habit --msgbox "视频下载完成\n$download_path" 0 0
    else
        $habit --msgbox "视频下载失败" 0 0
        exit 1
    fi
}
# 解析 Twitter/X 视频
dow_x_mp4() {
    local twitter_url="$1"
    local api_url="https://twitsave.com/info?url=${twitter_url}"
    local ts=$(date +%s)
    local outfile="${ts}.mp4"
    
    echo "🔍 正在解析视频：$twitter_url"
    echo "🔗 请求解析页：$api_url"
    
    local video_url=$(
        curl -sL "$api_url" \
        | grep -o 'https://video[^"]*' \
        | head -1
    )

    if [ -z "$video_url" ]; then
        $habit --msgbox "❌ 无法获取视频链接（可能被墙/链接无效/页面改了）" 0 0
        exit 1
    fi

    echo "✅ 获取到下载地址：$video_url"
    download_video "$video_url" "$outfile"
}


# 显示服务器配置信息
show_server_config() {
    clear
    echo "=== 服务器配置信息 ==="
    echo "CPU核心数:"
    lscpu | grep -w "CPU(s):" | grep -v "\-"
    lscpu | grep -w "Model name:"
    br
    echo "CPU频率:"
    lscpu | grep -w "CPU MHz"
    br
    echo "虚拟化类型:"
    lscpu | grep -w "Hypervisor vendor:"
    br
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
    br
    echo "内存信息:"
    free -h
    br
    echo "硬盘信息:"
    df -hl
    br
    esc
}

# neofetch工具
ifneofetch() {
    while true
    do
        neofetch_menu_xz=$($habit --title "显示方式" \
        --menu "请选择" 0 0 5\
        1 "neofetch" \
        2 "fastfetch" \
        0 "◀返回" \
        2>&1 1>/dev/tty)
        
        case $neofetch_menu_xz in
            1)
                test_install neofetch
                neofetch
                esc
                ;;
            2)
                test_install fastfetch
                $habit --msgbox "系统软件包可能没有fastfetch" 0 0
                fastfetch
                esc
                ;;
            *)
                break
                ;;
        esac
    done
}

# 一键修改密码
change_password() {
    username=$(whoami)
    $sudo_setup passwd "$username"
    echo "$(info) 密码已成功修改。"
}


acg() {
    test_install wget
    test_install jq
    test_install chafa
    clear
    while true
    do
        shell_2=$@
        if [[ -n $shell_2 ]]; then
            echo
            acg_menu_sz=$shell_2
        else
            if [[ -z $PRETTY_NAME ]]; then
                acg_menu_xz_add="10 "选择并设为壁纸""
            fi
            acg_menu_xz=$($habit --title "🤓🤓随机acg🤓🤓" \
            --menu "推荐将终端拉到最小状态\n以获得最佳体验，按确定键获取图片" 0 0 5\
            1 "📱随机acg(竖屏)" \
            2 "🖥随机acg(横屏)" \
            3 "🔞随机pixiv图片" \
            6 "✎自定义图片链接" \
            7 "⚙️自定义关键词" \
            8 "📦图片空间占用" \
            9 "🕒查看历史图片" \
            $acg_menu_xz_add \
            0 "◀返回" \
            2>&1 1>/dev/tty)
            clear
            case $acg_menu_xz in
                1)
                    tp_curl=https://www.loliapi.com/acg/pe
                    acg_menu_sz=pe
                    ;;
                2)
                    tp_curl=https://www.loliapi.com/acg/pc
                    acg_menu_sz=pc
                    ;;
                3)
                    $habit --title "随机pixiv" --yesno "是否搜索R18图片🤓？" 0 0
                    if [ $? -ne 0 ]; then
                        api_r18=0
                        tp_r18=
                    else
                        api_r18=1
                        tp_r18=R18
                    fi
                    echo -e "$(info) 正在请求i.pixiv.re"
                    setu_api=$(curl https://api.lolicon.app/setu/v2?r18=$api_r18)
                    if [ $? -ne 0 ]; then
                        echo -e "$(info) $red api请求失败$color"
                        esc
                    else
                        echo -e "$(info) $green api请求成功$color"
                        tp_curl=$(echo $setu_api | grep -o '"original":"[^"]*"' | head -1 | cut -d'"' -f4)
                        tp_pid=$(echo $setu_api | grep -o '"pid":[[:space:]]*[0-9]*' | cut -d: -f2 | tr -d ' ,')
                        tp_size=$(echo $setu_api | jq -r '.data[0] | "\(.width)x\(.height)"')
                        tp_tag=$(echo $setu_api | jq -r '.data[0].tags | join(",")')
                        clear;br
                        echo -e "$blue链接: $color$tp_curl"
                        echo -e "${blue}PID: $color$tp_pid"
                        echo -e "$blue大小: $color$tp_size"
                        echo -e "$blue标签: $color$tp_tag"
                        br
                    fi
                    #echo $setu_api | grep -o '"pid":[0-9]*\|"title":"[^"]*"\|"original":"[^"]*"\|"ext":"[^"]*"\|"author":"[^"]*"'
                    ;;
                6)
                    tp_curl=$($habit --title "自定义图片链接" \
                    --inputbox "请输入链接" 0 0 \
                    2>&1 1>/dev/tty)
                    if [ $? -ne 0 ]; then
                        continue
                    fi
                    ;;
                7)
                    api_tag=$($habit --title "自定义关键词" \
                    --inputbox "请输入关键词，可用|符合隔开" 0 0 \
                    2>&1 1>/dev/tty)
                    api_r18_xz=$($habit --title "是否查找R18内容" \
                    --yesno "是否查找R18内容?" 0 0 \
                    2>&1 1>/dev/tty)
                    if [ $? -ne 0 ]; then
                        $habit --msgbox "不好意思R18占多数,只能随机看看了." 0 0
                        api_r18=0
                        api_r18=
                    else
                        api_r18=1
                        api_r18=_R18
                    fi
                    echo -e "$(info) 正在请求i.pixiv.re"
                    setu_api=$(curl -sSL -G "https://api.lolicon.app/setu/v2?r18=$api_r18" --data-urlencode "tag=$api_tag")
                    if [ $? -ne 0 ]; then
                        echo -e "$(info) $red api请求失败$color"
                    else
                        echo -e "$(info) $green api请求成功$color"
                    fi
                    #echo $setu_api | grep -o '"pid":[0-9]*\|"title":"[^"]*"\|"original":"[^"]*"\|"ext":"[^"]*"\|"author":"[^"]*"'
                    
                    ;;
                8)
                    test_install ncdu
                    ncdu $nasyt_dir/acg
                    esc
                    continue
                    ;;
                9)
                    file_xz $nasyt_dir/acg acg_view
                    chafa $acg_view
                    esc
                    continue
                    ;;
                10)
                    $habit --msgbox "请在接下来的现在中选择一张图片" 0 0
                    file_xz $nasyt_dir/acg acg_view2
                    termux-wallpaper -f $acg_view2
                    if [ $? -ne 0 ]; then
                        $habit --msgbox "设置壁纸失败" 0 0
                    else
                        $habit --msgbox "壁纸设置成功\n去桌面看看吧。" 0 0
                    fi
                    esc
                    continue
                    ;;
                *)
                    break
                    ;;
            esac
        fi
            time_name_xz=()
            local tp_time=$(date +%Y%m%d_%H%M%S)
            local random=$(shuf -i 1000-9999 -n 1)
            if [[ -v $tp_pid ]]; then
                local tp_pid_2=$(echo "_$acg_menu_sz")
            else
                local tp_pid_2=$(echo "_$tp_pid")
            fi
            local api_r18_2=$(echo "_$tp_r18")
            time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
        echo -e "$(info) 正在获取图片中,请耐心等待"
        if [[ -z $PRETTY_NAME ]]; then
            termux-toast "请将termux终端缩至最小,以获得最佳体验。"
        fi
        wget -O $nasyt_dir/acg/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            find $nasyt_dir/acg -type f -size 0 -regex '.*\.\(jpg\|png\)$' -delete #清理图片
            $habit --yesno "获取$shell_2图片失败\n请检查你的网络或者关键词" 0 0
            if [ $? -ne 0 ]; then
                break
            fi
        else
            chafa $nasyt_dir/acg/$time_name_xz.png
            echo -e "$(info) 图片已保存在$nasyt_dir/acg/$time_name_xz.png"
            
            if [[ -n $@ ]]; then
                exit 0
            fi
            esc
        fi
    done
}
# 同步上海时间函数
sync_shanghai_time() {
    if [[ -z $PRETTY_NAME ]]; then
        test_termux
    else
        test_install ntpdate
        if [ $? -ne 0 ]; then
            echo -e "$(info) $yellow ntpdate安装失败，正在尝试候选$color"
            test_install ntpsec-ntpdate
        fi
        echo "$(info) 正在同步上海时间..."
        $sudo_setup timedatectl set-timezone Asia/Shanghai
        $sudo_setup ntpdate cn.pool.ntp.org
        echo -e "$(info) $green 同步完成$color";esc
    fi
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
    #default_habit #检查函数并设置默认值
    #check_pkg_install # 检查包管理器。
    check_script_folder # 检查脚本文件夹。
    test_eatmydata # 检查eatmydata是否安装。
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
        ad_gg #支持
        habit_xz #选择使用习惯。
        br
        source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置以防免责声明无法加载
        disclaimer # 免责声明
        read -p "回车键启动脚本,Ctrl+C退出" 
    fi
    source $nasyt_dir/config.txt >/dev/null # 何咦魏,加载脚本配置
    source $HOME/.bashrc >/dev/null 2>&1 # 加载用户启动文件
    clear
    while true
    do
        clear
        show_menu  # 主菜单
        case $index_menu_xz in
            1)
                # 查看功能
                while true
                do
                    clear
                    look_menu
                    case $look_choice in
                        1) $habit --msgbox "$(date +"%r")" 0 0;;
                        2) show_server_config;;
                        3) $habit --msgbox "$(curl iplark.com)" 0 0 ;;
                        4) ifneofetch ;;
                        5) $habit --msgbox "$(curl -sSL https://slow-api.hoha.top/ip.php)" 0 0;;
                        6) test_install htop;htop ;;
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
                    system_menu
                    case $system_choice in
                        1)
                            while true
                            do
                                deb_install
                                case $deb_install_xz in
                                    1)
                                        deb_install_Internet
                                        esc
                                        ;;
                                    2)
                                        deb_install_localhost
                                        esc
                                        ;;
                                    3)
                                        deb_remove
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        2)
                            upsource
                            esc
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
                                        file_xz . zip_zip
                                        unzip -o $zip_zip; br
                                        if [ $? -ne 0 ]; then
                                            echo -e "$(info) $red 文件解压失败$color"
                                        else
                                            echo -e "$(info) $green 文件解压成功$color"
                                        fi
                                        esc
                                        ;;
                                    2)
                                        clear; br; ls; br
                                        file_xz . tar_gz_xz
                                        tar -xzvf $tar_gz_xz; br
                                        if [ $? -ne 0 ]; then
                                            echo -e "$(info) $red 文件解压失败$color"
                                        else
                                            echo -e "$(info) $green 文件解压成功$color"
                                        fi
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
                           $pkg_install openjdk-$java_install_xz-jre-headless $yes_tg
                           ;;
                        7)
                            language_menu () {
                            clear; br
                            test_termux
                            $habit --msgbox "当前只适配了基于 CentOS/Debian的系统\n其他系统的可以尝试一下。" 0 0
                            case $deb_sys in
                               apt)
                                  echo -e "$(info) 正在使用 $deb_sys 下载中文汉化包。"
                                  sudo apt install task-chinese-s task-chinese-t
                                  if [ $? -ne 0 ]; then
                                    echo -e "$(info) $red 汉化包下载失败$color"
                                  else
                                    echo -e "$(info) $green 汉化包下载成功$color"
                                  fi;sleep 1s
                                  $habit --msgbox "请在接下来的页面内 勾选zh_CN.UTF-8选项 然后回车" 0 0
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
                            if [[ -z $PRETTY_NAME ]]; then
                                $habit --msgbox "不支持termux设置" 0 0
                            else
                                test_install wget #检查wget函数
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
                            if [[ -z $PRETTY_NAME ]]; then
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
                                        sudo bash -c "$(curl -L https://gitcode.com/nasyt/nasyt-linux-tool/raw/master/swap-install.sh)"
                                        esc
                                        ;;
                                     2) 
                                        sudo bash -c "$(curl -L https://gitcode.com/nasyt/nasyt-linux-tool/raw/master/swap-uninstall.sh)"
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
                            if [[ -z $PRETTY_NAME ]]; then
                                echo -e "$(info) 检测到termux终端正在清理日志文件"
                                find $PREFIX/var/log/ -type f -mtime +30 -exec rm -f {} >/dev/null 2>&1
                            else
                                while true
                                do
                                    clear_waste_menu
                                    case $clear_waste_menu_xz in
                                        1)
                                            if command -v journalctl >/dev/null 2>&1; then
                                                clear_waste_day=$($habit --title "自定义天数清理" \
                                                --inputbox "请输入要清理多久以前的日志(单位/d天)" 0 0 "7d"\
                                                2>&1 1>/dev/tty)
                                                sudo journalctl --vacuum-time=$clear_waste_day
                                                if [ $? -ne 0 ]; then
                                                    $habit --msgbox "格式错误" 0 0
                                                fi
                                            else
                                                find /var/log/ -type f -mtime +30 -exec rm -f {}
                                            fi
                                            ;;
                                        0)
                                            break
                                            ;;
                                        *)
                                            break
                                            ;;
                                    esac
                                done
                            fi
                            esc
                            ;;
                        11)
                            echo -e "$(info) 正在检查pip是否安装"
                            test_install pip #检查pip安装
                            echo -e "$(info) 正在切换清华pip下载源"
                            sleep 1
                            pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
                            pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn
                            if [ $? -ne 0 ]; then
                                echo -e "$(info) $red 换源失败$color"
                            else
                                echo -e "$(info) $green 换源成功$color"
                            fi
                            esc
                            ;;
                        12)
                            sync_shanghai_time #同步上海时间
                            esc
                            ;;
                        13)
                            change_password #设置密码
                            esc
                            ;;
                        14)
                            host_name_xz=$($habit --title "主机名" \
                            --inputbox "请输入新的主机名。" 0 0 \
                            2>&1 1>/dev/tty)
                            if [ $? -ne 0 ]; then
                                break
                            fi
                            $sudo_setup hostnamectl set-hostname $host_name_xz
                            $habit --msgbox "修改成功，重新连接终端生效。" 0 0
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
                            curl_connect_tool
                            esc
                            ;;
                        3)
                            # tmux工具
                            tmux_tool
                            esc
                            ;;
                        4)
                            awk -f <(curl -L gitee.com/mo2/linux/raw/2/2.awk)
                            esc
                            ;;
                        114514)
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
                        9)
                            test_install glow
                            glow
                            esc
                            ;;
                        10)
                            echo -e "$(info) $blue 正在拉取脚本$color"
                            bash -c "$(curl -L https://www.mxzc.top/tool/mailtest.sh)"
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
                            docker_menu
                            esc
                            ;;
                        2)
                            while true
                            do
                            panel_menu
                            case $panel_menu_xz in
                                1)
                                    while true
                                    do
                                        bt_menu
                                        case $bt_menu_xz in
                                            1)
                                                if [ -f /usr/bin/curl ];then
                                                    curl -sSO https://download.bt.cn/install/install_panel.sh
                                                else
                                                    wget -O $nasyt_dir/install_1panel.sh https://download.bt.cn/install/install_panel.sh
                                                fi
                                                sudo bash $nasyt_dir/install_1panel.sh ed8484bec
                                                read -p "$(info) 安装bt完成 回车键返回。"
                                                ;;
                                            2)
                                                bash -c "$(curl -L http://download.bt.cn/install/bt-uninstall.sh)"
                                                esc
                                                ;;
                                            3)
                                                if command -v bt >/dev/null 2>&1; then
                                                    bt
                                                    esc
                                                else
                                                    $habit --msgbox "请先安装宝塔面板。" 0 0
                                                fi
                                                ;;
                                            0)
                                                break
                                                ;;
                                        esac
                                    done
                                    ;;
                                2)
                                    #AMH面板
                                    curl --progress-bar -O $nasyt_dir/amh.sh "http://dl.amh.sh/amh.sh"
                                    sudo bash $nasyt_dir/amh.sh acc 48677
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
                                7)
                                    while true
                                    do
                                        dpanel_menu
                                        case $dpanel_menu_xz in
                                            1)
                                                sudo sh -c "curl -sSL https://dpanel.cc/quick.sh -o quick.shbash quick.sh"
                                                esc
                                                ;;
                                            2)
                                                dpanel
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
                                8)
                                    while true
                                    do
                                        qinglong_menu
                                        case $qinglong_menu_xz in
                                            1)
                                                # curl -sSL get.docker.com | sh
                                                test_docker #检查docker安装
                                                qinglong_menu_port=$($habit --title "docker安装" \
                                                --inputbox "请输入面板端口" 0 0 \
                                                2>&1 1>/dev/tty)
                                                qinglong_menu_dir=$($habit --title "路径选择" \
                                                --inputbox "请输入要安装的路径(如果不知道选什么，请输入/)" 0 0 \
                                                2>&1 1>/dev/tty)
                                                    docker run -dit \
                                                      -v $PWD/ql/data:/ql/data \
                                                      # 冒号后面的 5700 为默认端口，如果设置了 QlPort, 需要跟 QlPort 保持一致
                                                      -p $qinglong_menu_port:5700 \
                                                      # 部署路径非必须，比如 /test
                                                      -e QlBaseUrl="$qinglong_menu_dir" \
                                                      # 部署端口非必须，当使用 host 模式时，可以设置服务启动后的端口，默认 5700
                                                      -e QlPort="5700" \
                                                      --name qinglong \
                                                      --hostname qinglong \
                                                      --restart unless-stopped \
                                                      whyour/qinglong:latest
                                                ;;
                                            2)
                                                $habit --title "提示" --msgbox "目前只支持Debian系列和CentOS系列\n建议使用纯净系统安装，避免系统原有数据丢失\n需要自己安装 node/npm/python3/pip3" 0 0
                                                echo -e "$(info) 正在拉取脚本数据"
                                                case $deb_sys in
                                                    apt)
                                                        curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                                                        esc
                                                        ;;
                                                    dnf)
                                                        curl --silent --location https://rpm.nodesource.com/setup_20.x | sudo bash
                                                        esc
                                                        ;;
                                                    *)
                                                        $habit --msgbox "不支持的系统" 0 0
                                                        ;;
                                                esac
                                                ;;
                                            *)
                                                break
                                                ;;
                                        esac
                                    done
                                    ;;
                                9)
                                    while true
                                    do
                                        Ajenti_menu
                                        case $Ajenti_menu_xz in
                                            1)
                                                curl -O $nasyt_dir/Ajenti.sh https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh
                                                $sudo_setup bash $nasyt_dir/Ajenti.sh
                                                esc
                                                ;;
                                            2)
                                                test_install nano
                                                nano /etc/ajenti/config.yml
                                                esc
                                                ;;
                                            *)
                                                break
                                                ;;
                                        esac
                                    done
                                    ;;
                                10)
                                    while true
                                    do
                                        Cockpit_menu
                                        case $Cockpit_menu_xz in
                                            1)
                                                source /etc/os-release
                                                echo -e "$(info) 正在更新软件包列表"
                                                pkg_update
                                                case $deb_sys in
                                                    apt)
                                                        $sudo_setup apt install -t ${VERSION_CODENAME}-backports cockpit
                                                        cw_test=$?
                                                        ;;
                                                    dnf)
                                                        test_install cockpit
                                                        cw_test=$?
                                                        ;;
                                                    yum)
                                                        test_install cockpit
                                                        cw_test=$?
                                                        ;;
                                                    pacman)
                                                        test_install cockpit
                                                        cw_test=$?
                                                        ;;
                                                    zypper)
                                                        test_install cockpit
                                                        cw_test=$?
                                                        ;;
                                                    *)
                                                        $habit --msgbox "不支持当前系统" 0 0
                                                        ;;
                                                esac
                                                ;;
                                            2)
                                                $sudo_setup systemctl enable --now cockpit.socket
                                                esc
                                                ;;
                                            *)
                                                break
                                                ;;
                                        esac
                                    done
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
                                bot_install_menu
                                case $bot_install_xz in
                                    1)
                                        test_termux
                                        while true
                                        do
                                            test_termux
                                            Secluded_menu
                                            case $Secluded_menu_xz in
                                            1)
                                                test_install git #检查git是否安装函数
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
                                                    echo "chmod 777 "$nasyt_dir/Secluded/*"" > $nasyt_dir/sec
                                                    echo "cd $nasyt_dir/Secluded && bash SecludedLauncher.out.sh" >> $nasyt_dir/sec
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
                                            test_install wget curl
                                            astrbot_menu
                                            case $astrbot_menu_xz in
                                                1)
                                                    #bash <(curl -sSL https://gitee.com/mc_cloud/mccloud_bot/raw/master/mccloud_install.sh)
                                                    if command -v docker >/dev/null 2>&1; then
                                                        echo -e "$(info) $green docker已安装$color"
                                                    else
                                                        $habit --msgbox "请先安装docker" 0 0
                                                    fi
                                                    astrbot_docker_menu
                                                    case $astrbot_docker_menu_xz in
                                                        1)
                                                            mkdir astrbot;cd astrbot
                                                            wget https://raw.githubusercontent.com/NapNeko/NapCat-Docker/main/compose/astrbot.yml
                                                            sudo docker compose -f astrbot.yml up -d
                                                            esc
                                                            ;;
                                                        2)
                                                            git clone https://github.com/AstrBotDevs/AstrBot
                                                            cd AstrBot
                                                            echo -e "$(info) $正在安装astrbot$color"
                                                            sudo docker compose up -d
                                                            esc
                                                            ;;
                                                        3)
                                                            mkdir astrbot;cd astrbot
                                                            echo -e "$(info) $正在安装中$color"
                                                            sudo docker run -itd -p 6180-6200:6180-6200 -p 11451:11451 -v $PWD/data:/AstrBot/data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro --name astrbot soulter/astrbot:latest
                                                            esc
                                                            ;;
                                                        4)
                                                            sudo docker logs -f astrbot
                                                            esc
                                                            ;;
                                                        0)
                                                            break
                                                            ;;
                                                        *)
                                                            break
                                                            ;;
                                                    esac
                                                    ;;
                                                2)
                                                    test_install kubectl
                                                    kubectl apply -f k8s/astrbot_with_napcat/00-namespace.yaml
                                                    kubectl apply -f k8s/astrbot_with_napcat/01-pvc.yaml
                                                    kubectl apply -f k8s/astrbot_with_napcat/02-deployment.yaml
                                                    kubectl apply -f k8s/astrbot_with_napcat/03-service-nodeport.yaml
                                                    esc
                                                    ;;
                                                4)
                                                    #wget -O - https://gitee.com/mc_cloud/mccloud_bot/raw/master/mccloud_install_u.sh | bash
                                                    while true
                                                    do
                                                        astrbot_community_menu
                                                        case $astrbot_community_xz in
                                                            1)
                                                                bash <(curl -sSL https://raw.githubusercontent.com/zhende1113/Antlia/refs/heads/main/Script/AstrBot/Antlia.sh)
                                                                esc
                                                                ;;
                                                            2)
                                                                echo -e "$(info) 正在下载脚本文件"
                                                                curl -sSL https://raw.githubusercontent.com/railgun19457/AstrbotScript/main/AstrbotScript.sh -o $nasyt_dir/AstrbotScript.sh >/dev/null 2>&1
                                                                if [ $? -ne 0 ]; then
                                                                    echo -e "$(info) $red 脚本下载失败,请检查你的网络$color"
                                                                else
                                                                    echo -e "$green 脚本下载成功，正在启动 $color"
                                                                fi
                                                                chmod +x $nasyt_dir/AstrbotScript.sh
                                                                $sudo_setup bash $nasyt_dir/AstrbotScript.sh
                                                                esc
                                                                ;;
                                                            3)
                                                                $habit --msgbox "此安装方式为软件安装\n请前往https://github.com/zz6zz666/AstrBot-Android-App\n下载软件" 0 0
                                                                ;;
                                                            0)
                                                                break
                                                                ;;
                                                            *)
                                                                break
                                                                ;;
                                                        esac
                                                        esc
                                                    done
                                                    ;;
                                                3)
                                                    if [ -d $nasyt_dir/AstrBot]; then
                                                        $habit --title "确认操作" --yesno "检查到AstrBot已安装$nasyt_dir/AstrBot目录\n 选择 yes启动 no重新安装\n请选择：" 0 0
                                                        if [ $? -ne 0 ]; then
                                                            echo -e "$(info) 正在重新安装"
                                                        else
                                                            cd $nasyt_dir/AstrBot
                                                            source venv/bin/activate
                                                            clear;br
                                                            echo -e "$(info) 正在使用python启动Astrbot"
                                                            python3 main.py
                                                            esc
                                                            break
                                                        fi
                                                    fi
                                                    
                                                    test_termux #termux检查
                                                    #if [ -d $nasyt_dir/AstrBot]; then
                                                    #    rm -rf $nasyt_dir/AstrBot
                                                    #fi
                                                    test_install git #git安装检测
                                                    clear;echo -e "$(info) 正在克隆github仓库。"
                                                    country #国家检测
                                                    git clone $github_speed/https://github.com/AstrBotDevs/AstrBot $nasyt_dir/AstrBot
                                                    cd $nasyt_dir/AstrBot
                                                    echo -e "$(info) 正在检查python安装"
                                                    test_install python3
                                                    echo -e "$(info) 正在检查并添加python环境"
                                                    $sudo_setup $pkg_install python3*venv $yes_tg
                                                    python3 -m venv ./venv
                                                    echo -e "$(info) 正在加载Astrbot环境"
                                                    source $nasyt_dir/AstrBot/venv/bin/activate
                                                    echo -e "$(info) 正在检查并更新pip"
                                                    test_install pip
                                                    pip install --upgrade pip
                                                    echo -e "$(info) 正在安装Astrbot提供的依赖。"
                                                    pip install -r requirements.txt -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
                                                    if [ $? -ne 0 ]; then
                                                        echo -e "$(info) $red 检测到依赖安装失败或者依赖不完整$color"
                                                        echo -e "$(info) 正在安装预备依赖"
                                                        pip_install deprecated sqlalchemy sqlmodel colorlog aiohttp certifi Pillow psutil aiosqlite jsonschema mcp anthropic google-genai openai aiocqhttp numpy
                                                        if [ $? -ne 0 ]; then
                                                            echo -e "$(info) $red 安装失败，正在补全构建文件$color"
                                                            test_install build-essential clang cmake ninja
                                                            echo -e "$(info) 正在尝试重新安装"
                                                            pip install deprecated sqlalchemy sqlmodel colorlog aiohttp certifi Pillow psutil aiosqlite jsonschema mcp anthropic google-genai openai aiocqhttp numpy
                                                            if [ $? -ne 0 ]; then
                                                                echo -e "$(info) $red 安装失败$color"
                                                                exit 1
                                                            fi
                                                        fi
                                                    else
                                                        echo -e "$(info) $green 依赖安装成功$color"
                                                    fi
                                                    br;echo -e "$(info) 正在启动Astrbot"
                                                    python main.py
                                                    esc
                                                    ;;
                                                5)
                                                    if [[ -d $nasyt_dir/AstrBot ]]; then
                                                        cd $nasyt_dir/AstrBot
                                                        source venv/bin/activate
                                                        clear;br;echo "正在启动astrbot"
                                                        python3 main.py
                                                    else
                                                        $habit --msgbox "请先安装Astrbot" 0 0
                                                    fi
                                                    esc
                                                    ;;
                                                6)
                                                    $habit --msgbox "制作中，有什么问题进群反馈:610699712" 0 0
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
                                            napcat_menu
                                            case $napcat_menu_xz in
                                                1)
                                                    napcat_parameter=""
                                                    ;;
                                                2)
                                                    napcat_parameter="--tui"
                                                    ;;
                                                3)
                                                    napcat_docker_qq=$($habit --title "docker安装" \
                                                    --inputbox "请输入QQ号：" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    if [ $? -ne 0 ]; then
                                                        break
                                                    fi
                                                    napcat_parameter="--docker y --qq "$napcat_docker_qq" --mode ws --proxy 1 --confirm"
                                                    ;;
                                                4)
                                                    napcat_parameter="--docker n --cli n --proxy 0 --force"
                                                    ;;
                                                5)
                                                    napcat_parameter="--docker n --cli y"
                                                    ;;
                                                6)
                                                    curl -o $nasyt_dir/napcat.termux.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.termux.sh
                                                    bash $nasyt_dir/napcat.termux.sh
                                                    ;;
                                                7)
                                                    napcat_parameter=$($habit --title "自定义参数运行" \
                                                    --inputbox "  --tui 使用tui可视化交互安装 \n --docker [y/n]: 使用 Docker 进行安装 \n (y) 或使用 Shell 直接安装 (n) \n --cli [y/n]: 是否安装 NapCat TUI-CLI (命令行UI工具) \n --proxy [0-6]: 指定下载时使用的代理服务器序号, \n Docker 安装可选 0-7, shell 安装可选 0-5 \n --force 传入则执行 shell 强制重装 \n请输入:" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    if [ $? -ne 0 ]; then
                                                        break
                                                    fi
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                            if [[ $napcat_parameter -eq 6 ]]; then
                                                break
                                            else
                                                curl -o $nasyt_dir/napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh
                                                $sudo_setup bash $nasyt_dir/napcat.sh $napcat_parameter
                                            fi
                                            esc
                                        done
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
                                                test_install wget
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
                                    7)
                                        test_termux
                                        while true
                                        do
                                            koishi_menu
                                            case $koishi_menu_xz in
                                                1)
                                                    test_install docker
                                                    docker run -p 5140:5140 koishijs/koishi:latest-lite
                                                    esc
                                                    ;;
                                                2)
                                                    $habit --msgbox "开发中" 0 0
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    8)
                                        while true
                                        do
                                            MaiBot_menu
                                            case $MaiBot_menu_xz in
                                                1)
                                                    while true
                                                    do
                                                        MaiBot_install
                                                        case $MaiBot_install_xz in
                                                            1)
                                                                if [ -e $nasyt_dir/MaiBot/venv/bin/activate ]; then
                                                                    mkdir $nasyt_dir/MaiBot
                                                                    cd $nasyt_dir/MaiBot
                                                                    echo -e "$(info) 正在克隆仓库"
                                                                    git clone https://github.com/MaiM-with-u/MaiBot.git $nasyt_dir/MaiBot
                                                                    git clone https://github.com/MaiM-with-u/MaiBot-Napcat-Adapter.git $nasyt_dir
                                                                    test_install python3-dev python3.12 python3.12-venv
                                                                    python3 -m venv $nasyt_dir/MaiBot/venv
                                                                    source $nasyt_dir/MaiBot/venv/bin/activate  # 激活环境
                                                                    pip install uv -i https://mirrors.aliyun.com/pypi/simple
                                                                    uv pip install -i https://mirrors.aliyun.com/pypi/simple -r $nasyt_dir/MaiBot/requirements.txt --upgrade
                                                                    uv pip install -i https://mirrors.aliyun.com/pypi/simple -r $nasyt_dir/MaiBot-Napcat-Adapter/requirements.txt --upgrade
                                                                fi
                                                                source $nasyt_dir/MaiBot/venv/bin/activate  # 激活环境
                                                                esc
                                                                ;;
                                                            2)
                                                                bash -c "$(curl -L https://meowyun.cn/download/maibot.sh)"
                                                                esc
                                                                ;;
                                                            3)
                                                                test_install wget
                                                                if command -v maibot >/dev/null 2>&1; then
                                                                    source ~/.bashrc
                                                                    maibot
                                                                    esc
                                                                else
                                                                    echo -e "$(info) 正在下载安装脚本"
                                                                    wget -O $nasyt_dir/maibot-install.sh https://raw.githubusercontent.com/Astriora/Antlia/refs/heads/main/Script/MaiBot/MaiBot-install.sh
                                                                    echo -e "$(info) 正在运行安装脚本"
                                                                    bash $nasyt_dir/maibot-install.sh
                                                                fi
                                                                esc
                                                                ;;
                                                            *)
                                                                break
                                                                ;;
                                                        esac
                                                    done
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    9)
                                        test_termux
                                        $habit --msgbox "目前先收集docker安装方式，按回车键安装" 0 0
                                        if [ $? -ne 0 ]; then
                                            break
                                        fi
                                        curl -fsSL https://raw.gitmirror.com/KarinJS/Karin/main/packages/docker/docker.sh | bash
                                        esc
                                        ;;
                                    10)
                                        test_termux
                                        while true
                                        do
                                            nonebot_menu
                                            case $nonebot_menu_xz in
                                                1)
                                                    test_install acl
                                                    curl -fsSL https://api.nbgui.top/api/nbgui/script/install.sh | bash
                                                    setfacl -R -m u:nbwebui:rwx /path/to/your/bot
                                                    ;;
                                                2)
                                                    test_install docker
                                                    nonebot_docker_port=$($habit --title "端口开放" \
                                                    --inputbox "请输入开放管理面板的端口" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    nonebot_docker_dir=$($habit --title "安装位置" \
                                                    none--inputbox "请输入安装的位置\n如果不知道的话请输入/opt/nb-webui" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    echo -e "$(info) docker正在安装中。"
                                                    docker run -d  \
                                                    -p $nonebot_docker_port:8025 \
                                                    -p 2519:2519 \
                                                    -v $nonebot_docker_dir:/data \
                                                    --name nonebot-webui \
                                                    --restart=always \
                                                    myxuebi/nonebot-webui:latest
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
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
                                    7)
                                        $habit --msgbox "本项目来自\n gitee.com/heigxaon/moss-android-terminal" 0 0
                                        if [[ -z $PRETTY_NAME ]]; then
                                            if [[ -e $HOME/MOSS ]]; then
                                                cd $HOME
                                                chmod 777 $HOME/MOSS
                                                ~/MOSS
                                            elif [[ -e $HOME/MOSS.UEG ]]; then
                                                cd $HOME
                                                chmod 777 $HOME/MOSS.UEG
                                                ~/MOSS.UEG
                                            else
                                                $habit --title "安装版本" --yesno "请选择你要安装的版本\n y为完整版 n为精简版" 0 0
                                                if [ $? -ne 0 ]; then
                                                    echo -e "$(info) 正在安装中。"
                                                    curl -L https://gitee.com/heigxaon/moss-android-terminal/releases/download/latest/MOSS -o ~/MOSS
                                                    chmod 777 $HOME/MOSS
                                                    cd ~ && ~/MOSS
                                                    esc
                                                else
                                                    echo -e "$(info) 正在安装中。"
                                                    yes | termux-setup-storage && termux-wake-lock && echo -e "\n\n\033[42;97m▷ 回车继续\033[0m (全自动安装，无需操作)" && read -n 1 &&
                                                    cd /storage/emulated/0/ && curl -L --progress-bar https://gitee.com/heigxaon/moss-android-terminal/releases/download/MOSS/MOSS.tar.gz | tar -zx && cd MOSS && cp MOSS.UEG ~ && chmod 777 ~/MOSS.UEG &&
                                                    tar -zxvf /storage/emulated/0/MOSS/termux-backup.tar.gz -C ~/.. &&
                                                    termux-reload-settings && echo -e "\033[96m▷ 安装完成\033[0m" && ~/MOSS.UEG ||
                                                    echo -e "\033[41;97m▷ 异常终止\033[0m"
                                                fi
                                            fi
                                            esc
                                        else
                                            $habit --msgbox "此区域是给termux玩的，项目详见\nhttps://gitee.com/heigxaon/moss-android-terminal" 0 0
                                        fi
                                        ;;
                                    8)
                                        while true
                                        do
                                            galgame_menu
                                            case $galgame_menu_xz in
                                                1)
                                                    $habit --msgbox "开发中" 0 0
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
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
                                        mv sfs /usr/bin >/dev/null 2>&1
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
                                            test_install curl #curl安装检测
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
                                                echo -e "$(info)$green 输入phira即可启动服务端 $color"
                                                echo -e "$(info) 推荐搭配tmux工具使用"
                                                exit
                                            fi
                                        fi
                                        ;;
                                    3)
                                        tmux_tool
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
                            while true
                            do
                                frp_menu
                                case $frp_menu_xz in
                                    1)
                                        cpolar_instell
                                        esc
                                        ;;
                                    2)
                                        tunnelto_tool
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        7)
                            while true
                            do
                                edit_tool_menu
                                case $edit_tool_menu_xz in
                                    1)
                                        PATH=/snap/bin:$PATH >/dev/null 2>&1
                                        if command -v nvim >/dev/null 2>&1; then
                                            nvim_menu
                                            case $nvim_menu_xz in
                                                Lazy)
                                                    echo -e "$(info) 正在备份原nvim配置"
                                                    mv ~/.config/nvim ~/.config/nvim.bak
                                                    mv ~/.local/share/nvim ~/.local/share/nvim.bak
                                                    
                                                    country #国内外检测
                                                    test_install git #检查git安装
                                                    
                                                    if [[ -d $HOME/.config/nvim ]]; then
                                                        echo -e "$(info) $yellow 仓库已克隆安装。 $color"
                                                    else
                                                        echo -e "$(info) 正在克隆仓库"
                                                        git clone ${github_speed}/https://github.com/LazyVim/starter ~/.config/nvim
                                                        cw_test=$?
                                                        echo $cw_test
                                                        if [ $cw_test -eq 128 ]; then
                                                            echo -e "$(info) $yellow 仓库克隆失败 $color"
                                                        elif [ $cw_test -ne 0 ]; then
                                                            echo -e "$(info) $red 仓库克隆失败，请检查你的网络后重试。$color"
                                                            esc
                                                            break
                                                        else
                                                            echo -e "$(info) $green 仓库克隆成功$color"
                                                        fi
                                                    fi
                                                    esc
                                                    ;;
                                                1)
                                                    echo -e "$(info) 正在加载nvim配置"
                                                    nvim
                                                    esc
                                                    ;;
                                                2)
                                                    echo -e "$(info) 正在备份中"
                                                    mv ~/.config/nvim ~/.config/nvim.bak
                                                    mv ~/.local/share/nvim ~/.local/share/nvim.bak
                                                    echo -e "$(info) 备份完成"
                                                    esc
                                                    ;;
                                                3)
                                                    if [[ -d $HOME/.config/nvim.bak ]]; then
                                                        echo -e "$(info) 检测到备份文件，正在恢复备份"
                                                        rm -rf $HOME/.config/nvim
                                                        mv $HOME/.config/nvim.bak $HOME/.config/nvim
                                                        if [ $? -ne 0 ]; then
                                                            echo -e "$(info) $red 备份恢复失败$color"
                                                        else
                                                            echo -e "$(info) 备份恢复完成"
                                                        fi
                                                    else
                                                        echo -e "$(info) $red 未检测到备份文件$color"
                                                    fi
                                                    esc
                                                    ;;
                                                3)
                                                    if [[ $deb_sys == apt ]]; then
                                                        echo -e "$(info) 正在卸载nvim"
                                                        snap remove nvim
                                                    else
                                                        echo -e "$(info) 正在卸载nvim"
                                                        $sudo_setup $pkg_remove nvim
                                                    fi
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        else
                                            echo -e "$(info)$yellow nvim未安装，正在执行安装步骤$color"
                                            if [[ $deb_sys == apt ]]; then
                                                echo -e "$(info) 检测到apt软件包管理,正在使用snap下载"
                                                test_install snapd
                                                snap install nvim
                                            else
                                                test_install nvim
                                            fi
                                        fi
                                        ;;
                                    2)
                                        $habit --msgbox "无" 0 0
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        8)
                            while true
                            do
                                dow_tool_menu
                                case $dow_tool_menu_xz in
                                    1)
                                        bash -c "$(curl -L https://raw.gitcode.com/nasyt/nasfq/raw/main/nfq.sh)"
                                        esc
                                        ;;
                                    2)
                                        x_url=$($habit --clear --title "twitter视频下载" \
                                        --inputbox "请输入twitter帖子地址" 0 0 \
                                        2>&1 1>/dev/tty)
                                        dow_x_mp4 "$x_url"
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        9)
                            while true
                            do
                                change_tool_menu
                                case $change_tool_menu_xz in
                                    1)
                                        edge_tts
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        10)
                            while true
                            do
                                other_tool_menu
                                case $other_tool_xz in
                                    1)
                                        if [[ -z $PRETTY_NAME ]]; then
                                            test_install alist
                                            if [ $? -ne 0 ]; then
                                                echo -e "$(info) $red alist安装失败 $color"
                                            else
                                                echo "alist安装完成，输入alist查看帮助"
                                            fi
                                        else
                                            echo -e "$(info) 正在拉取脚本"
                                            curl -fsSL "https://alistgo.com/v3.sh" -o $nasyt_dir/v3.sh
                                            if [ $? -ne 0 ]; then
                                                echo -e "$(info) $red 拉取脚本失败，请检查网络连接$color"
                                            fi
                                            bash $nasyt_dir/v3.sh
                                        fi
                                        esc
                                        ;;
                                    2)
                                        test_install tar
                                        if [[ -z $PRETTY_NAME ]]; then
                                            test_install openlist
                                            while true
                                            do
                                                openlist_menu
                                                case $openlist_menu_xz in
                                                    1)
                                                        openlist server
                                                        esc
                                                        ;;
                                                    2)
                                                        openlist_passwd_set=$($habit --title "密码设置" \
                                                        --inputbox "请输入密码:" 0 0 \
                                                        2>&1 1>/dev/tty)
                                                        openlist admin set $openlist_passwd_set
                                                        $habit --msgbox "密码设置完成\n\n用户: admin\n密码: $openlist_passwd_set" 0 0
                                                        ;;
                                                    3)
                                                        $habit --title "确认操作" --yesno "你确定要卸载openlist吗？" 0 0
                                                        if [ $? -ne 0 ]; then
                                                            break
                                                        else
                                                            pkg_remove openlist
                                                            if [ $? -ne 0 ]; then
                                                                echo -e "$(info) $red openlist卸载失败$color"
                                                            else
                                                                echo -e "$(info) $green openlist设置成功$color"
                                                            fi
                                                        fi
                                                        ;;
                                                    4)
                                                        apt install --only-upgrade openlist
                                                        if [ $? -ne 0 ]; then
                                                            echo -e "$(info) $red openlist更新失败$color"
                                                        else
                                                            echo -e "$(info) $green openlist更新成功$color"
                                                        fi
                                                        esc
                                                        ;;
                                                    *)
                                                        break
                                                        ;;
                                                esac
                                            done
                                            esc
                                        else
                                            if [ -e $nasyt_dir/install-openlist-v4.sh ]; then
                                                echo -e "$(info) 检测到脚本已安装，正在启动脚本。"
                                                $sudo_setup bash $nasyt_dir/install-openlist-v4.sh
                                            else
                                                echo -e "$(info) 正在拉取脚本"
                                                curl -fsSL https://res.oplist.org/script/v4.sh > $nasyt_dir/install-openlist-v4.sh
                                                $sudo_setup bash $nasyt_dir/install-openlist-v4.sh
                                            fi
                                        fi
                                        esc
                                        ;;
                                    3)
                                        while true
                                        do
                                            nweb_menu
                                            case $nweb_menu_xz in
                                                1)
                                                    echo -e "$(info) 正在检查wget安装"
                                                    test_install wget
                                                    echo -e "$(info) 正在下载文件"
                                                    if [[ -z $PRETTY_NAME ]]; then
                                                        wget -O $nasyt_dir/nweb "https://gitcode.com/nasyt/nweb/releases/download/nweb_v1.0/nweb_termux_aarch64_0.1.0"
                                                    else
                                                        wget -O $nasyt_dir/nweb "https://gitcode.com/nasyt/nweb/releases/download/nweb_v1.0/nweb_linux_amd64_0.1.0"
                                                    fi
                                                    echo -e "$(info) 正在给予权限"
                                                    chmod 777 $nasyt_dir/*
                                                    esc
                                                    ;;
                                                2)
                                                    chmod 777 $nasyt_dir/*
                                                    nweb_dir=$($habit --title "nweb" \
                                                    --inputbox "请输入要运行的目录:" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    
                                                    nweb_port=$($habit --title "nweb" \
                                                    --inputbox "请输入要启动的端口" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    
                                                    nweb $nweb_dir $nweb_port
                                                    esc
                                                    ;;
                                                3)
                                                    echo -e "$(info) 正在删除文件"
                                                    rm $nasyt_dir/nweb
                                                    esc
                                                    ;;
                                                4)
                                                    tmux_tool
                                                    esc
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    4)
                                        if [[ -z $PRETTY_NAME ]]; then
                                            $habit --msgbox "cloudreve不支持termux安装" 0 0
                                            break
                                        fi
                                        while true
                                        do
                                            cloudreve_menu
                                            case $cloudreve_menu_xz in
                                                1)
                                                    test_docker #docker安装函数
                                                    cloudreve_docker_port=$($habit --title "cloudreve安装引导" \
                                                    --inputbox "请输入cloudreve启动的端口" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    echo -e "$(info) 正在使用docker安装cloudreve中"
                                                    docker run -d --name cloudreve \
                                                    -p $cloudreve_docker_port:5212 \
                                                    -p 6888:6888 \
                                                    -p 6888:6888/udp \
                                                    -v ~/cloudreve/data:/cloudreve/data \
                                                    cloudreve/cloudreve:latest
                                                    $habit --msgbox "cloudreve已启动\n请访问$cloudreve_docker_port 端口查看" 0 0
                                                    esc
                                                    ;;
                                                2)
                                                    # 关闭当前运行的容器
                                                    echo -e "$(info) 正在停止cloudreve服务"
                                                    docker stop cloudreve
                                                    # 删除当前运行的容器
                                                    echo -e "$(info) 正在删除当前cloudreve版本"
                                                    docker rm cloudreve
                                                    # 使用新的镜像创建一个新的容器，并挂载相同的 Volume
                                                    echo -e "$(info) $正在下载新版本cloudreve$color"
                                                    cloudreve_docker_port=$($habit --title "cloudreve安装引导" \
                                                    --inputbox "请输入cloudreve启动的端口" 0 0 \
                                                    2>&1 1>/dev/tty)
                                                    docker run -d --name cloudreve -p $cloudreve_docker_port:5212 \
                                                        -v ~/cloudreve/data:/cloudreve/data \
                                                        # 其他配置参数，与上次启动相同
                                                        cloudreve/cloudreve:latest
                                                    esc
                                                    $habit --msgbox "cloudreve更新完成" 0 0
                                                    ;;
                                                3)
                                                    echo -e "$(info) 正在启动cloudreve"
                                                    docker start cloudreve
                                                    if [ $? -ne 0 ]; then
                                                        echo -e "$(info) $red 启动失败$color"
                                                    else
                                                        echo -e "$(info) $green 启动成功$color"
                                                    fi
                                                    esc
                                                    ;;
                                                4)
                                                    echo -e "$(info) 正在停止cloudreve服务"
                                                    docker stop cloudreve
                                                    if [ $? -ne 0 ]; then
                                                        echo -e "$(info) $red 停止失败$color"
                                                    else
                                                        echo -e "$(info) $green 停止成功$color"
                                                    fi
                                                    esc
                                                    ;;
                                                5)
                                                    echo -e "$(info) 正在删除cloudreve云盘"
                                                    docker stop cloudreve >/dev/null 2>&1
                                                    docker rm cloudreve
                                                    if [ $? -ne 0 ]; then
                                                        echo -e "$(info) $red 删除失败$color"
                                                    else
                                                        echo -e "$(info) $green 删除成功$color"
                                                    fi
                                                    esc
                                                    ;;
                                                *)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    5)
                                        $habit --msgbox "无" 0 0
                                        ;;
                                    6)
                                        $habit --title "bilibili-tui" --yesno "来自项目\ngithub.com/MareDevi/bilibili-tui\n安装脚本只支持amd64框架,其他框架请自行编译安装\n安装方式由项目提供,是否安装" 0 0
                                        if [ $? -ne 0 ]; then
                                            return
                                        else
                                            test_install curl
                                            echo -e "$(info) 正在拉取脚本"
                                            $habit --title "确认操作" --yesno "是否使用github加速地址" 0 0
                                            if [ $? -ne 0 ]; then
                                                curl --proto '=https' --tlsv1.2 -LsSf https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.9/bilibili-tui-installer.sh | sh
                                            else
                                                curl --proto '=https' --tlsv1.2 -LsSf https://ghfast.top/https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.9/bilibili-tui-installer.sh | sh
                                            fi
                                        fi
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
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
                    app_install
                    case $app_install_xz in
                        1)
                            while true
                            do
                                image_menu
                                case $image_menu_xz in
                                    1)
                                        test_install gimp
                                        esc
                                        ;;
                                    2)
                                        test_install feh
                                        esc
                                        ;;
                                    3)
                                        test_install chafa
                                        esc
                                        ;;
                                    4)
                                        test_install mpv
                                        esc
                                        ;;
                                    5)
                                        test_install w3m
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
                                model_menu
                                case $model_menu_xz in
                                    1)
                                        test_install blender
                                        esc
                                        ;;
                                    2)
                                        test_install freecad
                                        esc
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
                                work_menu
                                case $work_menu_xz in
                                    1)
                                        if command -v apt >/dev/null 2>&1; then
                                            test_install wget
                                            arch=$(uname -p)
                                            echo -e "$(info) 正在下载软件包"
                                            wget "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/24730/wps-office_12.1.2.24730.AK.preread.sw_644359_$arch.deb"
                                            if [ $? -ne 0 ]; then
                                                echo -e "$(info) $red 下载失败$color，可手动去https://365.wps.cn/download365下载，或者联系QQ:3213631396询问"
                                                esc
                                                continue
                                            else
                                                echo -e "$(info) $green 软件包下载成功$color"
                                            fi
                                            echo -e "$(info) $blue 正在安装软件包$color"
                                            sudo dpkg -i wps-office*.deb
                                        else
                                            $habit --msgbox "目前作者只收集了deb软件包" 0 0
                                        fi
                                        ;;
                                    2)
                                        test_install libreoffice
                                        esc
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
                                system_app_menu
                                case $system_app_menu_xz in
                                    1)
                                        test_install flatpak
                                        esc
                                        ;;
                                    2)
                                        $habit --title "确认操作" --yesno "你确定要安装linux应用商店吗？" 0 0
                                        if [ $? -ne 0 ]; then
                                            break
                                        else
                                            test_install gnome-software
                                        fi
                                        $habit --msgbox "安装完成\n请打开桌面查看。" 0 0
                                        esc
                                        ;;
                                    3)
                                        test_install bleachbit
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        *)
                            break
                            ;;
                    esac
                done
                ;;
            6)
                while true
                do
                    Linux_shell
                    case $Linux_shell_xz in
                        1)
                            while true
                            do
                                more_shell_menu
                                case $more_shell_menu_xz in
                                    1) 
                                        if [ -e $nasyt_dir/yzy.sh ]; then
                                           chmod +x $nasyt_dir/*
                                           bash $nasyt_dir/yzy.sh
                                        else
                                           curl -L https://gitee.com/krhzj/LinuxTool/raw/main/Linux.sh -o $nasyt_dir/yzy.sh
                                           chmod +x $nasyt_dir/*
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
                                        bash <(curl -sL shell.cdn1.vip)
                                        esc
                                        ;;
                                    *)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        3)
                            if [ -e "$nasyt_dir/MinecraftMotdStressTest/motd_stress_test_optimized.py" ]; then
                                test_install python pip #调用函数检测
                                pip_mcstatus;pip_colorama  #调用函数安装/检测
                                br;sleep 1
                                mc_test_ip=$($habit --title "服务器地址" \
                                --inputbox "本脚本由 NAS油条 制作\n >_< \n 请输入IP或域名" 0 0 \
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
                                esc
                            else
                               
                               echo -e "$(info) 正在克隆github仓库"
                               git clone https://github.com/konsheng/MinecraftMotdStressTest.git $nasyt_dir/MinecraftMotdStressTest 
                               if [ $? -ne 0 ]; then
                               echo -e "$(info) $red 克隆失败$color"
                               else
                               echo -e "$(info) $green 克隆成功$color"
                               fi
                               echo -e "$(info) 正在检查,脚本所需资源"
                               test_install python pip #调用函数安装/检测
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
                            esc
                            ;;
                        5)
                            bash -c "$(curl -L https://raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/cs_shell.sh)"
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
                                    test_install git #git检查函数
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
                            if [ -e $nasyt_dir/kejilion.sh ]; then
                                chmod +x $nasyt_dir/kejilion.sh
                                sleep 1s
                                bash $nasyt_dir/kejilion.sh
                            else
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
                            fi
                            esc
                            ;;
                        10)
                            test_install wget
                            if [ -e $nasyt_dir/v2ray_shell.sh ]; then
                                echo -e "$(info) 脚本已安装，正在运行。"
                                $sudo_setup bash $nasyt_dir/v2ray_shell.sh
                            else
                                echo -e "$(info) 正在下载安装脚本"
                                wget -O $nasyt_dir/v2ray_shell.sh -N --no-check-certificate "https://ghfast.top/https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh"
                                if [ $? -ne 0 ]; then
                                    echo -e "$(info) $red 文件下载失败$color"
                                else
                                    echo -e "$(info) $green 文件下载成功$color"
                                fi
                                chmod 777 $nasyt_dir/*
                                $sudo_setup bash $nasyt_dir/v2ray_shell.sh
                            fi
                            esc
                            ;;
                        11)
                            curl -o $nasyt_dir/naster "https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/nasyt_termux.sh"
                            chmod +x $nasyt_dir/*
                            naster
                            ;;
                        0) 
                            break
                            ;;
                        *)
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
                bash -c "$(curl -L https://raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/up_history.sh)" #更新日志
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
                            *) break ;;
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
                        test_install ncdu
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
                                *) break;;
                            esac
                        done
                        ;;
                    8)
                        echo -e "$(info) 正在补全文件中"
                        test_install figlet
                        test_install dialog
                        test_whiptail
                        test_install curl
                        test_install git
                        test_install wget
                        echo -e "$(info) 命令运行完毕"
                        esc
                        ;;
                    9)  
                        rm $nasyt_dir/config.txt
                        $habit --msgbox "删除配置文件完成。" 0 0
                        exit
                        ;;
                    *)  break;;
                esac
                done
                ;;
            10)
                acg
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
#country #国内外检测
source $nasyt_dir/config.txt >/dev/null 2>&1 # 加载脚本配置
check_pkg_install # 检测包管理器
# 启动参数
if [ $# -ne 0 ]; then
    case $1 in
    twitter|-x|--dowx|--twitter)
        if [[ -z $2 ]]; then
            echo ""
            echo "用法:"
            echo "nasyt [参数] [链接]"
            echo ""
            exit 0
        else
            dow_x_mp4 "$2"
        fi
        exit 0
        ;;
    acg|-a|--acg)
        if [[ $2 -eq 0 ]]; then
            case $2 in
                help|-h|--help|-help)
                    echo
                    echo "用法:"
                    echo "  nasyt -a [参数]"
                    echo "参数:"
                    echo "  nasyt -a pc 随机输出横屏acg图片"
                    echo "  nasyt -a pe 随机输出竖屏acg图片"
                    echo "  nasyt -a help 输出帮助"
                    echo
                    exit 0
                    ;;
                pc|--pc)
                    tp_curl=https://www.loliapi.com/acg/pc
                    acg_menu_sz=pc
                    acg $2
                    ;;
                pe|--pe)
                    tp_curl=https://www.loliapi.com/acg/pe
                    acg_menu_sz=pe
                    acg $2
                    ;;
                *)
                    shell_2=$2
                    if [[ $shell_2 =~ ^http ]]; then
                        acg $2
                    else
                        acg
                    fi
                    ;;
            esac
        fi
        exit
        ;;
    docker|-d|--docker)
        docker_menu
        exit
        ;;
    edge_tts|-e|--edge_tts)
        if [[ -n $2 ]] && [[ -n $3 ]]; then
            edge_tts $2 $3 $4
        elif [[ $2 == help ]]; then
            echo;echo "用法: nasyt $1 [文字] [输出文件名] [音色(可选)]"
        elif [[ $# -ne 1 ]]; then
            echo -e "$red 还需要一个参数进行输出 $color"
        else
            edge_tts
        fi
        exit
        ;;
    backup|-b|--backup)
        nasyt_backup
        exit
        ;;
    update|-u|--update)
        gx
        ;;
    mirror|-m|--mirror)
        upsource
        exit
        ;;
    tmux|-t|--tmux)
        tmux_tool
        exit
        ;;
    turn|-turn|--turn)
        truncate -s $2 $3
        exit 0
        ;;
    skin|-s|--skip)
        shell_skip=1
        ;;
    version|-v|-version|--version)
        echo
        echo "名称: nasyt"
        echo "版本: $version"
        #echo "来源: $nasyt_from"
        echo "操作系统: $PRETTY_NAME"
        echo "位于目录: $(command -v nasyt)"
        echo
        exit
        ;;
    nlist|-n|--nlist)
        nlist_tool $2 $3 $4
        exit
        ;;
    remove|-r|--remove)
        shell_uninstall
        ;;
    help|-h|-help|--help)
        echo
        echo "用法:"
        echo -e "  ${blue}nasyt [参数]$color"
        echo "参数:"
        echo "  -x, --dowx 快捷下载twitter视频"
        echo "  -a, --acg 快捷随机acg图片"
        echo "  -d, --docker 快捷docker管理"
        echo "  -e, --edge_tts 文字转语音"
        echo "  -u, --update 快捷更新脚本"
        echo "  -m, --mirror 快捷换软件源"
        echo "  -t, --tmux 快捷进入tmux管理"
        echo "  -s, --skip 直接进入菜单部分"
        echo "  -v, --version 输出脚本版本"
        echo "  -h, --help  输出命令帮助"
        echo "  -b, --backup  快捷备份恢复脚本"
        echo "  -n, --nlist  生成网页目录结构"
        echo "  -r, --remove 卸载本脚本工具"
        echo
        echo "有关更多详细信息，请参见"
        echo -e "$green https://gitcode.com/nasyt/nasyt-linux-tool$color"
        echo
        exit
        ;;
    *)
        echo
        echo -e "$red $@ 是无效的参数$color"
        echo -e "$blue 请输入nasyt help查看帮助$color"
        exit 1
    esac
fi

index_main # 脚本主程序