#!/bin/sh
#                 ### mousewheel-setup.sh ###
#
# location in cloop: /usr/bin/mousewheel-setup.sh

Xdialog --title "Mausrad (de)aktivieren" --msgbox "Achtung!\nWenn die Mausradunterst�tzung eingeschaltet wird,\nkann es unter Umst�nden zu Fehlfunktionen\nbei Logitech M�usen kommen!!!" 10 45 
Xdialog --title "Mausrad (de)aktivieren" --yesno "Mausradunterst�tzung einschalten?\n\"Nein\" deaktiviert die Mausradfunktion" 8 43  
if [ $? == 0 ] ; then
    sed -i -e 's/"Auto"/"IMPS\/2"/' temp    
else
    sed -i -e 's/"IMPS\/2"/"Auto"/' temp        
fi
Xdialog --title "X-server neu starten" --msgbox "Damit die �nderung wirksam wird,\nmuss der X-Server neu gestartet werden.\n\nDer X-Server kann mit der Tastenkombination\nSTRG+ALT+BACKSPACE neu gestartet werden" 10 45

exit