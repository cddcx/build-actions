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

git_clone_path openwrt-22.03 https://github.com/openwrt/openwrt package/network/utils/iptables
