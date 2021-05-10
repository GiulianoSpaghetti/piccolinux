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

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso pulisco la cache di apt, accertarsi che il repository della numeronesoft sia disabilitato." 40 60
apt clean
apt update


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Rimuovo forzatamente le libdrm francy, non riavviare o chiudere questa finestra per nessun motivo." 40 60

dpkg -r --force-depends libdrm-amdgpu1
dpkg -r --force-depends libdrm-common
dpkg -r --force-depends libdrm-nouveau2
dpkg -r --force-depends libdrm-radeon1
dpkg -r --force-depends libdrm2

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Rimuovo forzatamente le libgl chiacchio, non riavviare o chiudere questa finestra per nessun motivo." 40 60

dpkg -r --force-depends libegl-mesa0
dpkg -r --force-depends libegl1
dpkg -r --force-depends libgbm1
dpkg -r --force-depends libgl1-mesa-dri
dpkg -r --force-depends libgl1
dpkg -r --force-depends libglapi-mesa
dpkg -r --force-depends libgles2
dpkg -r --force-depends libglx-mesa0
dpkg -r --force-depends mesa-va-drivers
dpkg -r --force-depends mesa-vdpau-drivers

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Installo la versione più nuova di libdrm e libgl che si trova nei repository (hai disabilitato quello della numeronesoft, vero?)." 40 60


apt -f install

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Imposto il blocco degli aggiornamenti per quegli specifici pacchetti, così puoi riattivare i repository della numeronesoft per giocare a briscola senza che questi pacchetti vengano aggiornati" 40 60


apt-mark hold libegl-mesa0 libegl1 libgbm1 libgl1-mesa-dri libgl1 libglapi-mesa libgles2 libglx-mesa0 mesa-va-drivers mesa-vdpau-drivers libdrm-amdgpu1 libdrm-common libdrm-nouveau2 libdrm-radeon1 libdrm2


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright 2021 Gulio Sorrentino\nConcesso in licenza secondo la GPL v3 o, secondo la tua opinione, qualsiasi versione successiva.\nIlsoftware viene concesso per come è, senza nessuna garanzia, né implicita né esplicita.\nSe ti è sembrato interessante considera una donazione su paypal.\nDedicato a Francesca dei centri sociali (san severino? milano? salerno?)" 40 60
