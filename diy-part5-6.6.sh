#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part5-6.6.sh
# Description: OpenWrt DIY script part 5 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
# 添加组播防火墙规则
#cat >> package/network/config/firewall/files/firewall.config <<EOF
#config rule
#        option name 'Allow-UDP-igmpproxy'
#        option src 'wan'
#        option dest 'lan'
#        option dest_ip '224.0.0.0/4'
#        option proto 'udp'
#        option target 'ACCEPT'
#        option family 'ipv4'
#
#config rule
#        option name 'Allow-UDP-udpxy'
#        option src 'wan'
#        option dest_ip '224.0.0.0/4'
#        option proto 'udp'
#        option target 'ACCEPT'
#EOF

#   却没有定义 IMAGE_SIZE。Build/check-size 里
#       limitsize="$$(($(call exp_units,$(if $(1),$(1),$(IMAGE_SIZE)))))"
#   空值展开成 0，于是判 22544384 > 0 超限，顺手 rm -f $@ 把 factory.bin 删了。
#   同文件里其它 6 个 *-mtkuboot 设备全都写了 IMAGE_SIZE := 114688k（112 MiB），
#   而本机 ubi 分区 0x7280000 = 117248 KiB，留了余量，照抄 114688k 即可。
# ===========================================================================
FE=target/linux/mediatek/image/filogic-ext.mk

if ! grep -q 'Device/netcore_n60-pro-mtkuboot' $FE; then
	echo "ERROR: 找不到 Device/netcore_n60-pro-mtkuboot，上游可能已改名，请人工确认"
	exit 1
fi

if sed -n '/^define Device\/netcore_n60-pro-mtkuboot$/,/^endef$/p' $FE | grep -q '^  IMAGE_SIZE :='; then
	echo "SKIP: netcore_n60-pro-mtkuboot 已有 IMAGE_SIZE"
else
	sed -i '/^define Device\/netcore_n60-pro-mtkuboot$/,/^endef$/ s|^\(  DEVICE_DTS_DIR := \.\./dts-ext\)$|\1\n  IMAGE_SIZE := 114688k|' $FE
fi

if sed -n '/^define Device\/netcore_n60-pro-mtkuboot$/,/^endef$/p' $FE | grep -q '^  IMAGE_SIZE :='; then
	echo "OK: netcore_n60-pro-mtkuboot 已补 IMAGE_SIZE := 114688k"
else
	echo "ERROR: IMAGE_SIZE 补丁未生效，factory.bin 仍会被删除"
	exit 1
fi
sed -n '/^define Device\/netcore_n60-pro-mtkuboot$/,/^endef$/p' $FE
