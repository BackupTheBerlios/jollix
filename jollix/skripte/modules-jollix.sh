#!/bin/sh
# Moduleloader
# Copyright 2003 jollix
# Jochen Spang <knochestolle@web.de>
# Oliver Schwinn <patteh@web.de>
# location in cloop: /sbin/modules-jollix
# Distributed under the terms of the GNU General Public License, v2 or later

# load all modules
for module in $(pcimodules) ; do
   if [ "$module" = "fcdsl" ] ; then
	modprobe -s -k capi
   fi
   if [ "$module" = "fcpci" ] ; then
        modprobe -s -k capi
   fi
   modprobe -s -k "$module"
done

# GRAPHIC SECTION ################################################
# graphic adapter module: 0=VESA, 1=NVIDIA, 2=FGLRX, 3=RadeonDRI
gfxmodule=0

# test nvidia module
insmod -q nvidia > /dev/null
for module in $(lsmod) ; do
    if [ "$module" = "nvidia" ] ; then
	gfxmodule=1
    fi
done

# test fglrx module
if [ $gfxmodule = 0 ] ; then
    insmod -q fglrx > /dev/null
    for module in $(lsmod) ; do
	if [ "$module" = "fglrx" ] ; then
	    gfxmodule=2
	fi
    done
fi

# test RadeonDRI module
#if [ $gfxmodule = 0 ] ; then
#    further cases go here (matrox, rage 128 pro etc.)
#    modprobe -q agpgart
#    modprobe -q radeon
#    for module in $(lsmod) ; do
#	if [ "$module" = "radeon" ] ; then
#	    gfxmodule=3
#	fi
#    done
#fi

local CMDLINE="`cat /proc/cmdline`"
	for x in $CMDLINE
	do
		if [ "$x" = "vesa" ]
		then
                  gfxmodule=0
		fi
	done

case  $gfxmodule in
    0) # use vesa safemode
	cp /etc/X11/XF86Config-vesa /etc/X11/XF86Config
        #opengl-update xfree
	;;
    1) # switch to nvidia
	cp /etc/X11/XF86Config-nvidia /etc/X11/XF86Config
	if [ ! -e /etc/nvidia ] ; then
	  touch /etc/nvidia
	  rm /etc/ati
	  opengl-update nvidia
	fi
	;;
    2) # switch to ati
	cp /etc/X11/XF86Config-ati /etc/X11/XF86Config
	if [ ! -e /etc/ati ] ; then
	  touch /etc/ati
	  rm /etc/nvidia
	  opengl-update ati
	fi
	;;
    3) # switch to ati-drm
	cp /etc/X11/XF86Config-ati-drm /etc/X11/XF86Config
	opengl-update xfree
	;;
esac

# SOUND SECTION #####################################################
# load oss
for module in $(lsmod) ; do
  if [ "$module" = "snd" ] ; then
   modprobe snd-pcm-oss
  fi
done

# unmute alsa
amixer set Master 25 unmute
amixer set PCM 25 unmute

# USB PS/2 MOUSE SECTION #########################################
# wait 5 sec. for usb/devices to be created (hackattack!)
goon=true
declare -i counter=0
while $goon ; do
    if grep -i "mouse" /proc/bus/usb/devices >/dev/null
	then
	goon=false
    else
	counter=${counter}+1
	echo -n .
	sleep 1
    fi
    if [ $counter = 5 ]
	then
	goon=false
    fi
done

if grep -i "mouse" /proc/bus/usb/devices >/dev/null
    then
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-vesa
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-ati
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-nvidia
else
    sed -i -e 's/input\/mice/psaux/' /etc/X11/XF86Config
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-vesa
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-ati
    sed -i -e 's/psaux/input\/mice/' /etc/X11/XF86Config-nvidia
fi
