#!/bin/bash
#Autore: Giulio Sorrentino <gsorre84@gmail.com>

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi

sudo apt update
sudo apt install dpkg-dev devscripts dialog -y

apt source unrar
if [ $? -ne 0 ]; then
dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Si è verificato un errore, probabilmente devi abilitare i source repository" 7 60
	exit 1
fi

sudo apt build-dep unrar
cd unrar-nonfree-?.?.?
dpkg-buildpackage
cd ..
mv unrar_*.deb ~/Scaricati
mv libunrar*.deb ~/Scaricati
rm -rf *unrar*
sudo dpkg -i ~/Scaricati/unrar_*.deb
dialog --title "Tutto Fatto" \
	--backtitle "OK" \
	--msgbox "Il pacchetto unrar nonfree è già stato installato, ed è disponibile nella cartella download, tuttavia non può essere passato a terzi.
Se ti è piaciuto questo software considera una donazione.
Dedicato ad Annachiara Milano" 10 60 
