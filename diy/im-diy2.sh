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

# 默认IP
#sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改内核
#sed -i 's/PATCHVER:=*.*/PATCHVER:=6.6/g' target/linux/x86/Makefile

# 修改密码
sed -i 's/root:::0:99999:7:::/root:$1$SOP5eWTA$fJV8ty3QohO0chErhlxCm1:18775:0:99999:7:::/g' package/base-files/files/etc/shadow

# 修复上移下移按钮翻译
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# 修复procps-ng-top导致首页cpu使用率无法获取
sed -i 's#top -n1#\/bin\/busybox top -n1#g' feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci

# ppp - 2.5.0
rm -rf package/network/services/ppp
git clone https://github.com/sbwml/package_network_services_ppp package/network/services/ppp

# golang 1.22.0
rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 修复编译时提示 freeswitch 缺少 libpcre 依赖
sed -i 's/+libpcre \\$/+libpcre2 \\/g' package/feeds/telephony/freeswitch/Makefile

# 替换udpxy为修改版，解决组播源数据有重复数据包导致的花屏和马赛克问题
rm -rf feeds/packages/net/udpxy/Makefile
curl -sfL https://raw.githubusercontent.com/lwb1978/OpenWrt-Actions/main/patch/udpxy/Makefile -o feeds/packages/net/udpxy/Makefile
#rm -rf feeds/luci/applications/luci-app-udpxy/po
#cp -rf ${GITHUB_WORKSPACE}/patch/luci-app-udpxy/po feeds/luci/applications/luci-app-udpxy/po

# 精简 UPnP 菜单名称
sed -i 's#\"title\": \"UPnP IGD \& PCP/NAT-PMP\"#\"title\": \"UPnP\"#g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json
# 移动 UPnP 到 “网络” 子菜单
sed -i 's/services/network/g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# 替换udpxy为修改版，解决组播源数据有重复数据包导致的花屏和马赛克问题
#rm -rf feeds/packages/net/udpxy/Makefile
#curl -sfL https://raw.githubusercontent.com/lwb1978/OpenWrt-Actions/main/patch/udpxy/Makefile -o feeds/packages/net/udpxy/Makefile
# 修改 udpxy 菜单名称为大写
#sed -i 's#\"title\": \"udpxy\"#\"title\": \"UDPXY\"#g' feeds/luci/applications/luci-app-udpxy/root/usr/share/luci/menu.d/luci-app-udpxy.json

# TTYD 自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
# TTYD 更改
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# 修改include/target.mk
sed -i "s/DEFAULT_PACKAGES.router:=/DEFAULT_PACKAGES.router:=default-settings-chn luci-app-opkg /" include/target.mk
sed -i "s/kmod-nft-offload/kmod-nft-offload kmod-nft-tproxy/" include/target.mk

# 修改target/linux/x86/Makefile
sed -i 's/automount/luci-app-advancedplus luci-theme-kucat luci-app-netwizard luci-app-mihomo luci-app-passwall2 luci-app-udpxy/g' target/linux/x86/Makefile

## 删除软件
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome
#rm -rf feeds/luci/themes/luci-theme-bootstrap
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/{luci-app-homeproxy,luci-app-v2raya,luci-app-shadowsocks-libev}
rm -rf feeds/packages/net/{v2raya,shadowsocks-libev}

# 移除luci-app-passwall及核心
rm -rf feeds/luci/applications/luci-app-passwall
# 核心
rm -rf feeds/packages/net/{brook,chinadns-ng,dns2socks,dns2tcp,gn,hysteria,ipt2socks,microsocks,naiveproxy,pdnsd-alt,shadowsocks-rust,shadowsocksr-libev,simple-obfs}
rm -rf feeds/packages/net/{sing-box,tcping,trojan-go,trojan-plus,trojan,tuic-client,v2ray-core,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}

## luci-app-passwall2
#merge_package main https://github.com/xiaorouji/openwrt-passwall package luci-app-passwall
merge_package main https://github.com/xiaorouji/openwrt-passwall2 package luci-app-passwall2

