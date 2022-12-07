#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================
# 添加源
echo "src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages" >>  feeds.conf.default
https://github.com/coolsnowwolf/lede/trunk/package/lean package/lean

# luci-theme-opentopd主题
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
rm -rf package/luci-theme-opentopd/README* package/luci-theme-opentopd/doc/
