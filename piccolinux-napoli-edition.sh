#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

function selezionaMicrosoft {
dialog --title "Installazione Repository Microsoft" \
--backtitle "Installazione Repository Microsoft" \
--yesno "Vuoi installare il repo microsoft? (serve solo per amd64)" 7 60
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

sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/numeronesoft.gpg --keyserver keyserver.ubuntu.com --recv-keys 92025AED631C9E07
echo "deb [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian $repo main
deb-src [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net:8080/apt/debian $repo main" | sudo tee /etc/apt/sources.list.d/numeronesoft.list > /dev/null
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
--yesno "Vuoi installare la cbriscola in avalonia (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}


function selezionaInstallazioneWheelOfNumFortune {
dialog --title "Installazione Wheel of numerone's fortune" \
--backtitle "Installazione Wheel of numerone's fortune" \
--yesno "Vuoi installare il wheel of numerone's fortune (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}

function selezionaInstallazioneFortune {
dialog --title "Installazione numerone's fortune" \
--backtitle "Installazione numerone's fortune" \
--yesno "Vuoi installare il numerone's fortune in avalonia coi cookie americani (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}

function selezionaInstallazioneFortuna {
dialog --title "Installazione Il fortune di numerone" \
--backtitle "Installazione Il fortune di numerone" \
--yesno "Vuoi installare il fortune di numerone in avalonia coi cookie italiani (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}

function selezionaInstallazioneFortunacuic {
dialog --title "Installazione Il fortune di numerone cui c" \
--backtitle "Installazione Il fortune di numerone" \
--yesno "Vuoi installare il fortune di numerone in c testuale coi cookie italiani (non c'è per raspberry)?" 7 60
return $?
}

function selezionaInstallazioneFortunacuidotnet {
dialog --title "Installazione Il fortune di numerone cui dotnet" \
--backtitle "Installazione Il fortune di numerone" \
--yesno "Vuoi installare il fortune di numerone in c testuale coi cookie italiani (non c'è per raspberry)?" 7 60
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
apt-get install dialog wget -y


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
	apt-get install numeronesoft-backgrounds numeronesoft-backgrounds-otto
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

selezionaInstallazioneFortunacuic
if [ $? -eq 0 ]; then
   	apt update
	apt-get install il-fortune-di-numerone-c
fi

selezionaInstallazioneFortunacuidotnet
if [ $? -eq 0 ]; then
   	apt update
	apt-get install il-fortune-di-numerone-cui
fi

dialog	--msgbox "Copyright 2025 Giulio Sorrentino <numerone @fastwebnet.it>\nQuesto script viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nIl software scelto è disponibile nel menù applicazioni.\nHappy Hacking :)" 40 60
