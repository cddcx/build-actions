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

## default-settings
#mkdir -p package/emortal/default-settings
svn export https://github.com/immortalwrt/immortalwrt/branches/master/package/emortal/default-settings package/emortal/default-settings

## luci-app-filetransfer
svn export https://github.com/immortalwrt/luci/branches/master/applications/luci-app-filetransfer package/luci-app-filetransfer
sed -i 's@../../luci.mk@$(TOPDIR)/feeds/luci/luci.mk@g' package/luci-app-filetransfer/Makefile
# luci-app-filetransfer依赖luci-lib-fs
svn export https://github.com/immortalwrt/luci/branches/master/libs/luci-lib-fs package/luci-lib-fs

## luci-app-v2raya
svn export https://github.com/v2rayA/v2raya-openwrt/trunk package/v2raya-openwrt

## luci-app-homeproxy
svn export https://github.com/immortalwrt/homeproxy/trunk package/homeproxy           # homeproxy的默认版本
#svn export https://github.com/immortalwrt/homeproxy/branches/dev package/homeproxy   # homeproxy的dev版本  
sed -i "s@ImmortalWrt@OpenWrt@g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s@ImmortalWrt proxy@OpenWrt proxy@g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

## luci-app-passwall2
svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
svn export https://github.com/xiaorouji/openwrt-passwall-packages/trunk package/passwall
#git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall
#git clone https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
