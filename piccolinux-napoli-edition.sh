#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>
function ShowPling {
dialog --msgbox "Siccome sono sotto root non posso aprire firefox, ad ogni modo ti rimando alla mia pagina pling dove puoi scaricare il software aggiornato e altro nuovo software: https://www.pling.com/u/numerone" 40 60
}

function selezionaMicrosoft {
dialog --title "Installazione Repository Microsoft" \
--backtitle "Installazione Repository Microsoft" \
--yesno "Vuoi installare il repo microsoft?" 7 60
return $?
}

function selezionaFreedesktopNotificationDaemon {
dialog --title "Installazione Demone Notifiche Freedesktop" \
--backtitle "Installazione Demone Notifiche Freedesktop" \
--yesno "Le notifiche ti vengono gia mostrate a video? (si nella maggior parte dei casi, ma non sul raspberry)" 7 60
return $?
}


function aggiungiRepo {
case $sistema in
	13) repo="trixie";;
	12) repo="bookworm";;
	*) dialog --title "Repository non disponibile" \
--backtitle "Repository non disponibile" \
--msgbox "Il repository non è disponibile perquesta versione" 7 60
	return 0
esac

selezionaMicrosoft
if [ $? -eq 0 ]; then
	cd /tmp
 	wget https://packages.microsoft.com/config/debian/$sistema/packages-microsoft-prod.deb
  	dpkg -i /tmp/packages-microsoft-prod.deb
   	rm /tmp/packages-microsoft-prod.deb
	cd
 fi

if [[ $sistema -eq 13 ]]; then
	apt install sq
 	sudo sq network keyserver --server hkps://keyserver.ubuntu.com search "7EB78BB0B36CE2AC" --output /usr/share/keyrings/numeronesoft.gpg
	echo "deb [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian trixie main
deb-src [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian trixie main" | sudo tee /etc/apt/sources.list.d/numeronesoft.list > /dev/null
else
	sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/numeronesoft.gpg --keyserver keyserver.ubuntu.com --recv-keys 92025AED631C9E07
	echo "deb [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian $repo main
deb-src [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian $repo main" | sudo tee /etc/apt/sources.list.d/numeronesoft.list > /dev/null
fi
return 1
}

function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	return 1
fi
	return 0
}

function selezionaInstallazioneWallpapers {
dialog --title "Installazione Wallpapers" \
--backtitle "Installazione Wallpapers" \
--yesno "Vuoi installare i wallpaper sotto licenza ShareALike 4.0 international?" 7 60
return $?
}

function selezionaInstallazioneBriscola {
dialog --title "Installazione wxBriscola" \
--backtitle "Installazione wxBriscola" \
--yesno "Vuoi installare la wxBriscola (sconsigliata su raspberry con schermo autonomo)?" 7 60
return $?
}

function selezionaInstallazioneCBriscola	 {
dialog --title "Installazione CBriscola" \
--backtitle "Installazione CBriscola" \
--yesno "Vuoi installare la cbriscola in avalonia?" 7 60
return $?
}


function selezionaInstallazioneWheelOfNumFortune {
dialog --title "Installazione Wheel of numerone's fortune" \
--backtitle "Installazione Wheel of numerone's fortune" \
--yesno "Vuoi installare il wheel of numerone's fortune?" 7 60
return $?
}

function selezionaInstallazioneFortune {
dialog --title "Installazione numerone's fortune" \
--backtitle "Installazione numerone's fortune" \
--yesno "Vuoi installare il numerone's fortune in avalonia coi cookie americani?" 7 60
return $?
}

function selezionaInstallazioneFortuna {
dialog --title "Installazione Il fortune di numerone" \
--backtitle "Installazione Il fortune di numerone" \
--yesno "Vuoi installare il fortune di numerone in avalonia coi cookie italiani?" 7 60
return $?
}

function selezionaInstallazioneFortuneStandard {
dialog --title "Installazione Il fortune di numerone da console" \
--backtitle "Installazione Il fortune di numerone da console" \
--yesno "Vuoi installare il fortune di numerone standard coi cookie italiani?" 7 60
return $?
}

function checkSystem {
read -d / sistema < /etc/debian_version
if [ $sistema = "bookworm" ]; then
	sistema=12
else
	read -d . sistema < /etc/debian_version
fi
return $sistema
}



notRoot
if [ $? -eq 1 ]; then
	exit 1;
fi

apt-get update
apt-get upgrade
apt-get install dialog wget xdg-utils libice6 libsm6 -y
export LD_PRELOAD=`sudo ldconfig -p | grep freetype| cut -d \  -f 4`

checkSystem
sistema=$?
aggiungiRepo

apt-get update
apt-get upgrade

selezionaFreedesktopNotificationDaemon
if [ $? -eq 1 ]; then
	apt-get install dunst
fi 

selezionaInstallazioneWallpapers
if [ $? -eq 0 ]; then
	apt-get install numeronesoft-backgrounds numeronesoft-backgrounds-otto numeronesoft-pixel9fold numeronesoft-android16
fi 

selezionaInstallazioneBriscola
if [ $? -eq 0 ]; then
	apt-get install wxbriscola
else
	selezionaInstallazioneCBriscola	
	if [ $? -eq 0 ]; then
		apt-get install cbriscola.avalonia
 	fi
fi
selezionaInstallazioneWheelOfNumFortune
if [ $? -eq 0 ]; then
	apt update
	apt-get install wheelofnumfortune.avalonia
fi
selezionaInstallazioneFortune
if [ $? -eq 0 ]; then
	apt update
	apt-get install numfortune.avalonia
fi
selezionaInstallazioneFortuna
if [ $? -eq 0 ]; then
	apt update
	apt-get install ilfortunedinumerone
fi
selezionaInstallazioneFortuneStandard
if [ $? -eq 0 ]; then
	apt update
	apt-get install xcowsay-numeronesoft
fi
ShowPling

dialog	--msgbox "Copyright 2025-2026 Giulio Sorrentino <numerone @fastwebnet.it>\nQuesto script viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nIl software scelto è disponibile nel menù applicazioni.\nHappy Hacking :)" 40 60
