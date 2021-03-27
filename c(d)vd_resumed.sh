#! /bin/bash

function selectDistro {
dialog --backtitle "Quale prodotto selezionare" \
--radiolist "Quale debian selezionare:" 15 40 7 \
 1 "Woody" off \
 2 "Sarge" on \
 3 "Etch" off \
 4 "Lenny" off \
 5 "Squeeze" off \
 6 "Wheezy" off \
 7 "Jessie" on >/dev/tty 2>/tmp/result.txt 
if [ $? -eq 0 ]; then
	quale=`cat /tmp/result.txt`
else
	exit 1
fi
rm /tmp/result.txt
return $quale
}

if [ ! -f "/etc/debian_version" ]; then
echo "Non sei su debian. Il programma termina."
exit 1
fi


echo "Installiamo le librerie necessarie al funzionamento dello script"
sudo apt install -y dialog jigdo-file coreutils;

dialog	--msgbox "Questo è quello che offre l'archivio di debian, non so se i files necessari per costruire l'iso voluta ci sono tutti o meno, casomai provate più repository." 40 60

selectDistro
case $? in
1) path=3.0_r5
nome=woody
piattaforma=i386
tipo=dvd
numero=1
suffisso1=""
suffisso2=_NONUS
;;
2) path=3.1_r8
nome=debian-31r8
piattaforma=i386
tipo=dvd
numero=2
suffisso1=binary-
$suffisso2=""
;;
3) path=4.0_r9
nome=debian-40r9
piattaforma=i386
tipo=dvd
numero=3
suffisso=dvd-
suffisso1=`echo $suffisso | tr [:lower:] [:upper:]`
$suffisso2=""
;;
4) path=5.0.10
nome=debian5010
piattaforma=i386
tipo
numero=5
suffisso=dvd-
suffisso1=`echo $suffisso | tr [:lower:] [:upper:]`
$suffisso2=""
;;
5) path=6.0.10
nome=debian-6.0.10
piattaforma=i386
tipo=dvd
numero=8
suffisso=dvd-
suffisso1=`echo $suffisso | tr [:lower:] [:upper:]`
$suffisso2=""
;;
6) path=7.11.0
nome=debian-7.11.0
piattaforma=i386
tipo=dvd
numero=10
suffisso=dvd-
suffisso1=`echo $suffisso | tr [:lower:] [:upper:]`
$suffisso2=""
;;
7) path=8.11.1
nome=debian-8.11.1
piattaforma=i386
tipo=dvd
numero=13
suffisso=dvd-
suffisso1=`echo $suffisso | tr [:lower:] [:upper:]`
$suffisso2=""
;;
esac




i=1
while [ $i -le $numero ]; do
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' scaricato il supporto numero $i di $numero.Il programma adesso chiedera' se ci sono iso precedenti che possono essere utili per ricavare i files necessari (la iso precedente include altri file, non conta).\nIn caso positivo montatela e date il punto di mount, in caso negativo premete semplicemente invio.\nIn seguito verra' chiesto quale mirror apt usare per scaricare i files non trovati.Poi andate a farvi un giro :)" 40 60
	nome=$nome-$piattaforma-${suffisso1}1${suffisso2}
	if [ -f $nome.iso ]; then
		dialog	--msgbox "Il file $i di $numbd esiste già. Si passa al successivo." 40 60 >/dev/tty
	else 
		 jigdo-lite http://cdimage.debian.org/cdimage/archive/$path/$piattaforma/jigdo-$tipo/$nome.jigdo
		if [ $? -eq 1 ]; then
			dialog	--msgbox "Si è verificato un errore, il file http://cdimage.debian.org/cdimage/archive/$path/$piattaforma/jigdo-$tipo/$nome.jigdo non è stato trovato. Il programma termina." 40 60 >/dev/tty
			exit 1
		fi
	fi
	i=`expr $i + 1`	
done
dialog	--msgbox "Copyright 2021 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nDedicato a Annachiara Milano.\nHappy Hacking :)" 40 60

exit 0
