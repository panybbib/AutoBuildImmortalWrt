#!/bin/bash

# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"
# yml 传入是否需要编译 Docker 插件
echo "Include Docker: $INCLUDE_DOCKER"

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."

# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES arptables-nft"
PACKAGES="$PACKAGES bash"
PACKAGES="$PACKAGES blkid"
PACKAGES="$PACKAGES ca-certificates"
PACKAGES="$PACKAGES cfdisk"
PACKAGES="$PACKAGES coreutils"
PACKAGES="$PACKAGES coreutils-base64"
PACKAGES="$PACKAGES coreutils-timeout"
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES e2fsprogs"
PACKAGES="$PACKAGES f2fs-tools"
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES iperf3-ssl"
PACKAGES="$PACKAGES jq"
PACKAGES="$PACKAGES kmod-crypto-acompress"
PACKAGES="$PACKAGES kmod-fs-autofs4"
PACKAGES="$PACKAGES kmod-fs-exfat"
PACKAGES="$PACKAGES kmod-fs-ext4"
PACKAGES="$PACKAGES kmod-inet-diag"
PACKAGES="$PACKAGES kmod-ipt-fullconenat"
PACKAGES="$PACKAGES kmod-ipt-nat"
PACKAGES="$PACKAGES kmod-ipt-nat6"
PACKAGES="$PACKAGES kmod-ipt-raw"
PACKAGES="$PACKAGES kmod-ipt-tproxy"
PACKAGES="$PACKAGES kmod-lib-lz4"
PACKAGES="$PACKAGES kmod-lib-lzo"
PACKAGES="$PACKAGES kmod-lib-zstd"
PACKAGES="$PACKAGES kmod-netlink-diag"
PACKAGES="$PACKAGES kmod-nft-arp"
PACKAGES="$PACKAGES kmod-nft-bridge"
PACKAGES="$PACKAGES kmod-nft-connlimit"
PACKAGES="$PACKAGES kmod-nft-dup-inet"
PACKAGES="$PACKAGES kmod-nft-fib"
PACKAGES="$PACKAGES kmod-nft-netdev"
PACKAGES="$PACKAGES kmod-nft-queue"
PACKAGES="$PACKAGES kmod-nft-tproxy"
PACKAGES="$PACKAGES kmod-nft-xfrm"
PACKAGES="$PACKAGES kmod-tun"
PACKAGES="$PACKAGES libcap"
PACKAGES="$PACKAGES libcap-bin"
PACKAGES="$PACKAGES libext2fs"
PACKAGES="$PACKAGES losetup"
PACKAGES="$PACKAGES lsblk"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-app-autoreboot"
PACKAGES="$PACKAGES luci-app-ddns-go"
PACKAGES="$PACKAGES luci-app-diskman"
PACKAGES="$PACKAGES luci-app-homeproxy"
PACKAGES="$PACKAGES luci-app-minidlna"
PACKAGES="$PACKAGES luci-app-msd_lite"
PACKAGES="$PACKAGES luci-app-mwan3"
PACKAGES="$PACKAGES luci-app-nft-qos"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-app-pppoe-relay"
PACKAGES="$PACKAGES luci-app-ramfree"
PACKAGES="$PACKAGES luci-app-smartdns"
PACKAGES="$PACKAGES luci-app-syncdial"
PACKAGES="$PACKAGES luci-app-ttyd"
PACKAGES="$PACKAGES luci-app-unblockneteasemusic"
PACKAGES="$PACKAGES luci-app-upnp"
PACKAGES="$PACKAGES luci-app-watchcat"
PACKAGES="$PACKAGES luci-app-wol"
PACKAGES="$PACKAGES luci-app-wifischedule"
PACKAGES="$PACKAGES luci-app-zerotier"
PACKAGES="$PACKAGES luci-base"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-autoreboot-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES luci-i18n-minidlna-zh-cn"
PACKAGES="$PACKAGES luci-i18n-msd_lite-zh-cn"
PACKAGES="$PACKAGES luci-i18n-mwan3-zh-cn"
PACKAGES="$PACKAGES luci-i18n-nft-qos-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-pppoe-relay-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ramfree-zh-cn"
PACKAGES="$PACKAGES luci-i18n-smartdns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
PACKAGES="$PACKAGES luci-i18n-watchcat-zh-cn"
PACKAGES="$PACKAGES luci-i18n-wol-zh-cn"
PACKAGES="$PACKAGES luci-i18n-wifischedule-zh-cn"
PACKAGES="$PACKAGES luci-i18n-zerotier-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES mount-utils"
PACKAGES="$PACKAGES mwan3"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES openssl-util"
PACKAGES="$PACKAGES parted"
PACKAGES="$PACKAGES resize2fs"
PACKAGES="$PACKAGES ruby"
PACKAGES="$PACKAGES ruby-yaml"
PACKAGES="$PACKAGES smartdns"
PACKAGES="$PACKAGES smartmontools"
PACKAGES="$PACKAGES tree"
PACKAGES="$PACKAGES wget-ssl"
PACKAGES="$PACKAGES wifischedule"
PACKAGES="$PACKAGES zram-swap"

# 增加几个组件方便安装iStore
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"

# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-app-dockerman"
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
