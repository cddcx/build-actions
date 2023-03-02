## 删除软件
#rm -rf feeds/luci/theme/luci-theme-argon
#rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/packages/net/adguardhome
#rm -rf feeds/packages/net/smartdns

##配置IP
#sed -i 's/192.168.1.1/192.168.100.101/g' package/base-files/files/bin/config_generate

##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

##把nas-packages-luci的zh-cn替换成zh_Hans
#sed -i 's/("QuickStart")/("首页")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
#sed -i 's/("NetworkGuide")/("向导")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
#sed -i 's/("RAID")/("磁盘阵列")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
#sed -i 's/("NetworkPort")/("网口配置")/g' package/linkease/nas-packages-luci/luci-app-quickstart/luasrc/controller/quickstart.lua
#cp -af package/linkease/nas-packages-luci/luci-app-quickstart/po/zh-cn package/linkease/nas-packages-luci/luci-app-quickstart/po/zh_Hans
