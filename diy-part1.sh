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
# 检查并添加 iStore 应用商店源（避免重复）
if ! grep -q "src-git istore" feeds.conf.default; then
    echo "src-git istore https://github.com/linkease/istore.git;main" >> feeds.conf.default
    echo "已添加 iStore 源"
fi

# 检查并添加 iStoreOS packages 源（包含 quickstart 等核心组件）
if ! grep -q "src-git istoreos_packages" feeds.conf.default; then
    echo "src-git istoreos_packages https://github.com/istoreos/istoreos.git;istoreos-24.10" >> feeds.conf.default
    echo "已添加 iStoreOS packages 源"
fi

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git timecontrol https://github.com/sirpdboy/luci-app-timecontrol' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default
# echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 添加 OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter package/OpenAppFilter
# 添加 Openclash
# git clone https://github.com/vernesong/OpenClash package/luci-app-openclash
# Add ADGuardHome source
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
chmod -R 755 ./package/luci-app-adguardhome/*
