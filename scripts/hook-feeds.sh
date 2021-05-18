#!/bin/bash
#=================================================
# File name: hook-feeds.sh
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Svn checkout packages from immortalwrt's repository
pushd customfeeds

# Add luci-app-adguardhome
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-adguardhome luci/applications/luci-app-adguardhome
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/adguardhome packages/net/adguardhome
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/lang/node-yarn packages/lang/node-yarn
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/devel/packr packages/devel/packr


# Add tmate
git clone --depth=1 https://github.com/immortalwrt/openwrt-tmate

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall luci/applications/openwrt-passwall

# Add gotop
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/admin/gotop packages/admin/gotop


# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
