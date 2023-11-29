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
sed -i 's/root::0:0:99999:7:::/root:$1$pfsE8FKB$tnZcDcV8vUTqxJpwXLzZv1:19690:0:99999:7:::/g' package/base-files/files/etc/shadow

## 添加源和软件
# luci-app-filetransfer
#svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-filetransfer package/luci-app-filetransfer
#rm -rf package/luci-app-filetransfer/.svn
svn co https://github.com/sbwml/openwrt_pkgs/trunk/filebrowser package/filebrowser
svn co https://github.com/sbwml/openwrt_pkgs/trunk/luci-app-filebrowser package/filebrowser

# luci-app-homeproxy
git clone https://github.com/immortalwrt/homeproxy package/homeproxy

# luci-app-passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
