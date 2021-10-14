#!/bin/bash

set -x

yum install https://zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm -y
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
yum-config-manager --disable zfs
yum-config-manager --enable zfs-kmod
yum install zfs -y
modprobe zfs
zpool create storage sdb cache sde
zpool status storage
zfs create storage/opt -o mountpoint=/opt
touch /opt/file{1..20}
ls /opt
zfs snapshot storage/opt@snap01
rm -f /opt/*
ls /opt
zfs rollback storage/opt@snap01
ls /opt
zfs destroy storage/opt@snap01
