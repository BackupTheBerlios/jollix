#!/bin/sh
#                 ### fritzdsl-setup.sh ###
#
# The script is called by fritzdsl--setup-sudo.sh to set up an AVM  FritzCardDSL.
# location in cloop: /usr/bin/x-net-setup

Xdialog --title "Fritz!CardDSL Konfiguration" --inputbox "Benutzername beim Provider (T-Online, 1&1, usw.)" 8 43 2> ${1}.1
username=`cat ${1}.1`
Xdialog --title "Fritz!CardDSL Konfiguration" --passwordbox "Passwort eingeben" 8 42 2> ${1}.2
password=`cat ${1}.2`
if [ -e /etc/ppp/peers/FritzCardDSL ] ; then
    rm /etc/ppp/peers/FritzCardDSL
fi
cat >> /etc/ppp/peers/FritzCardDSL <<EOF
# T-DSL Verbindung über die Fritz!Card DSL
debug
sync
noauth
defaultroute
lcp-echo-interval 5
lcp-echo-failure 3
lcp-max-configure 50
lcp-max-terminate 2
noccp
noipx
#
persist
#demand
connect ""
#
mru 1490
mtu 1490
ipcp-accept-local
ipcp-accept-remote
#
#
#
plugin userpass.so
#
# Zugangsdaten
user $username
password $password
linkname t-dsl
ipparam internet
plugin capiplugin.so
avmadsl
:
/dev/null
EOF

Xdialog --title "Fritz!CardDSL Konfiguration" --inputbox "IP-Adresse vom Nameserver eingeben (DNS).\nMehrere Server-Adressen werden durch ein\n Leerzeichen voneinander getrennt." 10 45 2> ${1}.3
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