#!/bin/bash
#=================================================

## luci-app-passwall
merge_package 主 https://github.com/xiaorouji/openwrt-passwall 包 luci-app-passwall

## luci-app-passwall2
#merge_package 主 https://github.com/xiaorouji/openwrt-passwall2 包 luci-app-passwall2

# 核心包
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
rm -rf package/passwall-packages/{chinadns-ng，dns2socks，dns2tcp，hysteria，ipt2socks，microsocks，naiveproxy，shadowsocks-rust，shadowsocksr-libev，simple-obfs，sing-box}
rm -rf package/passwall-packages/{tcping，trojan-plus，trojan，tuic-client，v2ray-core，v2ray-geodata，v2ray-plugin，xray-core，xray-plugin}
merge_package v5 https://github.com/sbwml/openwrt_helloworld 包/passwall-packages chinadns-ng dns2socks dns2tcp 歇斯底里 ipt2socks microsocks naiveproxy shadowsocks-rust shadowsocksr-libev simple-obfs sing-box
merge_package v5 https://github.com/sbwml/openwrt_helloworld package/passwall-packages tcping 木马加木马 tuic-client v2ray-core v2ray-geodata v2ray-plugin xray-core xray-plugin
