## 添加源和软件
#sed -i 's@.*src-git-full packages*@#&@g' feeds.conf.default
#echo 'src-git-full packages https://github.com/kiddin9/openwrt-packages.git;master' >> feeds.conf.default
#echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default

#svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/linkease package/linkease
#rm -rf package/linkease/preview

# 修改内核
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/x86/Makefile

## 主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon

#git clone https://github.com/fw876/helloworld package/ssr
#echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default

# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn
#git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# luci-app-passwall2
#svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2

## 修改openwrt的include/target.mk文件
curl -sfL https://raw.githubusercontent.com/immortalwrt/immortalwrt/master/include/target.mk -o include/target.mk
#sed -i "s/DEFAULT_PACKAGES:=/DEFAULT_PACKAGES:=luci-app-firewall luci-app-opkg luci-app-udpxy luci-app-upnp luci-app-openclash \
luci-base luci-compat ipset luci-lib-ipkg luci-lib-fs \
coremark wget-ssl curl autocore htop nano zram-swap kmod-lib-zstd kmod-tcp-bbr bash luci \
openssh-sftp-server block-mount resolveip ds-lite swconfig /" include/target.mk
sed -i "s/procd-ujail//" include/target.mk

## 修改openwrt/target/linux/x86的Makefile文件
curl -sfL https://raw.githubusercontent.com/immortalwrt/immortalwrt/master/target/linux/x86/Makefile -o target/linux/x86/Makefile
sed -i 's/automount/autocore default-settings ipset luci luci-compat luci-app-udpxy luci-app-upnp luci-app-openclash/g' target/linux/x86/Makefile
#sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-mmc kmod-sdhci usbutils pciutils \
lm-sensors-detect kmod-alx kmod-vmxnet3 kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip \
kmod-r8125 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-i915 kmod-drm-amdgpu \
kmod-mlx4-core kmod-mlx5-core fdisk lsblk kmod-phy-broadcom/' target/linux/x86/Makefile
