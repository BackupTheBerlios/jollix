#!/bin/sh
#         ## create-initrd ###
#
#  This script builds an initial ramdisk (initrd)
#  Use as root from cvsroot/jollix directory
# Copyright 2004 jollix
# Jochen Spang <knochestolle@web.de>
# Oliver Schwinn <patteh@web.de>
# Distributed under the terms of the GNU General Public License, v2 or later

source skripte/settings
install -d cdroot-initrd
dd if=/dev/zero of=initrd bs=1k count=6000
mke2fs -F -q -N6000 initrd
mount -t ext2 -o loop initrd cdroot-initrd
install -d cdroot-initrd/{bin,etc,usr,proc,tmp,keymaps,modules}	
ln -s bin cdroot-initrd/sbin
ln -s ../bin cdroot-initrd/usr/bin
ln -s ../bin cdroot-initrd/usr/sbin
(mkdir cdroot-initrd/dev;cd cdroot-initrd/dev;MAKEDEV generic-i386;MAKEDEV scd)

cat > cdroot-initrd/etc/fstab <<EOF
/dev/ram0       /             cramfs defaults
proc            /proc         proc   defaults  0 0
EOF

install -m755 ${WORK_DIR}/skripte/linuxrc_squashfs cdroot-initrd/linuxrc
cp ${BUSYBOX_DIR}/busybox cdroot-initrd/bin 
cp ${UTILLINUX_DIR}/sbin/losetup cdroot-initrd/bin
# insmod.static hack!!!
cp ${UTILLINUX_DIR}/insmod.static cdroot-initrd/bin
ln -s insmod.static cdroot-initrd/bin/insmod
ln -s insmod.static cdroot-initrd/bin/kallsysms
ln -s insmod.static cdroot-initrd/bin/ksyms
ln -s insmod.static cdroot-initrd/bin/lsmod
ln -s insmod.static cdroot-initrd/bin/modprobe
ln -s insmod.static cdroot-initrd/bin/rmmod

for i in '[' ash basename cat chroot clear cp dirname echo env false find \
    grep gunzip gzip init ln ls loadkmap mkdir mknod more mount mv \
    pivot_root ps pwd rm rmdir sh sleep tar test touch true umount uname \
    xargs yes zcat chmod chown; do 
  rm -f cdroot-initrd/bin/$i
  ln cdroot-initrd/bin/busybox cdroot-initrd/bin/$i 
done 

chmod +x cdroot-initrd/linuxrc
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/crypto/ucl.ko cdroot-initrd/modules/
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/block/*.ko cdroot-initrd/modules/
SCSI
mkdir cdroot-initrd/modules/storage
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/scsi/*.ko cdroot-initrd/modules/storage/
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/scsi/aic7xxx/*.ko cdroot-initrd/modules/storage/
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/scsi/pcmcia/*.ko cdroot-initrd/modules/storage/
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/scsi/qla2xxx/*.ko cdroot-initrd/modules/storage/
cp ${JOLLIX_DIR}/lib/modules/2.6*/kernel/drivers/scsi/sym53c8xx_2/*.ko cdroot-initrd/modules/storage/
umount cdroot-initrd
splash -s -f /mnt/hdb1/etc/bootsplash/personal/config/bootsplash-1024x768.cfg >> ${WORK_DIR}/initrd
#for bootsplash initrd without gzip compression
#gzip -f -9 initrd
mv initrd ${LIVECD_DIR}/isolinux/initrd
rmdir cdroot-initrd
