#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

function aggiungiRepo {
case $sistema in
	12) repo="bookworm";;
	*) dialog --title "Repository non disponibile" \
--backtitle "Repository non disponibile" \
--msgbox "Il repository non è disponibile perquesta versione" 7 60
	return 0
esac
sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/numeronesoft.gpg --keyserver keyserver.ubuntu.com --recv-keys 37A40DBA52B68EEB
echo "deb [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net bookworm main
deb-src [signed-by=/usr/share/keyrings/numeronesoft.gpg] http://numeronesoft.ddns.net bookworm main" | sudo tee /etc/apt/sources.list.d/numeronesoft.list > /dev/null
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

selezionaInstallazioneWallpapers
if [ $? -eq 0 ]; then
	apt-get install numeronesoft-backgrounds-cornetti numeronesoft-backgrounds numeronesoft-backgrounds-otto
fi 

selezionaInstallazioneBriscola
if [ $? -eq 0 ]; then
	apt-get install wxbriscola
fi 
