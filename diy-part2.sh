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

# 设置最大连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=32768' package/base-files/files/etc/sysctl.conf

# 修改默认主题为 bootstrap
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i "s/luci-static\/argon/luci-static\/bootstrap/g" feeds/luci/modules/luci-base/root/etc/config/luci

# ========== 写入正确的 WiFi 配置 ==========
mkdir -p package/base-files/files/etc/config
cat > package/base-files/files/etc/config/wireless << 'EOF'
config wifi-device 'radio0'
        option type 'mac80211'
        option path '1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0'
        option channel '1'
        option band '2g'
        option htmode 'HT40'
        option country 'CN'
        option disabled '0'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'LZY8'
        option encryption 'psk2'
        option key 'lizhiyang0928'

config wifi-device 'radio1'
        option type 'mac80211'
        option path '1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0+1'
        option channel '36'
        option band '5g'
        option htmode 'VHT80'
        option country 'CN'
        option disabled '0'

config wifi-iface 'default_radio1'
        option device 'radio1'
        option network 'lan'
        option mode 'ap'
        option ssid 'LZY'
        option encryption 'psk2'
        option key 'lizhiyang0928'
EOF

# ========== 强制开启内核 Flow Offload 支持（硬件加速） ==========
echo "CONFIG_NF_FLOW_TABLE=y" >> target/linux/ramips/mt7621/config-5.4
