#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================
# 添加源
echo "src-git xiangfeidexiaohuo https://github.com/xiangfeidexiaohuo/openwrt-packages" >>  feeds.conf.default
svn co https://github.com/Lienol/openwrt-package/branches/other/lean ./package/lean #添加lean
