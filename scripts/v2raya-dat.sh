#!/bin/bash

mkdir -p files/usr/share/xray

GEOIP_URL="https://github.com/v2fly/geoip/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"

wget -qO- $GEOIP_URL > files/usr/share/xray/geoip.dat
wget -qO- $GEOSITE_URL > files/usr/share/xray/geosite.dat

#chmod +x files/usr/share/xray/*
