#!/bin/bash

mkdir -p files/usr/share/singbox

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.db"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.db"

wget -qO- $GEOIP_URL > files/usr/share/singbox/geoip.db
wget -qO- $GEOSITE_URL > files/usr/share/singbox/geosite.db

chmod +x files/usr/share/singbox/geo*
