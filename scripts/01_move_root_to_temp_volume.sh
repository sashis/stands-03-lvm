#!/bin/bash

set -x
yum install xfsdump -y

# reducing the volume to 8G - stage 1
# -----------------------------------

# create a temporary volume

pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l+100%FREE vg_root
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt

# move data to the volume and make it bootable

xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/ << EOF
grub2-mkconfig -o /boot/grub2/grub.cfg
dracut --force /boot/initramfs-$(uname -r).img $(uname -r)
sed -i "s:rd.lvm.lv=VolGroup00/LogVol00:rd.lvm.lv=vg_root/lv_root:" /boot/grub2/grub.cfg
EOF

