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
echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default
#echo 'src-git custom https://github.com/VergilGao/openwrt-packages;openwrt-21.02' >> feeds.conf.default
#echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
#echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

##添加文件传输(filetransert)
svn export https://github.com/coolsnowwolf/luci/trunk/libs/luci-lib-fs package/add/luci-lib-fs
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-filetransfer package/add/luci-app-filetransfer
sed -i "s/\.\.\/\.\./\$\(TOPDIR\)\/feeds\/luci/g" package/add/luci-app-filetransfer/Makefile
cp -af package/add/luci-app-filetransfer/po/zh-cn  package/add/luci-app-filetransfer/po/zh_Hans
