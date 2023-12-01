#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================             

# 修改内核
sed -i 's/PATCHVER:=*.*/PATCHVER:=6.1/g' target/linux/x86/Makefile 

## 修改target.mk
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i "s/kmod-nft-offload/kmod-nft-offload kmod-nft-tproxy/" include/target.mk
sed -i "s/DEFAULT_PACKAGES.router:=/DEFAULT_PACKAGES.router:=curl luci luci-light luci-compat luci-lib-base luci-lib-ipkg \
luci-app-opkg luci-app-firewall /" include/target.mk

# 修改target/linux/x86/Makefile
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += ipset ip-full luci-app-homeproxy luci-app-passwall2 /g' target/linux/x86/Makefile
