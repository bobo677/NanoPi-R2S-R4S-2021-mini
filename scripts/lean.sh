#!/bin/bash

# Add luci-app-ssr-plus
pushd package/lean
git clone --depth=1 https://github.com/fw876/helloworld
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall


# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash


# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon


# Add dafeiji
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/lean/luci-app-cpufreq
svn co https://github.com/281677160/openwrt-package/trunk/cpulimit
svn co https://github.com/281677160/openwrt-package/trunk/luci-app-cpulimit


# Add luci-app-wireguard
svn co https://github.com/openwrt/luci/trunk/applications/luci-app-wireguard

# Add CPUInfo
#pushd feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:CPU Temperature%></td><td><%=luci.sys.exec("cut -c1-2 /sys/class/thermal/thermal_zone0/temp")%><span>&#8451;</span></td></tr>' index.htm
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:欢迎订阅 Youbube 频道%></td><td><a href="https://www.youtube.com"><%:YOURENAME%></a></td></tr>' index.htm


# Add luci-app-linkease
pushd package/network/services
git clone --depth=1 https://github.com/linkease/linkease-openwrt
popd

# Add Pandownload
pushd package/lean
svn co https://github.com/immortalwrt/immortalwrt/trunk/package/lean/pandownload-fake-server
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
export orig_version="$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')"
sed -i "s/${orig_version}/${orig_version} ($(date +"%Y.%m.%d"))/g" zzz-default-settings
popd

# Fix libssh
pushd feeds/packages/libs
rm -rf libssh
svn co https://github.com/openwrt/packages/trunk/libs/libssh
popd


# Use snapshots syncthing package
pushd feeds/packages/utils
rm -rf syncthing
svn co https://github.com/openwrt/packages/trunk/utils/syncthing
popd

# Add po2lmo
git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/10.10.101.2/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='FusionWrt'' package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /DHDAXCW build $(TZ=UTC-8 date "+%Y.%m.%d") @ FusionWrt /g" package/lean/default-settings/files/zzz-default-settings
# sed -i "s/FILES:=$(LINUX_DIR)/net/can/can-dev.ko/FILES:=$(LINUX_DIR)/drivers/net/can/dev/can-dev.ko \ package/kernel/linux/modules/can.mk

# Custom configs
# git am $GITHUB_WORKSPACE/patches/lean/*.patch
echo -e " DHDAXCW's FusionWrt built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> package/base-files/files/etc/banner

# Add CUPInfo
pushd package/lean/autocore/files/arm/sbin
cp -f $GITHUB_WORKSPACE/scripts/cpuinfo cpuinfo
popd
