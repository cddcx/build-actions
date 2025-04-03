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

 #网络设置向导
#git clone https://github.com/sirpdboy/luci-app-netwizard package/luci-app-netwizard

# 酷猫主题
#git clone -b js https://github.com/sirpdboy/luci-theme-kucat package/luci-theme-kucat

# 新版 进价设置
#git clone https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus

# luci-app-partexp 一键自动格式化分区、扩容、自动挂载插件
#git clone https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp

# luci-app-homeproxy
git clone https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy           ####### homeproxy的默认版本(二选一) 
#git clone -b dev https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
merge_package v5 https://github.com/sbwml/openwrt_helloworld  package/luci-app-homeproxy chinadns-ng sing-box
sed -i "s@ImmortalWrt@OpenWrt@g" package/luci-app-homeproxy/po/zh_Hans/homeproxy.po
sed -i "s@ImmortalWrt proxy@OpenWrt proxy@g" package/luci-app-homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

## luci-app-passwall
merge_package main https://github.com/xiaorouji/openwrt-passwall package luci-app-passwall

# luci-app-nikki
merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld luci-app-nikki
merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld nikki

# 取消挂载点
sed -i '#block-mount \#d' package/emortal/automount/Makefile

# bpf - add host clang-15/18/20 support
sed -i 's/command -v clang/command -v clang clang-18 clang-20/g' include/bpf.mk

# luci-theme-kucat
#git clone -b js https://github.com/sirpdboy/luci-theme-kucat.git package/luci-theme-kucat
#sed -i '/set luci.main.mediaurlbase*/d' package/luci-theme-kucat/root/etc/uci-defaults/30_luci-kucat

# SmartDNS
#git clone --depth=1 https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
#git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

echo "========================="
echo " DIY1 配置完成……"
