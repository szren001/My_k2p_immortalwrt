#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.8.8.8/g' package/base-files/files/bin/config_generate

# Modify default password (empty)
sed -i 's/root::0:0:99999:7:::/root::0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Modify default Hostname
sed -i 's/ImmortalWrt/k2p/g' package/base-files/files/bin/config_generate

# 设置最大连接数为硬件支持的合理值（MT7621 硬件 FoE 表为 16384，此处设为 32768）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=32768' package/base-files/files/etc/sysctl.conf

# 修改默认主题为 bootstrap
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i "s/luci-static\/argon/luci-static\/bootstrap/g" feeds/luci/modules/luci-base/root/etc/config/luci

# 修改默认WiFi名称和密码 (2.4G: LZY8, 5G: LZY, 密码: lizhiyang0928)
sed -i 's/ssid=OpenWrt/ssid=LZY8/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ssid=OpenWrt-5G/ssid=LZY/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/key=12345678/key=lizhiyang0928/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# ========== 强制开启内核 Flow Offload 支持 ==========
echo "CONFIG_NF_FLOW_TABLE=y" >> target/linux/ramips/mt7621/config-5.4
