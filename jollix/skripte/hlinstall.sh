#!/bin/sh
#               ####   hlinstall   ####
# creates a desktop shortcut to Half-Life and/or HL-mod executables
# creates links to Half-Life installation in RAM
# location in livecd.cloop: /usr/bin/hlinstall

# global variables ############################################################
homedir="/home/user"
linkdir="$homedir/Half-Life/"
installdir="/mnt/partitions"
searchdir=$installdir
cd_dir=$installdir
subdirs=""
gamename="Half-Life"
gameexe="hl.exe"
cdeath="0"
modnames=""
selected_mods=""
atigamer="0"

# Prepare the fake Half-Life directory in /home/user ##########################
prepare_halflife() {
    rm $homedir/.start_hl.sh
    if [ -d $linkdir ] ; then
	cd $linkdir
	rm -rf *
    else
	mkdir $linkdir
    fi
    cd $linkdir
    if [ -e /etc/atigamer ] ; then
     atigamer=1
    fi
}

# Select Half-Life mods to create desktop icons for ###########################
select_mods() {
    local mods
    mods=`Xdialog --stdout --title "Mods auswaehlen" --checklist "Fuer welche Half-Life Mods sollen\nDesktop-Symbole angelegt werden?" 15 35 10 1 "Half-Life (kein Mod)" off 2 "Counter-Strike" on 3 "Public-Enemy" on`
    case $mods in
	1)
	    selected_mods="HalfLife" ;;
	2)
	    selected_mods="CounterStrike" ;;
	3)
	    selected_mods="PublicEnemy" ;;
	1/2)
	    selected_mods="HalfLife CounterStrike" ;;
	1/3)
	    selected_mods="HalfLife PublicEnemy" ;;
	2/3)
	    selected_mods="CounterStrike PublicEnemy" ;;
	1/2/3)
	    selected_mods="HalfLife CounterStrike PublicEnemy" ;;
    esac
    # put error handling here
}

# Select installation (Counter-Strike or Half-Life) ###########################
select_install() {
    local hl_install
    hl_install=`Xdialog --stdout --title "Half-Life oder Counter-Strike?" --radiolist "Einrichtung über eine Counter-Strike oder\n eine Half-Life Installation?" 16 45 25 1 "Half-Life (hl.exe -game MOD)" on 2 "Counter-Strike (cstrike.exe -game MOD)" off`
    case $hl_install in
	1)
	    gamename="Half-Life"
	    gameexe="hl.exe" ;;
	2)
	    gamename="Counter-Strike"
	    gameexe="cstrike.exe" ;;
    esac
}

# Select Cheating Death  ###########################
select_cd() {
    Xdialog --title "Cheating Death starten?" --yesno "Cheating Death starten" 16 45
    case $? in
    0)
    	cdeath=1
	local cd_install
	local proceed=1
	while [ $proceed == 1 ] ; do
		cd_dir=`Xdialog --stdout --cancel-label "Abbrechen" --title "Ordner angeben, in dem sich Cheating Death ("cdeath.exe") befindet" --fselect $searchdir 45 90`
		cd_install=$?
		case $cd_install in
	    		0) # All OK. The $cd_dir variable holds everything entered/choosed by the user.
				if [ -d "${cd_dir}" ] ; then
		    			if [ -f "${cd_dir}cdeath.exe" ] ; then
						echo ${cd_dir}"/cdeath.exe"
						proceed=0
					else
					Xdialog --stdout --title "Fehler" --infobox "Konnte die Datei \"${gameexe}\" in\n $installdir\n nicht finden. Bitte das korrekte Verzeichnis angeben oder abbrechen." 10 60 9999
					proceed=1
		    			fi
				else
		    		Xdialog --stdout --title "Fehler" --infobox "Kein Verzeichnis angegeben.\n Bitte das korrekte Verzeichnis angeben oder abbrechen." 10 60 9999
		    		proceed=1
				fi ;;
			1) # Cancel/No pressed.
				proceed=0
				cdeath=0 ;;
	    		255) # An error occured or the box was closed.
				proceed=0
				cdeath=0 ;;
		esac
	done
	;;
        1)
	cdeath=0 ;;
    esac
    echo $cdeath
}




# Create desktop shortcuts ####################################################
create_startscript() {
    local proceed=1
    local modpath_exit
    local gameoption
    while [ $proceed == 1 ] ; do
	installdir=`Xdialog --stdout --cancel-label "Abbrechen" --title "$gamename Ordner angeben, in dem sich ("$gameexe") befindet" --fselect $searchdir 45 90`
	modpath_exit=$?
	case $modpath_exit in
	    0) # All OK. The $installldir variable holds everything entered/choosed by the user.
		if [ -d ${installdir} ] ; then
		    if [ -f ${installdir}${gameexe} ] ; then
			if [ ! -z "$selected_mods" ] ; then
			  # create all icons
			    for mymod in $selected_mods ; do
				case $mymod in
				    HalfLife)
					gameoption="" ;;
				    CounterStrike)
					gameoption="cstrike" ;;
				    PublicEnemy)
					gameoption="penemy" ;;
				esac


				cat >>$homedir/.$mymod.desktop <<EOF
