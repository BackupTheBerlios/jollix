#!/bin/sh
#            ### prepare-cloop ###
#
#  This script prepares jollix to be clooped.
#  Use as root from cvsroot/jollix directory.

source skripte/settings

# cp ${JOLLIX_DIR}/lib/modules/misc/cloop.o -> CD/isolinux/initrd
# cp ${JOLLIX_DIR}/boot/vmlinuz-2.4.20-gaming-r3 -> CD/isolinux/jollix
# todo: scsi module nach initrd

# cleaning jollix tree
echo "0. cleaning jollix ..."
rm -fr ${JOLLIX_DIR}/tmp/*
rm -fr ${JOLLIX_DIR}/tmp/.*
rm -fr ${JOLLIX_DIR}/root/.*
rm -fr ${JOLLIX_DIR}/root/Desktop
rm -f ${JOLLIX_DIR}/etc/atigamer
rm -f ${JOLLIX_DIR}/home/user/.bash_history
#chown -R user ${JOLLIX_DIR}/home/user
#chgrp -R users ${JOLLIX_DIR}/home/user
#cd ${JOLLIX_DIR}/usr/src/linux/
#make clean

# create spare space
echo "1. create spare ..."
mkdir ${JOLLIX_DIR}/spare
# var
echo "var ..."
cd ${JOLLIX_DIR}/var
tar -cjpf ../spare/var-spare.tar.bz2 cache db tmp lib/samba
rm -fr cache db tmp lib/samba
# portage
echo "portage ..."
cd ${JOLLIX_DIR}/usr
tar -cjpf ../spare/portage-spare.tar.bz2 portage
rm -fr portage
# kernel sources
echo "kernel ..."
cd ${JOLLIX_DIR}/usr/src
tar -cjpf ../../spare/kernel-spare.tar.bz2 linux-2.4.20-gaming-r3
rm -fr linux-2.4.20-gaming-r3

# prepare etc
echo "2. prepare /etc configs ..."
mkdir ${JOLLIX_DIR}/spare/etc
cp ${JOLLIX_DIR}/etc/fstab ${JOLLIX_DIR}/spare/etc/fstab-org
cp ${JOLLIX_DIR}/etc/init.d/local ${JOLLIX_DIR}/spare/etc/local-org
cp ${JOLLIX_DIR}/etc/init.d/modules ${JOLLIX_DIR}/spare/etc/modules-org
cp ${JOLLIX_DIR}/etc/init.d/checkroot ${JOLLIX_DIR}/spare/etc/checkroot-org
cp ${JOLLIX_DIR}/etc/runlevels/boot/consolefont ${JOLLIX_DIR}/spare/etc/consolefont-org
cp ${JOLLIX_DIR}/etc/runlevels/default/netmount ${JOLLIX_DIR}/spare/etc/netmount-org
#rm ${JOLLIX_DIR}/etc/runlevels/boot/keymaps
cp ${WORK_DIR}/skripte/fstab ${JOLLIX_DIR}/etc/fstab
cp ${WORK_DIR}/skripte/mtab ${JOLLIX_DIR}/etc/mtab
cp ${WORK_DIR}/skripte/local ${JOLLIX_DIR}/etc/init.d/
cp ${WORK_DIR}/skripte/modules ${JOLLIX_DIR}/etc/init.d/
cp ${WORK_DIR}/skripte/checkroot ${JOLLIX_DIR}/etc/init.d/
cp ${WORK_DIR}/skripte/keymaps ${JOLLIX_DIR}/etc/init.d/
# runlevels
rm -f ${JOLLIX_DIR}/etc/runlevels/boot/consolefont
rm -f ${JOLLIX_DIR}/etc/runlevels/default/netmount

cp ${WORK_DIR}/skripte/modules-jollix.sh ${JOLLIX_DIR}/sbin/
cp ${WORK_DIR}/skripte/transitmount ${JOLLIX_DIR}/sbin/
cp ${WORK_DIR}/skripte/transitlink ${JOLLIX_DIR}/sbin/
cp ${WORK_DIR}/skripte/fritzdsl-connect.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/fritzdsl-setup.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/hlinstall.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/isdn-connect.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/isdn-setup.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/mousewheel-setup.sh ${JOLLIX_DIR}/usr/bin/
cp ${WORK_DIR}/skripte/x-net-setup.sh ${JOLLIX_DIR}/usr/bin/

# configure opengl
echo "3. opengl settings ..."
mkdir ${JOLLIX_DIR}/etc/opengl
cp ${JOLLIX_DIR}/usr/sbin/opengl-update ${JOLLIX_DIR}/usr/sbin/opengl-update-org
cp ${WORK_DIR}/skripte/opengl-update ${JOLLIX_DIR}/usr/sbin/

ln -sf /etc/opengl/libglx.a ${JOLLIX_DIR}/usr/X11R6/lib/modules/extensions/libglx.a
ln -sf /etc/opengl/libglx.so ${JOLLIX_DIR}/usr/X11R6/lib/modules/extensions/libglx.so
ln -sf /etc/opengl/libMesaGL.so ${JOLLIX_DIR}/usr/X11R6/lib/libMesaGL.so
ln -sf /etc/opengl/libGL.so ${JOLLIX_DIR}/usr/lib/libGL.so
ln -sf /etc/opengl/libGL.so.1 ${JOLLIX_DIR}/usr/lib/libGL.so.1
ln -sf /etc/opengl/libGLcore.so ${JOLLIX_DIR}/usr/lib/libGLcore.so
ln -sf /etc/opengl/libGLcore.so.1 ${JOLLIX_DIR}/usr/lib/libGLcore.so.1

# clean /var/log
echo "4. clean /var/log"
rm -f ${JOLLIX_DIR}/var/log/XFree86*
rm -f ${JOLLIX_DIR}/var/log/kdm.log
rm -f ${JOLLIX_DIR}/var/log/critical/*
rm -f ${JOLLIX_DIR}/var/log/everything/*
rm -f ${JOLLIX_DIR}/var/log/kernel/*
rm -f ${JOLLIX_DIR}/var/log/pwdfail/*
rm -f ${JOLLIX_DIR}/var/log/sshd/*
rm -f ${JOLLIX_DIR}/var/log/telnet/*
rm -f ${JOLLIX_DIR}/var/log/emerge.log
rm -f ${JOLLIX_DIR}/var/log/lastlog
rm -f ${JOLLIX_DIR}/var/log/scrollkeeper.log
rm -f ${JOLLIX_DIR}/var/log/wtmp

# xkb
echo "5. xkb"
rm -f ${JOLLIX_DIR}/etc/X11/xkb
mv ${JOLLIX_DIR}/usr/X11R6/lib/X11/xkb ${JOLLIX_DIR}/etc/X11/
ln -sf /etc/X11/xkb ${JOLLIX_DIR}/usr/X11R6/lib/X11/xkb

# do chroot
echo "6. do chroot, opengl-update nvidia!"
echo " cd jollix02"
echo " chroot /mnt/hdd/data/jollix-home/jollix-work/jollix02 /bin/bash"
echo " env-update"
echo " source /etc/profile"
echo " opengl-update nvidia"
echo " rm_ /etc/ati"
echo " touch /etc/nvidia"
echo " /etc/nvidia checken und evtl. /etc/ati löschen!"
echo " rm_ -fr var/cache"
echo " exit"
