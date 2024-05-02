#!/bin/bash

mkdir -p files/usr/share/singbox

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.db"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dbt"

wget -qO- $GEOIP_URL > files/usr/share/singbox/geoip.dat
wget -qO- $GEOSITE_URL > files/usr/share/singbox/geosite.dat

chmod +x ffiles/usr/share/singbox/geo*
