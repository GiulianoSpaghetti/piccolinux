#!/bin/sh

#sudo apt install -y dialog jigdo-lite;


function SelezionaBluRay {
dialog --title "Download blu ray" \
--backtitle "Download blu ray" \
--yesno "Vuoi scaricare i double layer?" 7 60
return $?
}


function SelectArch {
dialog --backtitle "Quale archiettura scegliere" \
--radiolist "Quale architettura:" 10 40 3 \
 1 "1386" off \
 2 "AMD64" off \
 3 "Sorgenti" on>/dev/tty 2>/tmp/result.txt 
if [ $? -eq 0 ]; then
	quale=`cat /tmp/result.txt`
else
	quale=0
fi
rm /tmp/result.txt
return $quale
}


SelectArch
case $? in
1) arch=i386
numbd=4;;
2) arch=amd64
numbd=4;;
3) arch=source
numbd=3;;
esac


SelezionaBluRay
if [ $? -eq 1 ]; then
	sl="bd"
else
	sl="dlbd"
	numbd=2
fi

sl1=${sl^^}


i=1;

while [ $i -le $numbd ]; do
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricato il blu ray numero $i di $numbd" 40 60
	echo https://cdimage.debian.org/debian-cd/`cat /etc/debian_version`.0/$arch/jigdo-$sl/debian-`cat /etc/debian_version`.0-$arch-${sl1}-$((i++)).jigdo
done

dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nHappy Hacking :)" 40 60


