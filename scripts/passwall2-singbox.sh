#!/bin/bash

mkdir -p files/usr/share/singbox

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.db"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dbt"

wget -qO- $GEOIP_URL > ffiles/usr/share/singbox/GeoIP.dat
wget -qO- $GEOSITE_URL > files/usr/share/singbox/GeoSite.dat

chmod +x ffiles/usr/share/singbox/geo*
