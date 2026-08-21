#!/bin/bash
#
# 此脚本在 feeds update 之前运行
#

# 替换 feeds 源为国内镜像，加速下载
sed -i 's_https://github.com/openwrt/packages_https://github.com.cnpmjs.org/openwrt/packages_g' feeds.conf.default
sed -i 's_https://github.com/openwrt/luci_https://github.com.cnpmjs.org/openwrt/luci_g' feeds.conf.default
sed -i 's_https://github.com/openwrt/routing_https://github.com.cnpmjs.org/openwrt/routing_g' feeds.conf.default

# 更新 feeds
./scripts/feeds update -a

# 修复 umdns 问题
rm -f package/network/services/umdns/files/umdns.init
rm -f package/network/services/umdns/files/umdns.json
wget -q -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.init
wget -q -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.json

./scripts/feeds install -a

# 修复 libpcre 依赖
sed -i 's/+libpcre/+libpcre2/g' package/feeds/telephony/freeswitch/Makefile || true
