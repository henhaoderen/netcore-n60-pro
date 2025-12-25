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

#sed -i 's/cmake_minimum_required(VERSION 3.31.0)/cmake_minimum_required(VERSION 3.30.5)/' /path/to/CMakeLists.txt
# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git timecontrol https://github.com/sirpdboy/luci-app-timecontrol' >>feeds.conf.default

# 添加passwall
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git' >>feeds.conf.default

# echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default
# echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 添加 OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter package/OpenAppFilter
# 添加 Openclash
# git clone https://github.com/vernesong/OpenClash package/luci-app-openclash
# 下载 PassWall 源码（版本号已替换为25.11.15-1）
# wget https://github.com/xiaorouji/openwrt-passwall/archive/refs/tags/25.11.15-1.zip
# unzip 25.11.15-1.zip
# cp -r openwrt-passwall-25.11.15-1/ package/passwall
# 添加 Openclash1
# wget https://github.com/vernesong/OpenClash/archive/v0.47.028.zip
# unzip v0.47.028.zip
# cp -r OpenClash-0.47.028/luci-app-openclash package
# Add ADGuardHome source
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
chmod -R 755 ./package/luci-app-adguardhome/*
