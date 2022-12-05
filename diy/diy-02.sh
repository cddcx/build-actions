#!/bin/bash

#1. 默认ip
#sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#2 修改密码
sed -i 's/root::0:0:99999:7:::/root:$1$SOP5eWTA$fJV8ty3QohO0chErhlxCm1:18775:0:99999:7:::/g' package/base-files/files/etc/shadow

#3 修改默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

##
svn export https://github.com/coolsnowwolf/luci/trunk/libs/luci-lib-fs feeds/luci/libs/luci-lib-fs
ln -s ../../../feeds/luci/libs/luci-lib-fs package/feeds/xiangfeidexiaohuo/luci-lib-fs

# 整理
#rm -rf feeds/luci/themes/luci-theme-argon
rm -rf package/feeds/luci/luci-app-dockerman
rm -rf feeds/packages/utils/coremark
