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

# ===========================================================================
# 修复 mtwifi-cfg 与 l1parser 重复安装 /sbin/l1util、/sbin/l1dat 的打包冲突
#
#   mtwifi-cfg/Makefile  自带 files/l1util/l1util（Lua 脚本）+ ln l1dat
#   l1parser/Makefile    产出 l1util 包（C++ CLI）        + ln l1dat
#   两者路径相同 -> apk 报 "trying to overwrite sbin/l1dat owned by l1util"
#
# 处理：保留 l1parser 的 C++ 版，去掉 mtwifi-cfg 的 Lua 副本，
#       并在 DEPENDS 里补 +l1util（后面 make defconfig 会自动选回该包）。
# ===========================================================================
MTWIFI_CFG_MK="package/mtk/applications/mtwifi-cfg/Makefile"

if [ -f "$MTWIFI_CFG_MK" ]; then
	sed -i -e '/files\/l1util\/l1util \$(1)\/sbin\//d' \
	       -e '/\$(LN) l1util \$(1)\/sbin\/l1dat/d' "$MTWIFI_CFG_MK"

	grep -q '+l1util' "$MTWIFI_CFG_MK" || \
		sed -i 's/@!PACKAGE_luci-app-mtk/+l1util @!PACKAGE_luci-app-mtk/' "$MTWIFI_CFG_MK"

	if grep -q 'files/l1util/l1util' "$MTWIFI_CFG_MK"; then
		echo "ERROR: mtwifi-cfg 补丁未生效，Makefile 可能已改版，请人工确认"
		exit 1
	fi

	echo "OK: mtwifi-cfg 不再安装 l1util/l1dat，改由 l1parser 的 l1util 包提供"
	sed -n '/Package\/mtwifi-cfg/,/endef/p' "$MTWIFI_CFG_MK"
else
	echo "ERROR: 未找到 $MTWIFI_CFG_MK（当前目录 $(pwd)）"
	exit 1
fi
