#!/bin/sh

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi

echo "Installiamo le librerie necessarie al funzionamento dello script"
#sudo apt install -y dialog jigdo-lite core-utils;

dialog --title "Download DVD" \
--backtitle "Download DVD" \
--yesno "Vuoi scaricare i DVD?" 7 60
if [ $? -eq 1 ]; then
	sl="cd"
	dialog --backtitle "Quale archiettura scegliere" \
	--radiolist "Quale architettura:" 10 40 9 \
	 1 "AMD64" off \
	 2 "arm64" off \
	 3 "armel" off \
	 4 "armhf" off \
	 5 "i386" off \
	 6 "mips" off \
	 7 "mips64el" off \
	 8 "mipsel" off \
	 9 "ppc64el" off \
	 10 "s390x" off \
	 11 "multi-arch" on>/dev/tty 2>/tmp/result.txt 
	$temp=`cat /tmp/result.txt`
	if [ $temp -ne 11 ]; then
		dialog --title "Download netinst" \
		--backtitle "Download netinst" \
		--yesno "Vuoi scaricare il netinst?" 7 60
		if [ $? -eq 0 ]; then
			netinst=1
		else
			netinst=0
		fi
	else
		netinst=1
	fi
else
	sl="dvd"
	dialog --backtitle "Quale archiettura scegliere" \
	--radiolist "Quale architettura:" 10 40 9 \
	 1 "AMD64" of \
	 2 "arm64" off \
	 3 "armel" off \
	 4 "armhf" off \
	 5 "i386" off \
	 6 "mips" off \
	 7 "mips64el" off \
	 8 "mipsel" off \
	 9 "ppc64el" off \
	 10 "s390x" off \
	 12 "source" on>/dev/tty 2>/tmp/result.txt 
fi
quale=`cat /tmp/result.txt`
rm /tmp/result.txt

case $quale in
1) 
	arch="amd64"
	numbd=17;;
2) 
	arch="arm64"
	numbd=15;;
3) 
	arch="armel"
	numbd=14;;
4)
	arch="armhf"
	numbd=14;;
5) 
	arch="i386"
	numbd=16;;
6) 
	arch="mpis"
	numbd=14;;
7) 
	arch="mpis64el"
	numbd=15;;
8)
	arch="mipsel"
	numbd=15;;
9) 
	arch="ppc64el"
	numbd=15;;
10) 
	arch="s390x"
	numbd=14;;
11) 
	arch="multi-arch"
	numbd=1;;
12) 
	arch="source"
	numbd=14;;
*) echo $quale;;
esac

suffisso=debian-`cat /etc/debian_version`.0


if [ $sl = "cd" ]; then
numbd=1
fi

sl1=`echo $sl | tr [:lower:] [:upper:]`
i=1;

while [ $i -le $numbd ]; do
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricato il supporto numero $i di $numbd.Il programma adesso chiedera' se ci sono iso precedenti che possono essere utili per ricavare i files necessari (la iso precedente include altri file, non conta).\nIn caso positivo montatela e date il punto di mount, in caso negativo premete semplicemente invio.\nIn seguito verra' chiesto quale mirror apt usare per scaricare i files non trovati.Poi andate a farvi un giro :)" 40 60
	nome=${suffisso}-${arch}-${sl1}-$i
	if [ $sl = 'cd' ]; then
		nome=${suffisso}-${arch}-xfce-${sl1}-$i
	fi
	if [ $netinst -eq 1 ]; then
		if [ $arch = "multi-arch" ]; then
			nome=$suffisso-amd64-i386-netinst
		else
			nome=$suffisso-$arch-netinst
		fi
	fi
	if [ -f $nome.iso ]; then
		dialog	--msgbox "Il file $i di $numbd esiste già. Si passa al successivo." 40 60 >/dev/tty
	else 
		jigdo-lite https://cdimage.debian.org/debian-cd/`cat /etc/debian_version`.0/$arch/jigdo-$sl/$nome.jigdo
		if [ $? -eq 1 ]; then
			dialog	--msgbox "Si è verificato un errore, il file https://cdimage.debian.org/debian-cd/`cat /etc/debian_version`.0/$arch/jigdo-$sl/debian-`cat /etc/debian_version`.0-$arch-${sl1}-$i.jigdo non è stato trovato. Il programma termina." 40 60 >/dev/tty
			exit 1
		fi
	fi
	i=`expr $i + 1`	
done

dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nHappy Hacking :)" 40 60>/dev/tty


