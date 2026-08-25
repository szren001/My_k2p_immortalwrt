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

# 设置最大连接数为硬件支持的合理值
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=32768' package/base-files/files/etc/sysctl.conf

# 修改默认主题为 bootstrap
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i "s/luci-static\/argon/luci-static\/bootstrap/g" feeds/luci/modules/luci-base/root/etc/config/luci

# ========== 设置默认 WiFi（通过 uci-defaults 脚本） ==========
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-custom-wifi << 'EOF'
#!/bin/sh
# 设置 2.4G WiFi
uci set wireless.radio0.disabled='0'
uci set wireless.default_radio0.ssid='LZY8'
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.key='lizhiyang0928'

# 设置 5G WiFi
uci set wireless.radio1.disabled='0'
uci set wireless.default_radio1.ssid='LZY'
uci set wireless.default_radio1.encryption='psk2'
uci set wireless.default_radio1.key='lizhiyang0928'

uci commit wireless
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-custom-wifi

# ========== 强制开启内核 Flow Offload 支持 ==========
echo "CONFIG_NF_FLOW_TABLE=y" >> target/linux/ramips/mt7621/config-5.4
