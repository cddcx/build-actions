## 修改密码
sed -i 's/root:::0:99999:7:::/root:$1$xUooaZpA$6zs50xt4ac9sJXiYpycT3\/:19338:0:99999:7:::/g' package/base-files/files/etc/shadow

## 添加源和软件
#echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/linkease package/linkease
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/jerrykuku/luci-theme-argon package/luci-theme-argon
# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn

## 修改openwrt的include/target.mk文件
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i 's/firewall4/firewall/g' include/target.mk
sed -i 's/nftables/iptables ip6tables default-settings luci luci-compat/g' include/target.mk
sed -i 's/kmod-nft-offload/luci luci-compat wget-ssl curl ca-certificates htop default-settings/g' include/target.mk

## 修改openwrt/target/linux/x86的Makefile文件
sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-ath5k kmod-ath9k kmod-ath9k-htc kmod-ath10k kmod-rt2800-usb kmod-e1000e kmod-igb kmod-igbvf kmod-igc kmod-ixgbe kmod-pcnet32 kmod-tulip kmod-vmxnet3 kmod-i40e kmod-i40evf kmod-r8125 kmod-8139cp kmod-8139too kmod-fs-f2fs/g' target/linux/x86/Makefile
sed -i 's/mkf2fs/mkf2fs fdisk lm-sensors autocore-x86 ath10k-firmware-qca988x ath10k-firmware-qca9888 ath10k-firmware-qca9984 brcmfmac-firmware-43602a1-pcie/g' target/linux/x86/Makefile
sed -i 's/e2fsprogs/e2fsprogs alsa-utils kmod-ac97 kmod-sound-hda-core kmod-sound-hda-codec-realtek kmod-sound-hda-codec-via kmod-sound-via82xx kmod-usb-audio/g' target/linux/x86/Makefile
sed -i 's/grub2-bios-setup/grub2-bios-setup kmod-usb-net kmod-usb-net-asix kmod-usb-net-asix-ax88179 kmod-usb-net-ipheth kmod-usb-net-rndis kmod-usb-net-rtl8150 kmod-usb-net-rtl8152 uci-app-openclash luci-app-istorex luci-app-udpxy luci-app-upnp/g' target/linux/x86/Makefile
