#!/bin/bash

mkdir -p files/usr/share/singbox
#mkdir -p files/usr/share/v2ray

GEOIP_URL1="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.db"
GEOSITE_URL1="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.db"
#GEOIP_URL2="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"
#GEOSITE_URL2="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"

wget -qO- $GEOIP_URL1 > files/usr/share/singbox/geoip.db
wget -qO- $GEOSITE_URL1 > files/usr/share/singbox/geosite.db
#wget -qO- $GEOIP_URL2 > files/usr/share/v2ray/geoip.dat
#wget -qO- $GEOSITE_URL2 > files/usr/share/v2ray/geosite.dat

#chmod +x files/usr/share/singbox/geo*
