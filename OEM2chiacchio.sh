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

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Adesso disabilito il blocco degli aggiornamenti, accertarsi che il repository della numeronesoft sia attivo." 40 60


apt-mark unhold libegl-mesa0 libegl1 libgbm1 libgl1-mesa-dri libgl1 libglapi-mesa libgles2 libglx-mesa0 mesa-va-drivers mesa-vdpau-drivers libdrm-amdgpu1 libdrm-common libdrm-nouveau2 libdrm-radeon1 libdrm2

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Eseguo tutti gli aggionrnameni, anche delle libgl" 40 60


apt update
apt upgrade -y
apt install libegl1 libgl1 libgles2 -y

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright 2021 Gulio Sorrentino\nConcesso in licenza secondo la GPL v3 o, secondo la tua opinione, qualsiasi versione successiva.\nIlsoftware viene concesso per come è, senza nessuna garanzia, né implicita né esplicita.\nSe ti è sembrato interessante considera una donazione su paypal.\nDedicato a Francesca dei centri sociali (san severino? milano? salerno?)" 40 60
