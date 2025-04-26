#!/bin/bash
#
# 版权所有（c）2019-2020 P3TERX <https://p3terx.com>
#
# 本软件是自由软件，遵循 MIT 许可证。
# 更多信息请参见 /LICENSE。
#
# https://github.com/P3TERX/Actions-OpenWrt
# 文件名: diy-part1.sh
# 描述: OpenWrt DIY 脚本第一部分（更新 feeds 之前）
#



# 取消注释一个 feed 源
# sed -i "/helloworld/d" "feeds.conf.default"

# 添加一个 feed 源
# echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# luci-app-daed
#git clone https://github.com/QiuSimons/luci-app-daed package/dae
# 依赖
#merge_package openwrt-24.10 https://github.com/immortalwrt//packages package/libs libs/libcron

# luci-app-nikki
#merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld luci-app-nikki
#merge_package main https://github.com/nikkinikki-org/OpenWrt-nikki package/helloworld nikki

# bpf - add host clang-15/18/20 support
sed -i 's/command -v clang/command -v clang clang-15 clang-18 clang-20/g' include/bpf.mk
