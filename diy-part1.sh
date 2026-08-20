#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

function merge_package() {
    if [[ $# -lt 3 ]]; then
        echo "Syntax error: [$#] [$*]" >&2
        return 1
    fi
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

./scripts/feeds update -a

# fix : ubus_call_umdns()=ubus.c@1385
rm package/network/services/umdns/files/umdns.init
rm package/network/services/umdns/files/umdns.json
wget -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.init
wget -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.json

./scripts/feeds install -a

# 修复feeds错误
sed -i 's/+libpcre/+libpcre2/g' package/feeds/telephony/freeswitch/Makefile

./scripts/feeds update -a
./scripts/feeds install -a
