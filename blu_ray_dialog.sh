#!/bin/sh

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi

echo "Installiamo le librerie necessarie al funzionamento dello script"
sudo apt install -y dialog jigdo-lite core-utils;

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

case $quale in
1) arch=i386
numbd=4;;
2) arch=amd64
numbd=4;;
3) arch=source
numbd=3;;
esac


dialog --title "Download blu ray" \
--backtitle "Download blu ray" \
--yesno "Vuoi scaricare i double layer?" 7 60
if [ $? -eq 1 ]; then
	sl="bd"
else
	sl="dlbd"
	numbd=2
fi

sl1=`echo $sl | tr [:lower:] [:upper:]`
i=1;

while [ $i -le $numbd ]; do
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricato il blu ray numero $i di $numbd.Il programma adesso chiedera' se ci sono iso precedenti che possono essere utili per ricavare i files necessari (la iso precedente include altri file, non conta).\nIn caso positivo montatela e date il punto di mount, in caso negativo premete semplicemente invio.\nIn seguito verra' chiesto quale mirror apt usare per scaricare i files non trovati.Poi andate a farvi un giro :)" 40 60
	jigdo-lite https://cdimage.debian.org/debian-cd/`cat /etc/debian_version`.0/$arch/jigdo-$sl/debian-`cat /etc/debian_version`.0-$arch-${sl1}-$i.jigdo
	if [ $? -ne 1 ]; then
		i=`expr $i + 1`
	else
		dialog	--msgbox "Si è verificato un errore, il file https://cdimage.debian.org/debian-cd/`cat /etc/debian_version`.0/$arch/jigdo-$sl/debian-`cat /etc/debian_version`.0-$arch-${sl1}-$i.jigdo non è stato trovato. Il programma termina." 40 60>/dev/tty
		exit 1
	fi	
done

dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nDedicato a Francesca del centro di igiene mentale (milano? san severino? salerno?).\nHappy Hacking :)" 40 60>/dev/tty


