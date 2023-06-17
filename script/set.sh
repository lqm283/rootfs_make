#!/bin/bash
###
 # @Author: your name
 # @Date: 2021-03-25 11:38:19
 # @LastEditTime: 2022-03-07 15:18:12
 # @LastEditors: lqm283
 # @Description: In User Settings Edit
 # @FilePath: /rootfs_make/script/set.sh
###

chmod 777 /tmp

echo y | apt update

echo y | apt upgrade

apt install sudo language-pack-en-base vim ssh net-tools parted \
            iputils-ping rsyslog htop libusb-1.0-0 kmod watchdog \
            resolvconf netplan.io git gcc make udev xinit xterm \
            lxdm

passwd root

adduser lqm

chmod u+w /etc/sudoers

#在root ALL=(ALL:ALL) ALL下方添加 lqm ALL=(ALL) ALL
sed -i '/# User privilege specification/a\lqm   ALL=(ALL) ALL' /etc/sudoers

#去掉sudoers文件的写权限
chmod u-w /etc/sudoers

#对家目录进行授权
chown lqm:lqm -R /home/lqm

#修改根目录的权限
chmod 0755 /

#设置主机名称和本机IP
echo "VeryArk" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.0.1 VeryArk" >> /etc/hosts

#设置DNS
echo "nameserver 8.8.8.8"  >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.4.4"  >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 1.1.1.1"  >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 202.103.225.68"  >> /etc/resolvconf/resolv.conf.d/head

#设置go的路径
echo "PATH=$PATH:/usr/local/go/bin" >> /etc/profile

#配置DHCP
echo auto eth0 > /etc/network/interfaces.d/eth0
echo iface eth0 inet dhcp >> /etc/network/interfaces.d/eth0

#允许root用户远程登录
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# 卸载临时应用
echo y | apt remove  git gcc make
echo y | apt autoremove

#清除配置根文件系统时传入的临时文件
rm -rf redis
rm qemu-arm-static
rm /bin/set.sh

echo "Set done!"

exit