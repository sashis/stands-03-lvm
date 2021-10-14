#!/bin/bash

set -x
# reducing the volume to 8G - stage 2
# -----------------------------------

# recreate a 8G volume

lvremove -y VolGroup00/LogVol00
lvcreate -y -L 8G -n LogVol00 VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt

# return all the data back to the volume

xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/ <<"EOF"
grub2-mkconfig -o /boot/grub2/grub.cfg
dracut --force /boot/initramfs-$(uname -r).img $(uname -r)


# place /var to the mirrored volume
# ---------------------------------

# create a LVM mirror volume

pvcreate/dev/sd{c,d}
vgcreate vg_var /dev/sd{c,d}
lvcreate -L 950M -m1 -n lv_var vg_var

# move current /var to the new volume

mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
cp -aR /var/* /mnt/
rm -rf /var/*
sync
umount /mnt

# mount the volume to /var and add auto-mount

mount /dev/vg_var/lv_var /var
echo "$(blkid /dev/vg_var/lv_var | cut -d' ' -f2) /var ext4 defaults 0 0" >> /etc/fstab
EOF

