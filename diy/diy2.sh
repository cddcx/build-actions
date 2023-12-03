#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================             

# 修改内核
sed -i 's/PATCHVER:=*.*/PATCHVER:=6.1/g' target/linux/x86/Makefile 

##. 默认ip
#sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

## 修改密码
#sed -i 's@root:::0:99999:7:::@root:$1$pfsE8FKB$tnZcDcV8vUTqxJpwXLzZv1:19690:0:99999:7:::@g' package/base-files/files/etc/shadow
sed -i 's@root:::0:99999:7:::@root:$1$/n/cF0jQ$ffjS0OFp8jH5zPyfdOJvq/:19692:0:99999:7:::@g' package/base-files/files/etc/shadow

# 取消主题默认设置
#find feeds/luci/themes/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/*mediaurlbase*/d' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-argon/luci-theme-kucat/g' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' {} \;

## luci-app-filetransfer
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-filetransfer package/luci-app-filetransfer
rm -rf package/luci-app-filetransfer/.svn
sed -i 's@../../luci.mk@$(TOPDIR)/feeds/luci/luci.mk@g' package/luci-app-filetransfer/Makefile
# luci-app-filetransfer依赖
svn co https://github.com/immortalwrt/luci/trunk/libs/luci-lib-fs package/luci-lib-fs
rm -rf package/luci-lib-fs/.svn

# TTYD 自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

## 修改target.mk
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i "s/kmod-nft-offload/kmod-nft-offload kmod-nft-tproxy/" include/target.mk
sed -i "s/DEFAULT_PACKAGES.router:=/DEFAULT_PACKAGES.router:=curl default-settings-chn luci luci-light luci-compat luci-lib-ipkg \
luci-app-opkg luci-app-firewall /" include/target.mk

## 修改target/linux/x86/Makefile
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += ipset ip-full luci-app-homeproxy luci-app-passwall2 luci-app-udpxy luci-app-upnp luci-app-v2raya /g' target/linux/x86/Makefile
