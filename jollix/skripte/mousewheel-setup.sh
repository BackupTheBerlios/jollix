#!/bin/sh
#                 ### mousewheel-setup.sh ###
#
# location in cloop: /sbin/mousewheel-setup.sh

Xdialog --title "Mausrad (de)aktivieren" --msgbox "Achtung!\nWenn die Mausradunterstützung eingeschaltet wird,\nkann es unter Umständen zu Fehlfunktionen\nbei Logitech Mäusen kommen!!!" 10 45 
Xdialog --title "Mausrad (de)aktivieren" --yesno "Mausradunterstützung einschalten?\n\"Nein\" deaktiviert die Mausradfunktion" 8 43  
if [ $? == 0 ] ; then
    sed -i -e 's/"Auto"/"IMPS\/2"/' /etc/X11/XF86Config    
else
    sed -i -e 's/"IMPS\/2"/"Auto"/' /etc/X11/XF86Config    
fi
Xdialog --title "X-server neu starten" --msgbox "Damit die Änderung wirksam wird,\nmuss der X-Server neu gestartet werden.\n\nDer X-Server kann mit der Tastenkombination\nSTRG+ALT+BACKSPACE neu gestartet werden" 10 45

exit