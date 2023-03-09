## 修改密码
sed -i 's/root:::0:99999:7:::/root:$1$xUooaZpA$6zs50xt4ac9sJXiYpycT3\/:19338:0:99999:7:::/g' package/base-files/files/etc/shadow

## 添加源和软件
#sed -i 's@.*src-git-full packages*@#&@g' feeds.conf.default
#echo 'src-git-full packages https://github.com/kiddin9/openwrt-packages.git;master' >> feeds.conf.default
#echo 'src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages;master' >> feeds.conf.default

#svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/linkease package/linkease
#rm -rf package/linkease/preview

git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon

git clone https://github.com/fw876/helloworld package/ssr
#echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default

# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn
#git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash

## 修改openwrt的include/target.mk文件
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk
sed -i 's/nftables/ip6tables iptables/g' include/target.mk 
sed -i "s/DEFAULT_PACKAGES:=/DEFAULT_PACKAGES:=luci-app-firewall luci-app-opkg luci-base luci-compat luci-lib-ipkg luci-lib-fs libcap libcap-bin default-settings-chn luci \
coremark wget-ssl curl htop nano zram-swap kmod-lib-zstd kmod-tcp-bbr bash openssh-sftp-server block-mount resolveip ds-lite swconfig \
iptables-mod-extra ip6tables-mod-nat /" include/target.mk

##修改openwrt/target/linux/x86的Makefile文件
sed -i "s/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += autocore-x86 kmod-usb-hid kmod-mmc kmod-sdhci usbutils pciutils lm-sensors-detect kmod-alx kmod-vmxnet3 kmod-igbvf \
kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-r8125 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-i915 kmod-drm-amdgpu kmod-mlx4-core kmod-mlx5-core fdisk lsblk \
kmod-phy-broadcomv luci-app-openclash luci-app-ssr-plus luci-app-udpxy luci-app-upnp /" target/linux/x86/Makefile