[Desktop Entry]
Comment=
Comment[de]=
Encoding=UTF-8
Exec=$homedir/.start_hl.sh -game $gameoption
GenericName=
GenericName[de]=
Icon=$homedir/.kde3.1/share/icons/$mymod.png
MimeType=
Name=$mymod
Name[de]=$mymod
Path=$linkdir
ServiceTypes=
SwallowExec=
SwallowTitle=
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
EOF
			    done
			    cat >$homedir/.start_hl.sh <<EOF
#!/bin/sh
rm $homedir/.wine/wineserver* -rf> /dev/null
rm ./core -f
if [ $atigamer = 1 ] ; then
 export DISPLAY="localhost:0.0"
elif [ -e /etc/nvidia ] ; then
 X :1 -ac &
 DISPLAY=:1
else
 Xdialog --stdout --title "Fehler" --infobox "Zum Spielen von Half-Life mit ATI Grafikkarte\njollix mit der Bootoption \"jollix atigamer\" starten" 10 60 9999
 exit
fi

if [ $cdeath = 1 ] ; then
  #cd $cd_dir
  wine -- "${cd_dir}/cdeath.exe" &
fi
cd $linkdir
xterm -e wine -- ${gameexe} -console \$*
killall -9 wine
rm $homedir/.wine/wineserver* -rf> /dev/null
rm ./core -f
exit
EOF
			   chmod u+x $homedir/.start_hl.sh
			else
			    exit
			fi
			proceed=0
		    else
			Xdialog --stdout --title "Fehler" --infobox "Konnte die Datei \"${gameexe}\" in\n $installdir\n nicht finden. Bitte das korrekte Verzeichnis angeben oder abbrechen." 10 60 9999
			proceed=1
		    fi
		else
		    Xdialog --stdout --title "Fehler" --infobox "Kein Verzeichnis angegeben.\n Bitte das korrekte Verzeichnis angeben oder abbrechen." 10 60 9999
		    proceed=1
		fi ;;
	    1) # Cancel/No pressed.
		proceed=0 ;;
	    255) # An error occured or the box was closed.
		proceed=0 ;;
	esac
    done
    Xdialog --title "ACHTUNG" --ok-label "Verknuepfung jetzt anlegen" --msgbox  "Bitte etwas Geduld.\nDas Anlegen der Desktop-Verknuepfung nimmt etwas Zeit in Anspruch." 10 60
}

# get sub directories from $1 #################################################
get_sub_dirs() {
    # $1 is an absolute path to a (sub)directory HL is installed in
    subdirs=""
    # search for all subdirectories in current directory
    for mydir in `ls -1 $1` ; do
	if [ -d "$1$mydir" ] ; then
	    subdirs="$subdirs $mydir"
	fi
    done
}

# create symbolic links in a fake Half-Life directory #########################
# and its subdirectories recursively. (creates real subdirectories!) ##########
create_symlinks() {
    # $1 is an abolute path to a (sub)directory HL is installed in
    local mysubdir=""

    # create any subdirectories and do recursion
    get_sub_dirs $1
    if [ ! -z "$subdirs" ] ; then
	mkdir $subdirs
	local mysubdirs=$subdirs
	subdirs=""
        # enter recursion(s)
	for mysubdir in $mysubdirs ; do
	    cd $mysubdir
	    create_symlinks $1$mysubdir/
 	    cd ..
	done
    fi

    # create the symlinks to $1$myfile
    ls -1 $1 | while read myfile ; do
	if [ ! -d "$1$myfile" ] ; then
	    case $myfile in
		*.cfg)
		    cp $1$myfile . ;;
		*)
		    ln -s "$1$myfile" ;;
	    esac
	fi
    done
}

# finish installation #########################################################
finish_install() {
    for mymod in $selected_mods
      do
      mv $homedir/.$mymod.desktop $homedir/Desktop/$mymod.desktop
    done
    Xdialog --title "Erfolg" --msgbox "Vorgang erfolgreich abgeschlossen.\n Verknuepfung angelegt." 10 60
}

## MAIN #######################################################################
prepare_halflife
select_mods
select_install
select_cd
create_startscript
# now there's an executable shortcut to Half-life and/or HL mod(s)
create_symlinks $installdir
finish_install

exit 0
