#!/bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

function installPrerequisites {
apt-get install qemu-user-static debootstrap rsync wget dialog -y
}

function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function checkParameters {
if [ $1 -ne 1 ]; then
	dialog --title "Errore" \
	--backtitle "Errorei" \
	--msgbox "Bisogna specificare la directory d'installazione come parametro.\nIl programma sara' terminato" 7 60
	return 1
fi
return 0
}

function selectDistro {
dialog --backtitle "Quale init selezionare" \
--radiolist "Quale init selezionare:" 10 40 2 \
 1 "Buster" on \
 2 "Bullseye" off  >/dev/tty 2>/tmp/result.txt 
if [ $? -eq 0 ]; then
	quale=`cat /tmp/result.txt`
else
	quale=0
fi
rm /tmp/result.txt
return $quale
}


function umountSystem {
umount ${1}/proc
umount ${1}/sys
umount ${1}/dev/pts
umount ${1}/dev
}

function mountSystem {
mount -o bind /proc ${1}/proc
mount -o bind /sys ${1}/sys
mount -o bind /dev ${1}/dev
mount -o bind /dev/pts ${1}/dev/pts
}

function removeSystemFiles {
rm ${1}/etc/fstab
rm ${1}/etc/hostname
rm ${1}/etc/apt/sources.list
}

function createfstab {
echo "proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1" >> ${1}/etc/fstab
}

function createhostname {
echo "${1}-rpi64" >> ${2}/etc/hostname
}

function createaptsource {
echo "deb http://debian.fastweb.it/debian/ $quale main contrib non-free
deb-src http://debian.fastweb.it/debian/ $quale main contrib non-free
deb http://debian.fastweb.it/debian/ ${1}-updates main contrib non-free
deb-src http://debian.fastweb.it/debian/ ${1}-updates main contrib non-free
deb http://security.debian.org/debian-security  ${1}/updates main contrib
deb-src http://security.debian.org/debian-security  ${1}/updates main contrib
deb http://debian.fastweb.it/debian ${1}-backports main contrib non-free
deb-src http://debian.fastweb.it/debian ${1}-backports main contrib non-free" >> ${2}/etc/apt/sources.list
}

function getSd {
result=1;
while [[ $result -eq 1 ]]; do
	dialog --title "inserire Dispostivo a blocchi" \
	--backtitle "Inserire Dispositivo a blocchi" \
	--inputbox "Inserire il dispositivo a blocchi relativo la scheda microsd gia' partizionata da montare." 8 60 2>/tmp/result.txt
	result=$?
done
}

function umountsd {
umount /dev/${1}1
umount /dev/${1}2
}

function attendi {
echo "Attendi $1 secondi"
sleep $1
}

function preambolo {
dialog --title "Informazioni" \
	--backtitle "Informazioni" \
	--msgbox "Il sistema non si basa più su file statici presenti su github, ma si basa su di un repository privato
che corrisponde all'indirizzo numeronesoft.ddns.net. Se non lo attaccate è meglio :)
Ad ogni modo, non sono in grado di garantire un online  24/h su 24n del repository, 
per cui se dice address not found riprovate tra qualche ora.
Grazie." 40 60
}


notRoot

installPrerequisites

checkParameters $#

if [ $? -eq 1 ]; then
	exit 1
fi


preambolo

selectDistro

case $? in

1) quale=buster
;;

2) quale=bullseye
;;
3) quale=stretch
;;
*)
	dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Parametro non valido" 7 60
exit 1
;;
esac

debootstrap --arch=arm64 $quale ${1}
umountSystem $1
mountSystem $1

removeSystemFiles $1

createfstab $1
createhostname $quale $1
createaptsource $quale $1


cp ./project_milano1.sh ${1}
	dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Eseguire lo script project_milano1.sh" 7 60

chroot ${1}
rm ${1}/project_milano1.sh
umountSystem $1
getSd
sd=`cat /tmp/result.txt`
rm /tmp/result.txt

attendi 10

umountsd $sd

attendi 5

mkdir /media/piccolinux
mkdir /media/piccolinuxboot

mount /dev/${sd}1 /media/piccolinuxboot
mount /dev/${sd}2 /media/piccolinux

dialog --title "Informazioni" \
	--backtitle "Informazioni" \
	--msgbox "Il software potrebbe dare l'impressione di andare in blocco. E' normale.\nAttendere la fine dell'esecuzione, senza andare in paranoia. Grazie :)" 40 60

rsync -a --info=progress2 --remove-source-files ${1}/boot/* /media/piccolinuxboot
umount /dev/${sd}1

attendi 5
rmdir /media/piccolinuxboot

rsync -avh --remove-source-files --exclude "${1}/dev:${1}/sys:${1}/proc" ${1}/* /media/piccolinux
chmod 755 /media/piccolinux
umount /dev/${sd}2

attendi 15

find ${1} -type d -empty -delete
mkdir ${1}
rmdir /media/piccolinux

dialog --title "Tutto fatto" \
	--backtitle "OK" \
	--msgbox "La microsd e' stata smontata. Metterla nel raspberry per vederne i risultati.\nRicordatevi di chiudere e disabilitare le socket systemd-initctl e systemd-udevd-control.\nCopyright 2020 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.Dedicato a Francesca dei centri sociali (san severino? milano? salerno?)\nHappy Hacking :)" 40 60

