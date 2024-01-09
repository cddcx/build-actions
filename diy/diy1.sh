#!/bin/bash
#=================================================
shopt -s extglob

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

## automount与default-settings
mkdir -p package/emortal/automount
git_clone_path master https://github.com/immortalwrt/immortalwrt package/emortal/automount
mkdir -p package/emortal/default-settings
git_clone_path master https://github.com/immortalwrt/immortalwrt package/emortal/default-settings
#git clone https://github.com/cddcx/default-settings.git package/emortal/default-settings

## docker
mkdir -p utils/docker
git_clone_path master https://github.com/immortalwrt/packages utils/docker
mkdir -p utils/dockerd
git_clone_path master https://github.com/immortalwrt/packages utils/dockerd
mkdir -p utils/docker-compose
git_clone_path master https://github.com/immortalwrt/packages utils/docker-compose
mkdir -p applications/luci-app-dockerman
git_clone_path master https://github.com/immortalwrt/luci applications/luci-app-dockerman

## 磁盘管理
mkdir -p applications/luci-app-diskma
git_clone_path master https://github.com/immortalwrt/luci applications/luci-app-diskman

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

## luci-app-passwall2
mkdir -p luci-app-passwall2
git_clone_path main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2
cp -rf luci-app-passwall2 package/luci-app-passwall2
rm -rf luci-app-passwall2
#svn checkout https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall

## luci-app-openclash
#git_clone_path master https://github.com/vernesong/OpenClash luci-app-openclash
#cp -rf luci-app-openclash package/luci-app-openclash
#rm -rf luci-app-openclash
