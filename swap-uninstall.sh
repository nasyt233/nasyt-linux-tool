#!/bin/bash

# 确保脚本以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要 root 权限运行" >&2
   exit 1
fi

read -p "确定卸载虚拟内存 Ctrl+C退出"
# 禁用 swap 文件
swapoff /swapfile

# 从 /etc/fstab 中移除 swap 文件条目
sed -i '/\/swapfile/d' /etc/fstab

# 删除 swap 文件
rm -f /swapfile

echo "虚拟内存文件已成功卸载。"

# 自动重启系统
echo "系统将在 10 秒后自动重启..."

sleep 10

sudo reboot
