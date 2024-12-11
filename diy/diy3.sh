#!/bin/bash
#=================================================

# 拉取仓库文件夹
function merge_package() {
	# 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
	# 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
	# 示例:
	# merge_package master https://github.com/WYC-2020/openwrt-packages package/openwrt-packages luci-app-eqos luci-app-openclash luci-app-ddnsto ddnsto 
	# merge_package master https://github.com/lisaac/luci-app-dockerman package/lean applications/luci-app-dockerman
	if [[ $# -lt 3 ]]; then
		echo "Syntax error: [$#] [$*]" >&2
		return 1
	fi
	trap 'rm -rf "$tmpdir"' EXIT
	branch="$1" curl="$2" target_dir="$3" && shift 3
	rootdir="$PWD"
	localdir="$target_dir"
	[ -d "$localdir" ] || mkdir -p "$localdir"
	tmpdir="$(mktemp -d)" || exit 1
	git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
	cd "$tmpdir"
	git sparse-checkout init --cone
	git sparse-checkout set "$@"
	# 使用循环逐个移动文件夹
	for folder in "$@"; do
		mv -f "$folder" "$rootdir/$localdir"
	done
	cd "$rootdir"
}

function drop_package(){
	find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}

function merge_feed(){
	./scripts/feeds update $1
	./scripts/feeds install -a -p $1
}

echo "开始 DIY2 配置……"
echo "========================="

#chmod +x ${GITHUB_WORKSPACE}/subscript.sh
#source ${GITHUB_WORKSPACE}/subscript.sh

# 修改内核
#sed -i 's/PATCHVER:=*.*/PATCHVER:=6.6/g' target/linux/x86/Makefile 

##. 默认ip
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

## 修改密码
sed -i 's@root:::0:99999:7:::@root:$1$/n/cF0jQ$ffjS0OFp8jH5zPyfdOJvq/:19692:0:99999:7:::@g' package/base-files/files/etc/shadow

# 取消主题默认设置
#find feeds/luci/themes/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/*mediaurlbase*/d' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-argon/luci-theme-kucat/g' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' {} \;

# 最大连接数修改为65535
#sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修复上移下移按钮翻译
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# 修复procps-ng-top导致首页cpu使用率无法获取
sed -i 's#top -n1#\/bin\/busybox top -n1#g' feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci

# ppp - 2.5.0
rm -rf package/network/services/ppp
git clone https://github.com/sbwml/package_network_services_ppp package/network/services/ppp

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 修复编译时提示 freeswitch 缺少 libpcre 依赖
sed -i 's/+libpcre \\$/+libpcre2 \\/g' package/feeds/telephony/freeswitch/Makefile

# 替换udpxy为修改版，解决组播源数据有重复数据包导致的花屏和马赛克问题
rm -rf feeds/packages/net/udpxy/Makefile
#curl -sfL https://raw.githubusercontent.com/lwb1978/OpenWrt-Actions/main/patch/udpxy/Makefile -o feeds/packages/net/udpxy/Makefile
cp -rf ${GITHUB_WORKSPACE}/patch/udpxy/Makefile feeds/packages/net/udpxy/
#rm -rf feeds/luci/applications/luci-app-udpxy/po
#cp -rf ${GITHUB_WORKSPACE}/patch/luci-app-udpxy/po feeds/luci/applications/luci-app-udpxy/po

# 精简 UPnP 菜单名称
sed -i 's#\"title\": \"UPnP IGD \& PCP/NAT-PMP\"#\"title\": \"UPnP\"#g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json
# 移动 UPnP 到 “网络” 子菜单
sed -i 's/services/network/g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

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
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += luci-app-passwall2 luci-app-mihomo luci-app-udpxy /g' target/linux/x86/Makefile

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

## 删除
rm -rf feeds/luci/applications/{luci-app-v2raya,luci-app-shadowsocks-libev}
rm -rf feeds/packages/net/{v2raya,microsocks,shadowsocks-libev}

# 修正部分从第三方仓库拉取的软件 Makefile 路径问题
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

export mirror=raw.githubusercontent.com/sbwml/r4s_build_script/master
export gitea=git.cooluc.com
export github=github.com

# 编译luci-app-daed所需内核模块
# 依赖
#merge_package main https://github.com/kenzok8/small-package package/helloworld libcron
merge_package master https://github.com/immortalwrt/packages/libs packages/libs libcron

## 启用 eBPF 支持
# bpf
#curl -s https://$mirror/openwrt/generic/config-bpf >> .config
echo '# x86_64
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y
# CONFIG_TARGET_IMAGES_GZIP is not set
CONFIG_TARGET_KERNEL_PARTSIZE=80
CONFIG_TARGET_ROOTFS_PARTSIZE=600
# CONFIG_TARGET_ROOTFS_TARGZ is not set

### BPF
CONFIG_DEVEL=y
CONFIG_BPF_TOOLCHAIN_HOST=y
# CONFIG_BPF_TOOLCHAIN_NONE is not set
CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_KERNEL_CGROUP_BPF=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y
# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set
CONFIG_KERNEL_MODULE_ALLOW_BTF_MISMATCH=y
CONFIG_KERNEL_XDP_SOCKETS=y

### BPF Kernel Modules
CONFIG_PACKAGE_kmod-sched-core=y
CONFIG_PACKAGE_kmod-sched-bpf=y
CONFIG_PACKAGE_kmod-xdp-sockets-diag=y

# DPDK
CONFIG_PACKAGE_dpdk-tools=y
CONFIG_PACKAGE_numactl=y

# Kernel - CLANG LTO
CONFIG_KERNEL_CC="clang-15"
CONFIG_EXTRA_OPTIMIZATION=""
# CONFIG_PACKAGE_kselftests-bpf is not set
' >>  ./.config

# patch source
curl -s $mirror/openwrt/patch/generic-24.10/0001-tools-add-upx-tools.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0002-rootfs-add-upx-compression-support.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0003-rootfs-add-r-w-permissions-for-UCI-configuration-fil.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0004-rootfs-Add-support-for-local-kmod-installation-sourc.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0005-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0006-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0007-include-kernel-add-miss-config-for-linux-6.11.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0008-meson-add-platform-variable-to-cross-compilation-fil.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0009-kernel-add-legacy-cgroup-v1-memory-controller.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-24.10/0010-kernel-add-PREEMPT_RT-support-for-aarch64-x86_64.patch | patch -p1

### clang
# xtables-addons module
rm -rf feeds/packages/net/xtables-addons
git clone https://github.com/sbwml/kmod_packages_net_xtables-addons feeds/packages/net/xtables-addons
# netatop
sed -i 's/$(MAKE)/$(KERNEL_MAKE)/g' feeds/packages/admin/netatop/Makefile
merge_package master https://github.com/sbwml/r4s_build_script package-patches openwrt/patch/packages-patches/clang
cp -rf package-patches/clang/netatop/900-fix-build-with-clang.patch feeds/packages/admin/netatop/patches/
# macremapper
patch -p1 < package-patches/clang/macremapper/100-macremapper-fix-clang-build.patch
# coova-chilli module
rm -rf feeds/packages/net/coova-chilli
git clone https://github.com/sbwml/kmod_packages_net_coova-chilli feeds/packages/net/coova-chilli

# DPDK & NUMACTL
mkdir -p package/new/{dpdk/patches,numactl}
curl -s $mirror/openwrt/patch/dpdk/dpdk/Makefile > package/new/dpdk/Makefile
curl -s $mirror/openwrt/patch/dpdk/dpdk/Config.in > package/new/dpdk/Config.in
curl -s $mirror/openwrt/patch/dpdk/dpdk/patches/010-dpdk_arm_build_platform_fix.patch > package/new/dpdk/patches/010-dpdk_arm_build_platform_fix.patch
curl -s $mirror/openwrt/patch/dpdk/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch > package/new/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch
curl -s $mirror/openwrt/patch/dpdk/numactl/Makefile > package/new/numactl/Makefile

# kselftests-bpf
#curl -s https://$mirror/openwrt/patch/packages-patches/kselftests-bpf/Makefile > package/devel/kselftests-bpf/Makefile
rm -rf package/devel/kselftests-bpf/Makefile
merge_package master https://github.com/sbwml/r4s_build_script package/devel openwrt/patch/packages-patches/kselftests-bpf

# 拷贝自定义文件
#if [ -n "$(ls -A "${GITHUB_WORKSPACE}/immortalwrt/diy" 2>/dev/null)" ]; then
	#cp -Rf ${GITHUB_WORKSPACE}/immortalwrt/diy/* .
#fi

# 自定义默认配置
sed -i '/exit 0$/d' package/emortal/default-settings/files/99-default-settings
cat ${GITHUB_WORKSPACE}/default-settings >> package/emortal/default-settings/files/99-default-settings

./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
