#!/bin/sh

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi


echo "Installiamo le librerie necessarie al funzionamento dello script"
sudo apt install -y dialog jigdo-file coreutils;

quale=$(dialog --output-fd 1 --backtitle "Quale sistema scegliere" \
--radiolist "Quale sistema:" 40 40 7 \
 1 "Bookworm" on \
 2 "Bullseye" off \
 3 "Buster" off )
if [ $? -eq 1 ]; then
	exit 1;
fi

case $quale in
1)
	path="12.8.0"
	url="cdimage/release"
	nome=$path
	;;
2)
	path="11.11.0"
	url="cdimage/archive"
	nome=$path
	;;
3)
	url="cdimage/archive"
	nome="10.13.0"
	path=$nome
 ;;
esac

dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricata la pennetta $arch.Il programma adesso chiedera' se ci sono iso precedenti che possono essere utili per ricavare i files necessari (la iso precedente include altri file, non conta).\nIn caso positivo montatela e date il punto di mount, in caso negativo premete semplicemente invio.\nIn seguito verra' chiesto quale mirror apt usare per scaricare i files non trovati.Poi andate a farvi un giro :)" 40 60
	if [ -f debian-$nome-amd64-STICK16GB-1.iso ]; then
		dialog	--msgbox "Il file esiste già. Il programma termina." 40 60 >/dev/tty
	else 
		jigdo-lite https://cdimage.debian.org/$url/$path/amd64/jigdo-16G/debian-$nome-amd64-STICK16GB-1.jigdo
		if [ $? -eq 1 ]; then
			dialog	--msgbox "Si è verificato un errore, il file https://cdimage.debian.org/$url/$path/amd64/jigdo-16G/debian-$nome-amd64-STICK16GB-1.jigdo non è stato trovato. Il programma termina." 40 60>/dev/tty
			exit 1
		fi
	fi	
	i=`expr $i + 1`
done
dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nHappy Hacking :)" 40 60>/dev/tty
