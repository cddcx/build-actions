#!/bin/bash
#=================================================
shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))
function git_clone_path() {
          branch="$1" rurl="$2" localdir="gitemp" && shift 2
          git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
          if [ "$?" != 0 ]; then
            echo "error on $rurl"
            return 0
          fi
          cd $localdir
          git sparse-checkout init --cone
          git sparse-checkout set $@
          mv -n $@/* ../$@/ || cp -rf $@ ../$(dirname "$@")/
		  cd ..
		  rm -rf gitemp
          }

## default-settings
#mkdir -p package/emortal/default-settings
#git_clone_path master https://github.com/immortalwrt/immortalwrt package/emortal/default-settings
git clone https://github.com/cddcx/default-settings.git package/emortal/default-settings

## luci-app-filetransfer
#git clone https://github.com/cddcx/luci-app-filetransfer.git package/luci-app-filetransfer
#sed -i 's@../../luci.mk@$(TOPDIR)/feeds/luci/luci.mk@g' package/luci-app-filetransfer/Makefile
# luci-app-filetransfer依赖luci-lib-fs
#git clone https://github.com/cddcx/luci-lib-fs.git package/luci-lib-fs

## luci-app-v2raya
#git clone https://github.com/v2rayA/v2raya-openwrt package/v2raya-openwrt
#rm -rf package/v2raya-openwrt/{v2raya,xray-core}

## luci-app-homeproxy
#git clone https://github.com/immortalwrt/homeproxy package/homeproxy           ####### homeproxy的默认版本(二选一)
#git clone -b dev https://github.com/immortalwrt/homeproxy package/homeproxy     ####### homeproxy的dev版本(二选一)  
#sed -i "s@ImmortalWrt@OpenWrt@g" package/homeproxy/po/zh_Hans/homeproxy.po
#sed -i "s@ImmortalWrt proxy@OpenWrt proxy@g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

## luci-app-passwall
git_clone_path main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2
cp -rf luci-app-passwall2 package/luci-app-passwall2
rm -rf luci-app-passwall2
#svn checkout https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall

## luci-app-openclash
#git clone https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
