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
#sed -i 's/root::0:0:99999:7:::/root:$1$pfsE8FKB$tnZcDcV8vUTqxJpwXLzZv1:19690:0:99999:7:::/g' package/base-files/files/etc/shadow

## 修改target.mk
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i "s/kmod-nft-offload/kmod-nft-offload kmod-nft-tproxy/" include/target.mk
sed -i "s/DEFAULT_PACKAGES.router:=/DEFAULT_PACKAGES.router:=curl luci luci-light luci-compat luci-lib-base luci-lib-ipkg \
luci-app-opkg luci-app-firewall /" include/target.mk

## 修改target/linux/x86/Makefile
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += ipset ip-full luci-app-homeproxy luci-app-passwall2 luci-app-udpxy luci-app-upnp /g' target/linux/x86/Makefile
