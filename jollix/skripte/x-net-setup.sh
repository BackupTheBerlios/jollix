#!/bin/sh
#                 ### x-net-setup.sh ###
#
# The script is called by x-net-setup-sudo to set up the network.
# Currently the user has to be in a Ethernet LAN. 
# The network device is configuerd manually or by dhcp server.
# location in cloop: /usr/bin/x-net-setup.sh

[ ! -d /tmp/setup.opts ] && mkdir /tmp/setup.opts
cd /tmp/setup.opts

Xdialog --title "Netzwerk Konfiguration" --menu "Sie koennen DHCP benutzen, um das Netzwerk automatisch zu konfigurieren,\noder alle Angaben manuell machen. Waehlen Sie eine Moeglichkeit:" 20 70 7 0 "DHCP benutzen zur automatischen Erkennung der Netzwerkeinstellugen" 1 "IP Adresse explizit von Hand angeben" 2> ${1}.1
mynetsel=`cat ${1}.1`

oncancel() {
    if [ -z $1 ] 
	then exit
    fi
}

case $mynetsel in
    0)
	/sbin/dhcpcd -t 10 
	;;
    1)
	Xdialog --title "Netzwerk Schnittstelle" --inputbox "Bitte eine Netzwerk Interface angeben:"  20 50 "eth0" 2> ${1}.IF
	myiface=`cat ${1}.IF`
	oncancel `cat ${1}.IF`
	Xdialog --title "IP Addresse" --inputbox "Bitte IP Addresse angeben fuer $myiface:" 20 50 "192.168.1.1" 2> ${1}.IP
	oncancel `cat ${1}.IP`
	Xdialog --title "Broadcast address" --inputbox "Bitte Broadcast Addresse angeben fuer $myiface:" 20 50 "192.168.1.255" 2> ${1}.B
	oncancel `cat ${1}.B`
	Xdialog --title "Netzwerkmaske" --inputbox "Bitte Netzwerkmaske angeben fuer $myiface:" 20 50 "255.255.255.0" 2> ${1}.NM	
	oncancel `cat ${1}.NM`
	Xdialog --title "Gateway" --inputbox "Bitte Gateway angeben fuer $myiface ('Enter' fuer keinen:)" 20 50 2> ${1}.GW
	oncancel `cat ${1}.GW`
	Xdialog --title "DNS Server" --inputbox "Bitte Domain Name Server (DNS) angeben\n(Default ist 192.168.0.1)\n\nMehrere DNS-Server können durch ein Leerzeichen\nvoneinander getrennt angegeben werden.\nz.B. \"194.25.2.129 194.25.0.125\"" 20 50 2> ${1}.NS
	oncancel `cat ${1}.NS`
	/sbin/ifconfig `cat ${1}.IF` `cat ${1}.IP` broadcast `cat ${1}.B` netmask `cat ${1}.NM`
	myroute=`cat ${1}.GW`
	if [ "$myroute" != "" ]
	    then
	    /sbin/route add default gw $myroute dev `cat ${1}.IF` netmask 0.0.0.0 metric 1	
	fi
	myns="`cat ${1}.NS`"
	if [ -e /etc/resolv.conf ] ; then
	    rm /etc/resolv.conf
	fi
	for dns in $myns ; do
	    cat >>/etc/resolv.conf <<EOF
nameserver $dns
EOF
	done
	;;
esac
#Xdialog --infobox "Tippen Sie \"ifconfig\" um sicher zu gehen,\ndass das Netzwerk richtig konfiguriert wurde." 10 40 9999
