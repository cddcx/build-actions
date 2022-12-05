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

# 添加源
echo "src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages" >>  feeds.conf.default
#echo 'src-git store https://github.com/linkease/istore.git;main' >>feeds.conf.default
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default

# luci-theme-opentopd主题
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
rm -rf package/luci-theme-opentopd/README* package/luci-theme-opentopd/doc/
