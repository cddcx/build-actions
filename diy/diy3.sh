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
sed -i 's/PATCHVER:=*.*/PATCHVER:=6.6/g' target/linux/x86/Makefile 

##. 默认ip
#sed -i 's/*.*.*.*/192.168.1.1/g' package/base-files/files/bin/config_generate

## 修改密码
#sed -i 's@root:::0:99999:7:::@root:$1$pfsE8FKB$tnZcDcV8vUTqxJpwXLzZv1:19690:0:99999:7:::@g' package/base-files/files/etc/shadow
sed -i 's@root:::0:99999:7:::@root:$1$/n/cF0jQ$ffjS0OFp8jH5zPyfdOJvq/:19692:0:99999:7:::@g' package/base-files/files/etc/shadow

# 取消主题默认设置
#find feeds/luci/themes/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/*mediaurlbase*/d' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-argon/luci-theme-kucat/g' {} \;
#find feeds/luci/collections/*/* -type f -name 'Makefile' -print -exec sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' {} \;

# 修复上移下移按钮翻译
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

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
sed -i 's/DEFAULT_PACKAGES += /DEFAULT_PACKAGES += luci-app-upnp luci-app-udpxy luci-app-homeproxy luci-app-passwall2 /g' target/linux/x86/Makefile

## 删除
rm -rf feeds/luci/applications/luci-app-v2raya
rm -rf feeds/packages/net/v2raya
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

# curl/8.5.0 - fix passwall `time_pretransfer` check
#rm -rf feeds/packages/net/curl
#git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

# 修正部分从第三方仓库拉取的软件 Makefile 路径问题
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# firewall4 add custom nft command support
curl -s https://$mirror/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1

# firewall4 Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & ipv6-nat & custom nft command option
export mirror=raw.githubusercontent.com/sbwml/r4s_build_script/master
pushd feeds/luci
	curl -s https://$mirror/openwrt/patch/firewall4/02-luci-app-firewall_add_shortcut-fe.patch | patch -p1
	curl -s https://$mirror/openwrt/patch/firewall4/03-luci-app-firewall_add_ipv6-nat.patch | patch -p1
	curl -s https://$mirror/openwrt/patch/firewall4/04-luci-add-firewall4-nft-rules-file.patch | patch -p1
	# 状态-防火墙页面去掉iptables警告，并添加nftables、iptables标签页
	curl -s https://$mirror/openwrt/patch/luci/luci-nftables.patch | patch -p1
popd

# 补充 firewall4 luci 中文翻译
cat >> "feeds/luci/applications/luci-app-firewall/po/zh_Hans/firewall.po" <<-EOF
	
	msgid ""
	"Custom rules allow you to execute arbitrary nft commands which are not "
	"otherwise covered by the firewall framework. The rules are executed after "
	"each firewall restart, right after the default ruleset has been loaded."
	msgstr ""
	"自定义规则允许您执行不属于防火墙框架的任意 nft 命令。每次重启防火墙时，"
	"这些规则在默认的规则运行后立即执行。"
	
	msgid ""
	"Applicable to internet environments where the router is not assigned an IPv6 prefix, "
	"such as when using an upstream optical modem for dial-up."
	msgstr ""
	"适用于路由器未分配 IPv6 前缀的互联网环境，例如上游使用光猫拨号时。"

	msgid "NFtables Firewall"
	msgstr "NFtables 防火墙"

	msgid "IPtables Firewall"
	msgstr "IPtables 防火墙"
EOF

# 自定义默认配置
sed -i '/exit 0$/d' package/emortal/default-settings/files/99-default-settings
cat ${GITHUB_WORKSPACE}/default-settings >> package/emortal/default-settings/files/99-default-settings

# 拷贝自定义文件
#if [ -n "$(ls -A "${GITHUB_WORKSPACE}/immortalwrt/diy" 2>/dev/null)" ]; then
	#cp -Rf ${GITHUB_WORKSPACE}/immortalwrt/diy/* .
#fi


echo "========================="
echo " DIY2 配置完成……"
