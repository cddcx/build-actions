#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================
##添加自己的插件库
echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages' >>feeds.conf.default
#sed -i '1isrc-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages\n' feeds.conf.default

# luci-theme-opentopd主题
git clone https://github.com/sirpdboy/luci-theme-opentopd openwrt/package/luci-theme-opentopd
rm -rf package/luci-theme-opentopd/README* openwrt/package/luci-theme-opentopd/doc/
