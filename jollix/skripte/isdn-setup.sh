#!/bin/sh
#                 ### isdn-setup.sh ###
#
# The script is called by isdn-setup-sudo.sh to set up AVM ISDN cards.
# location in cloop: /usr/bin/isdn-setup.sh

Xdialog --title "ISDN Konfiguration" --inputbox "Benutzername beim Provider (T-Online, 1&1, usw.)" 8 45 2> ${1}.1
username=`cat ${1}.1`
Xdialog --title "ISDN Konfiguration" --passwordbox "Passwort eingeben" 8 45 2> ${1}.2
password=`cat ${1}.2`
if [ -e /etc/ppp/peers/isdn/jollixISDN ] ; then
    rm /etc/ppp/peers/isdn/jollixISDN
fi
cat >> /etc/ppp/peers/isdn/jollixISDN <<EOF
# ISDN Verbindung 
debug
sync
noauth
-chap
user $username
plugin userpass.so
password $password
defaultroute
plugin capiplugin.so
#controller 1
#numberprefix 0
number 019231770 
protocol hdlc
/dev/null
EOF

Xdialog --title "ISDN Konfiguration" --inputbox "IP-Adresse vom Nameserver eingeben (DNS).\nMehrere Server-Adressen werden durch ein\n Leerzeichen voneinander getrennt." 10 45 2> ${1}.3
dnserver=`cat ${1}.3`
if [ -e /etc/resolv.conf ] ; then
    rm /etc/resolv.conf
fi
for dns in $dnserver ; do
    cat >>/etc/resolv.conf <<EOF
nameserver $dns
EOF
done

capiinit start

exit