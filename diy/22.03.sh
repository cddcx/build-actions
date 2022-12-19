#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

#1. 默认ip
#sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#2 修改密码
sed -i 's/root::0:0:99999:7:::/root:$1$xUooaZpA$6zs50xt4ac9sJXiYpycT3\/:19338:0:99999:7:::/g' package/base-files/files/etc/shadow

## 添加源和软件
#echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/linkease package/linkease
#svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/jerrykuku/luci-theme-argon package/luci-theme-argon
# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn

##修改openwrt的include/target.mk文件
sed -i 's/libustream-wolfssl/libustream-openssl/g' include/target.mk
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
#sed -i 's/kmod-ipt-offload/block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun dkmod-ipt-offload/g' include/target.mk
#sed -i 's/ip6tables/ip6tables iptables-mod-tproxy iptables-mod-extra ipset ip-full default-settings luci luci-newapi/g' include/target.mk
#sed -i 's/odhcp6c/odhcp6c ddns-scripts_aliyun ddns-scripts_dnspod/g' include/target.mk
#sed -i 's/odhcpd-ipv6only/odhcpd-ipv6only curl ca-certificates/g' include/target.mk

##修改openwrt/target/linux/x86的Makefile文件
#sed -i 's/kmod-button-hotplug/kmod-alx kmod-e1000e kmod-igb kmod-igc kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-via-velocity kmod-vmxnet3 kmod-i40e kmod-i40evf kmod-r8125 kmod-8139cp kmod-8139too kmod-tg3 htop lm-sensors iperf3 ca-bundle kmod-sound-hda-core kmod-sound-hda-codec-realtek kmod-sound-hda-codec-via kmod-sound-via82xx kmod-sound-hda-intel kmod-sound-hda-codec-hdmi kmod-sound-i8x0 kmod-usb-audio kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152-vendor kmod-usb-net-aqc111 kmod-mlx4-core kmod-mlx5-core kmod-drm-i915 kmod-drm-amdgpu luci-app-openclash luci-app-istorex luci-app-udpxy luci-app-upnp/g' target/linux/x86/Makefile
sed -i 's/mkf2fs/alsa-utils mkf2fs fdisk kmod-usb-hid kmod-e1000e kmod-i40e kmod-igb kmod-igbvf kmod-igc kmod-ixgbe kmod-pcnet32 kmod-tulip kmod-vmxnet3 kmod-r8101 kmod-r8125 kmod-r8168 kmod-8139cp kmod-8139too kmod-tg3 kmod-fs-f2fs kmod-ac97 kmod-sound-hda-core kmod-sound-hda-codec-realtek kmod-sound-hda-codec-via kmod-sound-via82xx kmod-sound-hda-intel kmod-sound-hda-codec-hdmi kmod-sound-i8x0 kmod-usb-audio kmod-usb-net kmod-usb-net-asix kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152-vendor autocore-x86 automount block-mount default-settings-chn kmod-ipt-raw kmod-nf-nathelper kmod-nf-nathelper-extra luci luci-compat luci-lib-base luci-lib-fs luci-lib-ipkg luci-app-openclash luci-app-istorex luci-app-udpxy luci-app-upnp/g' target/linux/x86/Makefile
#cp -af package/add/luci-app-filetransfer/po/zh-cn  package/add/luci-app-filetransfer/po/zh_Hans
