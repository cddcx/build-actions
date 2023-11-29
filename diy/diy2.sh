#!/bin/bash
#=================================================
# DIY script
# jsjson@163.com 
#=================================================             

# 修改内核
sed -i 's/PATCHVER:=*.*/PATCHVER:=6.1/g' target/linux/x86/Makefile 
