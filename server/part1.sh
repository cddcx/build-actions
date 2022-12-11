#!/bin/bash

svn co https://github.com/coolsnowwolf/lede/trunk/tools/ucl tools/ucl
svn co https://github.com/coolsnowwolf/lede/trunk/tools/upx tools/upx
sed -i 'N;24a\tools-y += ucl upx' tools/Makefile
sed -i 'N;40a\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile

# luci-theme-opentopd主题
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
rm -rf package/luci-theme-opentopd/README*
rm -rf package/luci-theme-opentopd/doc/

# luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
rm -rf package/luci-app-openclash/.svn

# 软件中心istore
git clone https://github.com/linkease/istore.git package/istore
git clone https://github.com/linkease/istore-ui.git package/istore-ui
sed -i 's/luci-lib-ipkg/luci-base/g' package/istore/luci/luci-app-store/Makefile
sed -i 's/("iStore"), 31/("应用商店"), 61/g' package/istore/luci/luci-app-store/luasrc/controller/store.lua
