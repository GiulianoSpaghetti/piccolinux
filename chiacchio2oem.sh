#! /bin/bash
#autore Giulio Sorrentino <gsorre84@gmail.com>

function installPrerequisites {
apt-get install dialog -y
}

function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function checkSystem {
if [ ! -f "/etc/debian_version" ]; then
	echo "Non sei su debian."
	exit 1
fi
}

notRoot
checkSystem
instalPrerequisites

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso pulisco la cache di apt." 40 60
apt clean
apt update


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Rimuovo forzatamente le libdrm francy, non riavviare o chiudere questa finestra per nessun motivo." 40 60

dpkg -r --force-depends `apt list --installed` | grep libdrm*-francy* | cut -d / - n 1`

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Rimuovo forzatamente le libgl chiacchio, non riavviare o chiudere questa finestra per nessun motivo." 40 60

dpkg -r --force-depends `apt list --installed` | grep chiacchio | cut -d / - n 1`

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Installo la versione più nuova di libdrm e libgl che si trova nei repository." 40 60


apt -f install


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright 2021 Gulio Sorrentino\nConcesso in licenza secondo la GPL v3 o, secondo la tua opinione, qualsiasi versione successiva.\nIlsoftware viene concesso per come è, senza nessuna garanzia, né implicita né esplicita.\nSe ti è sembrato interessante considera una donazione su paypal.\nDedicato a Annachiara Milano" 40 60
