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
# 方案：以 mtwifi-cfg 为主 —— /sbin/l1util 与 /sbin/l1dat 由它自带的
#       Lua 版提供，l1parser 里的 CLI 安装行去掉。
#       包本身保留，+l1util 依赖照样满足，
#       libl1parser / ucode-mod-l1parser 不受影响。
# ===========================================================================
MK=package/mtk/applications/l1parser/Makefile
sed -i '/usr\/bin\/l1util/d;/LN) l1util/d' $MK

if grep -q 'usr/bin/l1util' $MK; then
	echo "ERROR: l1parser 补丁未生效，Makefile 可能已改版，请人工确认"
	exit 1
fi

echo "OK: l1parser 不再安装 l1util/l1dat，改由 mtwifi-cfg 自带的 Lua 版提供"
sed -n '/Package\/l1util\/install/,/endef/p' $MK
