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

echo "开始 DIY1 配置……"
echo "========================="

#chmod +x ${GITHUB_WORKSPACE}/subscript.sh
#source ${GITHUB_WORKSPACE}/subscript.sh

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo "src-git dpdk_repo https://github.com/k13132/openwrt-dpdk" >> feeds.conf.default

# 网络设置向导
#git clone https://github.com/sirpdboy/luci-app-netwizard package/luci-app-netwizard

# 酷猫主题
#git clone -b js https://github.com/sirpdboy/luci-theme-kucat package/luci-theme-kucat

# 新版 进价设置
#git clone https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus

# uci-app-partexp 一键自动格式化分区、扩容、自动挂载插件
#git clone https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp

# DPDK & NUMACTL
#merge_package master https://github.com/sbwml/r4s_build_script package/new openwrt/patch/dpdk/dpdk
#merge_package master https://github.com/sbwml/r4s_build_script package/new openwrt/patch/dpdk/numactl

## autocore automount default-settings
merge_package master https://github.com/immortalwrt/immortalwrt package/emortal package/emortal/default-settings
#git clone https://github.com/cddcx/default-settings.git package/emortal/default-settings

# luci-app-homeproxy luci-app-passwall luci-app-passwall2
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld
rm -rf package/helloworld/daed
rm -rf package/helloworld/luci-app-daed
rm -rf package/helloworld/luci-app-ssr-plus
rm -rf package/helloworld/luci-app-nikki
rm -rf package/helloworld/nikki

# luci-app-daed
git clone https://github.com/QiuSimons/luci-app-daed package/dae
# 依赖
merge_package openwrt-24.10 https://github.com/immortalwrt//packages package/libs libs/libcron

# luci-app-nikki
merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld luci-app-nikki
merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld nikki

# bpf - add host clang-15/18/20 support
sed -i 's/clang-13/clang-15 clang-18 clang-20/g' include/bpf.mk

# luci-app-passwall
#merge_package main https://github.com/xiaorouji/openwrt-passwall package luci-app-passwall

# luci-app-passwall2
#merge_package main https://github.com/xiaorouji/openwrt-passwall2 package luci-app-passwall2

# 核心包
#git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
#rm -rf package/passwall-packages/{chinadns-ng，dns2socks，dns2tcp，hysteria，ipt2socks，microsocks，naiveproxy，shadowsocks-rust，shadowsocksr-libev，simple-obfs，sing-box}
#rm -rf package/passwall-packages/{tcping，trojan-plus，trojan，tuic-client，v2ray-core，v2ray-geodata，v2ray-plugin，xray-core，xray-plugin}
#merge_package v5 https://github.com/sbwml/openwrt_helloworld package/passwall-packages chinadns-ng dns2socks dns2tcp hysteria ipt2socks microsocks naiveproxy shadowsocks-rust shadowsocksr-libev simple-obfs sing-box
#merge_package v5 https://github.com/sbwml/openwrt_helloworld package/passwall-packages tcping trojan-plus，trojan, tuic-client v2ray-core v2ray-geodata v2ray-plugin xray-core xray-plugin

echo "========================="
echo " DIY1 配置完成……"
