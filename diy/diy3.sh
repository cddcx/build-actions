#!/bin/bash
#=================================================

echo "开始 DIY2 配置……"
echo "========================="

chmod +x ${GITHUB_WORKSPACE}/subscript.sh
source ${GITHUB_WORKSPACE}/subscript.sh

# 修改内核
sed -i 's/PATCHVER:=*.*/PATCHVER:=6.6/g' target/linux/x86/Makefile 

##. 默认ip
#sed -i 's/*.*.*.*/192.168.1.1/g' package/base-files/files/bin/config_generate

## 修改密码
#sed -i 's@root:::0:99999:7:::@root:$1$pfsE8FKB$tnZcDcV8vUTqxJpwXLzZv1:19690:0:99999:7:::@g' package/base-files/files/etc/shadow
sed -i 's@root:::0:99999:7:::@root:$1$/n/cF0jQ$ffjS0OFp8jH5zPyfdOJvq/:19692:0:99999:7:::@g' package/base-files/files/etc/shadow

# 取消主题默认设置
#find feeds/luci/themes/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/*mediaurlbase*/d' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-argon/luci-theme-kucat/g' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' {} \;

# docker
#rm -rf feeds/packages/utils/docker
#cp -rf utils/docker feeds/packages/utils/docker
#rm -rf feeds/packages/utils/dockerd
#cp -rf utils/dockerd feeds/packages/utils/dockerd
#rm -rf feeds/packages/utils/docker-compose
#cp -rf utils/docker-compose feeds/packages/utils/docker-compose
#rm -rf utils
#rm -rf feeds/luci/applications/luci-app-dockerman
#cp -rf applications/luci-app-dockerman feeds/luci/applications/luci-app-dockerman
#rm -rf applications

# TTYD 自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
# TTYD 更改
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

## 修改target.mk
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i "s/kmod-nft-offload/kmod-nft-offload kmod-nft-tproxy/" include/target.mk
#sed -i "s/odhcp6c/ipv6-helper/" include/target.mk
sed -i "s/DEFAULT_PACKAGES.router:=/DEFAULT_PACKAGES.router:=default-settings-chn luci-app-opkg luci-app-firewall /" include/target.mk

## 修改target/linux/x86/Makefile
#sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += luci-app-passwall2 luci-app-ttyd luci-app-udpxy /g' target/linux/x86/Makefile
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += luci-app-upnp luci-app-udpxy luci-app-homeproxy luci-app-passwall2 /g' target/linux/x86/Makefile

## 删除
rm -rf feeds/luci/applications/luci-app-v2raya
rm -rf feeds/packages/net/v2raya
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

# curl/8.5.0 - fix passwall `time_pretransfer` check
#rm -rf feeds/packages/net/curl
#git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#rm -rf feeds/packages/net/shadowsocks-libev
#cd feeds/packages/net
#mkdir -p shadowsocksr-libev
#git_clone_path v5 https://github.com/sbwml/openwrt_helloworld shadowsocksr-libev


echo "========================="
echo " DIY2 配置完成……"
