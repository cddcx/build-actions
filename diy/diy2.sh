#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================             

#设置默认中文
#sed -i 's/auto/zh_Hans/g' feeds/luci/modules/luci-base/root/etc/config/luci

##默认X86
#rm -rf target/Makefile
#rm -rf target/linux/Makefile
#svn export https://github.com/coolsnowwolf/lede/trunk/target/Makefile target/Makefile
#svn export https://github.com/coolsnowwolf/lede/trunk/target/linux/Makefile target/linux/Makefile

## 删除软件
#rm -rf feeds/luci/applications/luci-app-disk*
#rm -rf package/feeds/luci/luci-app-disk*
rm -rf feeds/luci/applications/luci-app-attendedsysupgrade
rm -rf feeds/luci/applications/luci-app-docker*
rm -rf package/feeds/luci/luci-app-attendedsysupgrade
rm -rf package/feeds/luci/luci-app-docker*
rm -rf package/feeds/luci/luci-lib-docker
rm -rf feeds/packages/utils/attendedsysupgrade*
rm -rf feeds/packages/utils/docker*
rm -rf package/feeds/packages/docker*
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
rm -rf package/feeds/packages/auc
rm -rf package/feeds/packages/attendedsysupgrade-common
#rm -rf feeds/packages/utils/runc
#rm -rf feeds/packages/utils/libnetwork
#rm -rf feeds/luci/applications/luci-app-adguardhome
#rm -rf feeds/packages/net/adguardhome

##配置IP
#sed -i 's/192.168.1.1/192.168.100.101/g' package/base-files/files/bin/config_generate

##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
##替换theme icons
#wget -O ./feeds/xiangfeidexiaohuo/jerrykuku/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg https://github.com/HiJwm/MySettings/raw/main/BackGround/2.jpg
#svn co https://github.com/xylz0928/luci-mod/trunk/feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons ./package/lucimod
#mv package/lucimod/* feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons/

##更改主机名
#sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate

##加入作者信息
#sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='$(date +%Y%m%d) by HiJwm'/g" package/base-files/files/etc/openwrt_release #默认为openwrt版本号，无个人信息
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d) by HiJwm'/g"  package/base-files/files/etc/openwrt_release #编译文件中添加，这个就无效了

##把nas-packages-luci的zh-cn替换成zh_Hans
sed -i 's/("QuickStart")/("首页")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
sed -i 's/("NetworkGuide")/("向导")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
sed -i 's/("RAID")/("磁盘阵列")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
sed -i 's/("NetworkPort")/("网口配置")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
#cp -af package/linkease/nas-packages-luci/luci-app-quickstart/po/zh-cn package/linkease/nas-packages-luci/luci-app-quickstart/po/zh_Hans 