# 核心
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
rm -rf package/passwall-packages/{chinadns-ng,dns2socks,dns2tcp,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box}
rm -rf package/passwall-packages/{tcping,trojan,trojan-plus,tuic-client,v2ray-core,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin}
merge_package v5 https://github.com/sbwml/openwrt_helloworld  package/passwall-packages chinadns-ng dns2socks dns2tcp hysteria ipt2socks microsocks naiveproxy shadowsocks-rust shadowsocksr-libev simple-obfs sing-box
merge_package v5 https://github.com/sbwml/openwrt_helloworld  package/passwall-packages tcping trojan-plus trojan tuic-client v2ray-core v2ray-geodata v2ray-plugin xray-core xray-plugin

# 修正部分从第三方仓库拉取的软件 Makefile 路径问题
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# luci-app-daed
rm -rf feeds/luci/applications/luci-app-daed
rm -rf feeds/packages/net/daed
git clone https://github.com/QiuSimons/luci-app-daed package/dae

# 编译luci-app-daed所需内核模块
# .config
echo '
# x86_64
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
CONFIG_KERNEL_CC="clang-18"
CONFIG_EXTRA_OPTIMIZATION=""
# CONFIG_PACKAGE_kselftests-bpf is not set
' >>  ./.config

export mirror=raw.githubusercontent.com/sbwml/r4s_build_script/master
export gitea=git.cooluc.com
export github=github.com

# 下载patch
merge_package master https://github.com/sbwml/r4s_build_script package-patch openwrt/patch/generic-24.10
merge_package master https://github.com/sbwml/r4s_build_script package-patch openwrt/patch/packages-patches/clang

# patch source
#patch -p1 < package-patch/generic-24.10/0001-tools-add-upx-tools.patch
#patch -p1 < package-patch/generic-24.10/0002-rootfs-add-upx-compression-support.patch
#patch -p1 < package-patch/generic-24.10/0003-rootfs-add-r-w-permissions-for-UCI-configuration-fil.patch
#patch -p1 < package-patch/generic-24.10/0004-rootfs-Add-support-for-local-kmod-installation-sourc.patch
#patch -p1 < package-patch/generic-24.10/0005-kernel-Add-support-for-llvm-clang-compiler.patch
#patch -p1 < package-patch/generic-24.10/0006-build-kernel-add-out-of-tree-kernel-config.patch
#patch -p1 < package-patch/generic-24.10/0007-include-kernel-add-miss-config-for-linux-6.11.patch
#patch -p1 < package-patch/generic-24.10/0008-meson-add-platform-variable-to-cross-compilation-fil.patch
#patch -p1 < package-patch/generic-24.10/0009-kernel-add-legacy-cgroup-v1-memory-controller.patch
#patch -p1 < package-patch/generic-24.10/0010-kernel-add-PREEMPT_RT-support-for-aarch64-x86_64.patch

# kselftests-bpf
#curl -s https://$mirror/openwrt/patch/packages-patches/kselftests-bpf/Makefile > package/devel/kselftests-bpf/Makefile
rm -rf package/devel/kselftests-bpf/Makefile
merge_package master https://github.com/sbwml/r4s_build_script package/devel openwrt/patch/packages-patches/kselftests-bpf

### clang
# xtables-addons module
rm -rf feeds/packages/net/xtables-addons
git clone https://$github/sbwml/kmod_packages_net_xtables-addons feeds/packages/net/xtables-addons
# netatop
sed -i 's/$(MAKE)/$(KERNEL_MAKE)/g' feeds/packages/admin/netatop/Makefile
#curl -s $mirror/openwrt/patch/packages-patches/clang/netatop/900-fix-build-with-clang.patch > feeds/packages/admin/netatop/patches/900-fix-build-with-clang.patch
cp -rf package-patch/clang/netatop/900-fix-build-with-clang.patch feeds/packages/admin/netatop/patches/900-fix-build-with-clang.patch
# dmx_usb_module
rm -rf feeds/packages/libs/dmx_usb_module
git clone https://$gitea/sbwml/feeds_packages_libs_dmx_usb_module feeds/packages/libs/dmx_usb_module
# macremapper
patch -p1 < package-patch/clang/macremapper/100-macremapper-fix-clang-build.patch
# coova-chilli module
rm -rf feeds/packages/net/coova-chilli
git clone https://$github/sbwml/kmod_packages_net_coova-chilli feeds/packages/net/coova-chilli

# 删除patch
rm -rf package-patch

./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
