#!/bin/bash
#=================================================

echo "开始 DIY1 配置……"
echo "========================="

chmod +x ${GITHUB_WORKSPACE}/subscript.sh
source ${GITHUB_WORKSPACE}/subscript.sh

## autocore automount default-settings
merge_package master https://github.com/immortalwrt/immortalwrt package/emortal package/emortal/default-settings
#git clone https://github.com/cddcx/default-settings.git package/emortal/default-settings

## luci-app-homeproxy
git clone https://github.com/immortalwrt/homeproxy package/homeproxy           ####### homeproxy的默认版本(二选一)
#git clone -b dev https://github.com/immortalwrt/homeproxy package/homeproxy     ####### homeproxy的dev版本(二选一)  
sed -i "s@ImmortalWrt@OpenWrt@g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s@ImmortalWrt proxy@OpenWrt proxy@g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# Psswall & SSRP 等插件
#git clone https://github.com/sbwml/openwrt_helloworld package/helloworld

## luci-app-passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall2
rm -rf package/passwall2/{chinadns-ng,dns2socks,dns2tcp,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,tcping,trojan-plus,trojan,tuic-client,v2ray-core,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}
merge_package v5 https://github.com/sbwml/openwrt_helloworld openwrt_helloworld package/passwall2/chinadns-ng dns2socks dns2tcp hysteria ipt2socks microsocks naiveproxy shadowsocks-rust shadowsocksr-libev simple-obfs sing-box tcping trojan-plus trojan tuic-client v2ray-core v2ray-geodata v2ray-plugin xray-core xray-plugin
merge_package main https://github.com/xiaorouji/openwrt-passwall2 openwrt-passwall2 package/luci-app-passwall2
