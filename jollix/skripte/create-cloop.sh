#!/bin/sh
#            ### create-cloop ###
#
#  This script builds a compressed loopback archive (cloop),
#  that contains the jollix system.
#  Use as root from cvsroot/jollix directory 

source skripte/settings

# 1.
install -d looproot
dd if=/dev/zero of=livecd.loop bs=1k count=1800000
mke2fs -F -q livecd.loop
mount -t ext2 -o loop livecd.loop looproot 
cp -a ${JOLLIX_DIR}/* looproot

# 1.5 
sleep 3

# 2.
umount looproot
cat livecd.loop | ${CLOOP_DIR}/create_compressed_ucl_fs - 131072 > ${LIVECD_DIR}/livecd.cloop
rm -fr looproot livecd.loop

