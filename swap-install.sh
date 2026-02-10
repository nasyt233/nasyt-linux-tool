#!/bin/bash

# 确保脚本以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要 root 权限运行" >&2
   exit 1
fi

#声明
echo "于2025/9/11制作"
echo "本脚本由mcsqxa制作，NAS油条进行修改优化"
echo "注意: 脚本执行完毕后会重启"
echo ""
read -p "回车键运行脚本"

# 设置虚拟内存大小
read -p "请输入虚拟内存大小(推荐8G) : " swap_size

#定义变量
SWAP_SIZE=$swap_size

# 创建一个虚拟内存文件
sudo fallocate -l $SWAP_SIZE /swapfile

# 设置文件权限
sudo chmod 600 /swapfile

# 设置为 swap 文件
sudo mkswap /swapfile

# 启用 swap 文件
sudo swapon /swapfile

# 将 swap 文件添加到 /etc/fstab 以实现自启动
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 检查 swap 是否启用
swapon --show

# 设置 swappiness 值（可选）
# 建议值为 10，以减少对 swap 的使用
sudo sysctl vm.swappiness=10

# 将 swappiness 值写入 /etc/sysctl.conf 以实现自启动
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

echo "虚拟内存设置完成，大小为 $SWAP_SIZE。"

# 自动重启系统
echo "系统将在 10 秒后自动重启..."

sleep 10

sudo reboot
