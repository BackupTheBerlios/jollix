#!/bin/sh
#         ## create-initrd ###
#
#  This script builds an initial ramdisk (initrd)
#  that is put in cvsroot/jollix/CD/isolinux 
#  Use as root from cvsroot/jollix directory 

source skripte/settings
install -d cdroot-initrd
dd if=/dev/zero of=initrd bs=1k count=3000
mke2fs -F -q -N3000 initrd
mount -t ext2 -o loop initrd cdroot-initrd
install -d cdroot-initrd/{bin,etc,usr,proc,tmp,keymaps}	
ln -s bin cdroot-initrd/sbin
ln -s ../bin cdroot-initrd/usr/bin
ln -s ../bin cdroot-initrd/usr/sbin
cp ${SRC_INITRD}/*.map cdroot-initrd/keymaps
(mkdir cdroot-initrd/dev;cd cdroot-initrd/dev;MAKEDEV generic-i386;MAKEDEV scd)
cat > cdroot-initrd/etc/fstab <<EOF
/dev/ram0       /             cramfs defaults
proc            /proc         proc   defaults  0 0
EOF
install -m755 ${SRC_INITRD}/linuxrc cdroot-initrd
cp ${BUSYBOX_DIR}/busybox cdroot-initrd/bin 
# Generate busybox links. We really do not need all of them but its good to
# have a fall back in case we need them someday.
for i in '[' ash basename cat chroot clear cp dirname echo env false find \
    grep gunzip gzip insmod ln ls loadkmap losetup lsmod mkdir mknod modprobe more mount mv \
    pivot_root ps pwd rm rmdir rmmod sh sleep tar test touch true umount uname \
    xargs yes zcat chmod chown; do 
  rm -f cdroot-initrd/bin/$i
  ln cdroot-initrd/bin/busybox cdroot-initrd/bin/$i 
done 
install -d cdroot-initrd/modules/storage
cp ${CLOOP_DIR}/cloop_ucl.o cdroot-initrd/modules/cloop.o 

## SCSI Module erstmal weglassen
#for i in $STORAGE_MODULES
#  do
#  ## !!! woher???? !!! ####
#  mymod=`find /lib/modules -name "${i}.o"`
#  if [ -z "${mymod}" ]
#      then
#      echo "Error: ${i}.o not found; skipping..."
#      continue
#  fi
#  cp $mymod cdroot-initrd/modules/storage
#done
##tweak our storage module settings based on our initrd
#cat ${SRC_INITRD}/linuxrc | sed "s/##STORAGE_MODULES##/${STORAGE_MODULES}/" > cdroot-initrd/linuxrc
chmod +x cdroot-initrd/linuxrc
umount cdroot-initrd
gzip -f -9 initrd
mv initrd.gz ${LIVECD_DIR}/isolinux/initrd
rmdir cdroot-initrd