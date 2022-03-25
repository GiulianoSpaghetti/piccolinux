#!/bin/sh

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi


echo "Installiamo le librerie necessarie al funzionamento dello script"
sudo apt install -y dialog jigdo-file coreutils;

dialog	--msgbox "Questo è quello che offre l'archivio di debian, non so se i files necessari per costruire l'iso voluta ci sono tutti o meno, casomai provate più repository." 40 60>/dev/tty

dialog --backtitle "Quale sistema scegliere" \
--radiolist "Quale sistema:" 40 40 7 \
 1 "Bullseye" on \
 2 "Buster" off \
 3 "Stretch" off \
 4 "Jessie" off \
 5 "Wheezy" off \
 6 "Squeeze" off \
 7 "Lenny" off>/dev/tty 2>/tmp/result.txt 
if [ $? -eq 1 ]; then
	exit 1;
else
	quale=`cat /tmp/result.txt`
fi

rm /tmp/result.txt

dialog --backtitle "Quale architettura scegliere" \
--radiolist "Quale architettura:" 10 40 3 \
 1 "1386" off \
 2 "AMD64" off \
 3 "Sorgenti" on>/dev/tty 2>/tmp/result.txt 
if [ $? -eq 1 ]; then
	exit 1;
else
	arch=`cat /tmp/result.txt`
fi

rm /tmp/result.txt

if [ $quale -lt 7 ]; then
	dialog --title "Download blu ray" \
	--backtitle "Download blu ray" \
	--yesno "Vuoi scaricare i double layer?" 7 60
	if [ $? -eq 1 ]; then
		sl="bd"
	else
		sl="dlbd"
	fi
else
dialog	--msgbox "Questa versione esiste solo in single layer" 40 60 >/dev/tty
	sl="bd"
fi

case $quale in
1)
	path="11.1.0"
	url="cdimage/release"
	nome=$path
	numbd=4
;;
2)
	url="cdimage/archive"
	nome="10.10.0"
	path=$nome
	if [ $arch -eq 3 ]; then
		numbd=3
	else
		numbd=4;
	fi
;;
3) url="cdimage/archive"
   path="9.13.0"
   nome=$path
   numbd=3
;;
4) url="cdimage/archive"
   path="8.11.1"
   nome=$path
   numbd=3
;;
5) url="cdimage/archive"
   path="7.11.0"
   nome=$path
   numbd=2
;;
6) url="cdimage/archive"
   path="6.0.10"
   nome=$path
   numbd=2
;;
7) url="cdimage/archive"
   path="5.0.10"
   nome="5010"
   numbd=1
;;
esac

if [ $sl = "dlbd" ]; then
	resto=`expr $numbd % 2`
	numbd=`expr $numbd / 2`
	if [ $resto -eq 1 ]; then
		numbd=`expr $numbd + 1`
	fi
fi

sl1=`echo $sl | tr [:lower:] [:upper:]`

case $arch in
	1) arch=i386;;
	2) arch=amd64;;
	3) arch=source;;
esac

i=1;

while [ $i -le $numbd ]; do
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricato il blu ray numero $i di $numbd.Il programma adesso chiedera' se ci sono iso precedenti che possono essere utili per ricavare i files necessari (la iso precedente include altri file, non conta).\nIn caso positivo montatela e date il punto di mount, in caso negativo premete semplicemente invio.\nIn seguito verra' chiesto quale mirror apt usare per scaricare i files non trovati.Poi andate a farvi un giro :)" 40 60
	if [ -f debian-$nome-$arch-${sl1}-$i.iso ]; then
		dialog	--msgbox "Il file $i di $numbd esiste già. Si passa al successivo." 40 60 >/dev/tty
	else 
		jigdo-lite https://cdimage.debian.org/$url/$path/$arch/jigdo-$sl/debian-$nome-$arch-${sl1}-$i.jigdo
		if [ $? -eq 1 ]; then
			dialog	--msgbox "Si è verificato un errore, il file https://cdimage.debian.org/$url/$path/$arch/jigdo-$sl/debian-$nome-$arch-${sl1}-$i.jigdo non è stato trovato. Il programma termina." 40 60>/dev/tty
			exit 1
		fi
	fi	
	i=`expr $i + 1`
done
dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nHappy Hacking :)" 40 60>/dev/tty



