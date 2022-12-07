#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

#1. 默认ip
#sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#2 修改密码
#sed -i 's/root::0:0:99999:7:::/root:$1$SOP5eWTA$fJV8ty3QohO0chErhlxCm1:18775:0:99999:7:::/g' package/base-files/files/etc/shadow

# 添加源
echo "src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages" >>  feeds.conf.default
svn co https://github.com/Lienol/openwrt-package/branches/other/lean ./package/lean #添加Lienol的lean
#echo 'src-git store https://github.com/linkease/istore.git;main' >>feeds.conf.default
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default 

# luci-theme-opentopd主题
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
rm -rf package/luci-theme-opentopd/README* package/luci-theme-opentopd/doc/
