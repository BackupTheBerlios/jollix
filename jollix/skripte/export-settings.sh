#!/bin/b###
# Autor: THExSYSTEM <thexsystem@x-23.net>
##
# Date: 07.11.2003
###

backup_standart () {
	Xdialog --title "Config-Dateien exportieren" --checklist "Bitte wählen Sie die Programme / Dateien\naus die exportieren werden sollen" 20 50 20 "1" "X-Server" on "2" "KvIRC (ohne Log-Dateien)" on "3" "KvIRC (mit Log-Dateien)" off "4" "PPP (Internet)" on 2> ${1}.programs
	for counter in $( seq 1 4 ) ; do
		check=`cat ${1}.programs | grep $counter`=0			case $counter in
				1)	echo -n "Backup X-Server Settings..."
					find /etc/X11/XF86Config* -type f -exec tar -rPf /tmp/jollix-backup/xf86configs.tar {} \;
					bzip2 /tmp/jollix-backup/xf86configs.tar --best
					echo "done!"
					;;
				2)	echo -n "Backup KvIRC [without Log-Files] Settings..."
					find /home/user/kvirc/ -type f -exec tar -rPf /tmp/jollix-backup/kvirc-light.tar {} \;
					find /home/user/kvirc/ -ty	/tmp/jollix-backup/kvirc-light.tar {} \;
					bzip2 /tmp/jollix-backup/kvirc-light.tar --best
					echo "done!"
					;;
				3)	echo -n "Backup KvIRC [with Log-Files] Settings..."
					find /home/user/kvirc/ -type f -exec tar -rPf /tmp/jollix-backup/kvirc.tar {} \;
					bzip2 /tmp/jollix-backup/kvirc.tar --best
					echo "done!"
					;;
				4)	echo -n "Backup PPP Settings..."
					kdesu -n -c "find /etc/ppp/ -type /tmp/jollix-backup/ppp.tar {} \;"
					bzip2 /tmp/jollix-backup/ppp.tar --best
					echo "done!"
					;;
			esac
		fi
	done
}

backup_user () {
	Xdialog --title "Benutzerdefinierte Config-Dateien exportieren" --inputbox "Bitte geben Sie die Config-Dateien mit absoluten Pfad ein\n(bei mehr als einer, mit Leerzeichen trennen)"  20 50 "" 2>  ${1}.files
	check=`cat ${1}.files`
	if [ "$check" != "" ] ; then
		echo -		tar -rPf /tmp/jollix-backup/other.tar `cat ${1}.files`
		bzip2 /tmp/jollix-backup/other.tar --best
		echo "done!"
	fi
}

backup_device () {
	Xdialog --title "Config-Dateien exportieren" --radiolist "Bitte wählen Sie ein Medium\nauf dem die Config-Datein exportiert werden sollen" 15 50 15 "1" "Diskette" on "2" "USB-Stick" off 2> ${1}.method
	for counter_met in $( seq 1 2 ) ; do
		check=`cat ${1}.method | grep $counter_		if [ "$check" != "" ] ; then
			case $counter_met in
				1)	echo "Backup 2 Floppy"
					device4backup=/dev/fd0
					;;
				2)	echo "Backup 2 USB-Stick"
					device4backup=/dev/sda1
					;;
			esac
		fi
	done
}

check_tempdir () {
	if [ -d /tmp/jollix-backup ] ; then
		rm -rf /tmp/jollix-backup
	fi
	mkdir /tmp/jollix-backup
}

clean_tempdir () {
	if [ -d /tmp/jollix-backup ] ; then
	fi
}

menu () {
	Xdialog --title "Config-Dateien exportieren" --checklist "Bitte wählen Sie die Exportier-Methode" 15 50 15 "1" "Standart" on "2" "Benutzerdefiniert" off 2> ${1}.method
	for counter_met in $( seq 1 2 ) ; do
		check=`cat ${1}.method | grep $counter_met`
		if [ "$check" != "" ] ; then
			case $counter_met in
				1)	echo "Running Standart Backup"
					backup_standart
					;;
				2)	echo "Ru					backup_user
					;;
			esac
		fi
	done
}

copy2dev () {
	check=`mount | grep $device4backup`
	if [ "$check" = "" ] ; then
		kdesu -n -c "mkdir -p /mnt/backup-dev && mount $device4backup /mnt/backup-dev -t vfat -o rw && mkdir -p /mnt/backup-dev/jollix-backup && cp /tmp/jollix-backup/*.tar.bz2 /mnt/backup-dev/jollix-backup/ && umount /mnt/backup-dev"
	else
		Xdialog --title "Config-Dateien exportieren" --msgb$wird gerade benutzt. Speichern nicht möglich" 10 50
		exit
	fi
}

## Main ##
check_tempdir
menu
backup_device
copy2dev
clean_tempdir