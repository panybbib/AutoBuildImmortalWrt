#!/bin/sh
# immortalwrt固件首次启动时运行的脚本位于固件内的/etc/uci-defaults/

# 设置默认防火墙规则，方便虚拟机首次访问 WebUI
uci set firewall.@zone[1].input='ACCEPT'

# 设置主机名映射，解决安卓原生 TV 无法联网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"

# LAN口设置静态IP
uci set network.lan.proto='static'
uci set network.lan.ipaddr='192.168.2.254'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='192.168.2.1'
uci set network.lan.broadcast='192.168.10.255'

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci commit

# 设置编译作者信息
FILE_PATH="/etc/openwrt_release"
NEW_DESCRIPTION="Compiled by pany"
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='$NEW_DESCRIPTION'/" "$FILE_PATH"

exit 0
