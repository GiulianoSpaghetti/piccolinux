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
	11) repo="bullseye";;
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

sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/numeronesoft.gpg --keyserver keyserver.ubuntu.com --recv-keys 37A40DBA52B68EEB
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
--yesno "Vuoi installare la wxBriscola?" 7 60
return $?
}

function selezionaInstallazioneDiario {
dialog --title "Installazione Diario" \
--backtitle "Installazione Diario" \
--yesno "Vuoi installare il diario in avalonia (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}

function selezionaInstallazioneFortune {
dialog --title "Installazione numerone's fortune" \
--backtitle "Installazione numerone's fortune" \
--yesno "Vuoi installare il numerone's fortune in avalonia (per bookworm arm64 NON serve il repo microsoft)?" 7 60
return $?
}

function checkSystem {
read -d / sistema < /etc/debian_version
if [ $sistema = "bookworm" ]; then
	sistema=12
elif [ $sistema = "bullseye" ]; then
	sistema=11
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
fi 
selezionaInstallazioneDiario
if [ $? -eq 0 ]; then
   	apt update
	apt-get install diario
fi
selezionaInstallazioneFortune
if [ $? -eq 0 ]; then
   	apt update
	apt-get install numfortune.avalonia
fi
