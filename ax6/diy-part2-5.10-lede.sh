#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2-5.10-lede.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# https://github.com/deplives/OpenWrt-CI-RC/blob/main/second.sh
# https://github.com/jarod360/Redmi_AX6/blob/main/diy-part2.sh

COMMIT_COMMENT=$1
if [ -z "$COMMIT_COMMENT" ]; then
    COMMIT_COMMENT='Unknown'
fi

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/ntp.aliyun.com/ntp.ntsc.ac.cn/g' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/ntp.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/cn.ntp.org.cn/g' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/pool.ntp.org/g' package/base-files/files/bin/config_generate

# Modify default LAN ip
echo 'Modify default LAN IP...'
sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate

# 修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# Ax6修改无线国家代码、命名、加密方式及密码
sed -i 's/radio${devidx}.country=US/radio${devidx}.country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/radio${devidx}.ssid=OpenWrt/radio0.ssid=MERCURY_8888\n\t\t\tset wireless.default_radio1.ssid=MERCURY_8888_2.4G\n\t\t\tset wireless.default_radio1.hidden=1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/radio${devidx}.encryption=none/radio${devidx}.encryption=sae-mixed\n\t\t\tset wireless.default_radio${devidx}.key=824080252/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default banner
echo 'Modify default banner...'
build_date=$(date +"%Y-%m-%d %H:%M:%S")
echo "                                                               " > package/base-files/files/etc/banner
echo " ██████╗ ██████╗ ███████╗███╗   ██╗██╗    ██╗██████╗ ████████╗ " >>package/base-files/files/etc/banner
echo "██╔═══██╗██╔══██╗██╔════╝████╗  ██║██║    ██║██╔══██╗╚══██╔══╝ " >>package/base-files/files/etc/banner
echo "██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║ █╗ ██║██████╔╝   ██║    " >>package/base-files/files/etc/banner
echo "██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║███╗██║██╔══██╗   ██║    " >>package/base-files/files/etc/banner
echo "╚██████╔╝██║     ███████╗██║ ╚████║╚███╔███╔╝██║  ██║   ██║    " >>package/base-files/files/etc/banner
echo " ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝    " >>package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >>package/base-files/files/etc/banner
echo " %D %C ${build_date} by hnyyghk                                " >>package/base-files/files/etc/banner
echo " $COMMIT_COMMENT                                               " >>package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >>package/base-files/files/etc/banner
echo "                                                               " >>package/base-files/files/etc/banner
