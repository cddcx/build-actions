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

##### 添加源和软件
## luci-app-filetransfer
#svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-filetransfer package/luci-app-filetransfer
#rm -rf package/luci-app-filetransfer/.svn
# luci-app-filetransfer依赖
#svn co https://github.com/immortalwrt/luci/trunk/libs/luci-lib-fs package/luci-lib-fs
#rm -rf package/luci-lib-fs/.svn

## default-settings
mkdir -p package/emortal/default-settings
svn co https://github.com/immortalwrt/immortalwrt/trunk/package/emortal/default-settings package/emortal/default-settings
rm -rf package/emortal/default-settings/.svn

## luci-app-v2raya
git clone https://github.com/v2rayA/v2raya-openwrt package/v2raya-openwrt

## luci-app-homeproxy
git clone https://github.com/immortalwrt/homeproxy package/homeproxy
sed -i "s/ImmortalWrt/OpenWrt/g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

## luci-app-passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
