#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

cat > feeds.conf.default <<EOF
src-git packages https://github.com/immortalwrt/packages.git;master
src-git luci https://github.com/immortalwrt/luci.git;master
src-git routing https://github.com/openwrt/routing.git;master
src-git telephony https://github.com/openwrt/telephony.git;master
src-git helloworld https://github.com/fw876/helloworld
EOF



# Add ADGuardHome source
#git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
#chmod -R 755 ./package/luci-app-adguardhome/*

wget -O /tmp/argon.tar.gz https://github.com/jerrykuku/luci-theme-argon/archive/refs/tags/v2.4.3.tar.gz
tar -xzf /tmp/argon.tar.gz -C package/
mv package/luci-theme-argon-2.4.3 package/luci-theme-argon
