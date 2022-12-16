## 修改密码
sed -i 's/root::0:0:99999:7:::/root:$1$xUooaZpA$6zs50xt4ac9sJXiYpycT3\/:19338:0:99999:7:::/g' package/base-files/files/etc/shadow

## 添加源和软件
#echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/linkease package/linkease
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/jerrykuku/luci-theme-argon package/luci-theme-argon
# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn

##修改openwrt的include/target.mk文件
sed -i 's/libustream-wolfssl/libustream-openssl/g' include/target.mk
sed -i 's/dnsmasq/dnsmasq-full iptables/g' include/target.mk
sed -i 's/firewall4/firewall4 block-mount coremark/g' include/target.mk
sed -i 's/nftables/nftables curl ca-certificates/g' include/target.mk
sed -i 's/odhcp6c/odhcp6c iptables-mod-tproxy iptables-mod-extra ipset ip-full default-settings luci luci-newapi/g' include/target.mk
sed -i 's/odhcpd-ipv6only/odhcpd-ipv6only ddns-scripts_aliyun ddns-scripts_dnspod/g' include/target.mk

##修改openwrt/target/linux/x86的Makefile文件
sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-mmc kmod-sdhci kmod-fs-f2fs cfdisk usbutils pciutils kmod-mlx4-core kmod-mlx5-core kmod-drm-i915 kmod-drm-amdgpu kmod-sound-hda-intel kmod-sound-hda-codec-hdmi kmod-sound-i8x0 kmod-usb-audio/g' target/linux/x86/Makefile
sed -i 's/partx-utils mkf2fs/partx-utils mkf2fs kmod-alx kmod-e1000e kmod-igb kmod-igc kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-via-velocity kmod-vmxnet3 kmod-i40e kmod-i40evf kmod-r8125 kmod-8139cp kmod-8139too kmod-tg3/g' target/linux/x86/Makefile
sed -i 's/e2fsprogs kmod-button-hotplug/e2fsprogs kmod-button-hotplug htop lm-sensors iperf3 autocore-x86 kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152-vendor kmod-usb-net-aqc111/g' target/linux/x86/Makefile
sed -i 's/grub2-bios-setup/kmod-sound-hda-core kmod-sound-hda-codec-realtek kmod-sound-hda-codec-via kmod-sound-via82xx luci-app-filetransfer luci-app-openclash luci-app-istorex luci-app-udpxy luci-app-upnp/g' target/linux/x86/Makefile
