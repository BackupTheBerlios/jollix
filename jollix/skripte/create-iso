#!/bin/sh
#                ### create-iso ###
# 
#  This script builds an iso image, that can be burned on CD.
#  The final jollix product ;-)
#  Use from cvsroot/jollix directory 

source skripte/settings
mkisofs -J -R -l -o jollix.iso -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table $LIVECD_DIR
