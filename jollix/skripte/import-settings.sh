#!/bin/bash
###=0##
# Date: 07.11.2003
###

import_standart () {
	Xdialog --title "Config-Dateien importieren" --checklist "Bitte wählen Sie die Programme / Dateien\naus desen Einstellungen importiert werden sollen" 20 50 20 "1" "X-Server" on "2" "KvIRC (ohne Log-Dateien)" on "3" "KvIRC (mit Log-Dateien)" off "4" "PPP (Internet)" on "5" "Benutzerdefinierte" off 2> ${1}.programs
	for counter in $( seq 1 5 ) ; do
		check=`cat		if [ "$check" != "" ] ; then
			case $counter in
				1)	echo -n "Import X-Server Settings..."
					if [ -f $device4backup/jollix-backup/xf86configs.tar.bz2 ] ; then
						kdesu "tar -xjf $device4backup/jollix-backup/xf86configs.tar.bz2 -C /"
					else
						Xdialog --title "Datei nicht gefunden" --msgbox "Die Backup-Datei von X-Server\nkonnte nicht gefunden werden" 15 50
					fi
					echo "done!"
					;;
				2)	$					if [ -f $device4backup/jollix-backup/kvirc-light.tar.bz2 ] ; then
						tar -xjf $device4backup/jollix-backup/kvirc-light.tar.bz2 -C $HOME/
					else
						Xdialog --title "Datei nicht gefunden" --msgbox "Die Backup-Datei von KvIRC (ohne Logs)\nkonnte nicht gefunden werden" 15 50
					fi
					echo "done!"
					;;
				3)	echo -n "Import KvIRC [with Log-Files] Settings..."
					if [ -f $device4backup/jo4						tar -xjf $device4backup/jollix-backup/kvirc.tar.bz2 -C $HOME/
					else
						Xdialog --title "Datei nicht gefunden" --msgbox "Die Backup-Datei von KvIRC (mit Logs)\nkonnte nicht gefunden werden" 15 50
					fi
					echo "done!"
					;;
				4)	echo -n "Import PPP Settings..."
					if [ -f $device4backup/jollix-backup/ppp.tar.bz2 ] ; then
						kdesu "tar -xjf $device4backup/jollix-backup/ppp.tar.bz2 -C /"
					else=D						Xdialog --title "Datei nicht gefunden" --msgbox "Die Backup-Datei von PPP (Internet)\nkonnte nicht gefunden werden" 15 50
					fi
					echo "done!"
					;;
				5)	echo -n "Import Userspecified Settings..."
					if [ -f $device4backup/jollix-backup/other.tar.bz2 ] ; then
						kdesu "tar -xjf $device4backup/jollix-backup/other.tar.bz2 -C /"
					else
						Xdialog --title "Datei nicht gefunden" --msgbox "Die Backup-Datei der Benutzerdefinierten Config-T50
					fi
					echo "done!"
			esac
		fi
	done
}

import_user () {
	echo "empty"
}

backup_device () {
	Xdialog --title "Config-Dateien importieren" --radiolist "Bitte wählen Sie das Medium\nauf dem die Config-Datein gespeichert sind" 15 50 15 "1" "Diskette" on "2" "USB-Stick" off 2> ${1}.method
	for counter_met in $( seq 1 2 ) ; do
		check=`cat ${1}.method | grep $counter_met`=D		if [ "$check" != "" ] ; then
			case $counter_met in
				1)	echo "Backup on Floppy"
					device4backup=/dev/fd0
					;;
				2)	echo "Backup on USB-Stick"
					device4backup=/dev/sda1
					;;
			esac
		fi
	done
}

menu () {
	Xdialog --title "Config-Dateien importieren" --checklist "Bitte wählen Sie die Importier-Methode" 15 50 15 "1" "Standart" on "2" "Benutzerdefiniert" off 2> ${1}.method
	for counter_met in $( st		check=`cat ${1}.method | grep $counter_met`
		if [ "$check" != "" ] ; then
			case $counter_met in
				1)	echo "Running Standart Backup"
					import_standart
					;;
				2)	echo "Running User Backup"
					import_user
					;;
			esac
		fi
	done
}

mount_dev () {
	check=`mount | grep $device4backup`
	if [ "$check" = "" ] ; then
		kdesu -n -c "mkdir -p /mnt/backup-dev && mount $device4backup /mn	else
		if [ ! -d $device4backup/jollix-backup ] ; then
			Xdialog --title "Config-Dateien sichern" --msgbox "$device4backup wird gerade benutzt,  nicht möglich" 10 50
			exit
		fi
	fi
}

umount_dev () {
	check=`mount | grep $device4backup`
	if [ ! "$check" = "" ] ; then
		kdesu -n -c "umount /mnt/backup-dev -t"
	else
		if [ -d $device4backup/jollix-backup ] ; then
			kdesu -n -c "umount /mnt/backu		else
			Xdialog --title "Config-Dateien sichern" --msgbox "$device4backup ist nicht gemountet, umount nicht möglich" 10 50
			exit
		fi
	fi
}

## Main ##
backup_device
mount_dev
menu
umount_dev