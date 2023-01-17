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
	--backtitle "Errori" \
	--msgbox "Bisogna specificare la directory d'installazione come parametro.\nIl programma sarà terminato" 7 60
	return 1
fi
return 0
}

function preambolo {
	dialog --title "Informazioni" \
	--backtitle "Informazioni" \
	--msgbox "Prima bisogna aggionare il boot loader del raspberry all'ultima versione, poi bisogna partizionare un hard disk come segue: una partizione boot da almeno 1 gb all'inizio del disco creata come prima partizione, una partizione ext4 root come seconda partizione ed una partizione fat32 con flag esp come terza partizione. Premere ok per continuare." 15 60
}

function postambolo {
	dialog --title "Informazioni" \
	--backtitle "Informazioni" \
	--msgbox "Adesso bisogna premere esc quando appare il logo del raspberry, andare in BOOT MAINTENCE MANAGER  e selezionare BOOT OPTION e poi ADD BOOT OPTION, selezionare la seconda partizione e scegliere la path EFI/DEBIAN/GRUBAA64.efi, indicare come descrizione Debian e salvare. Poi premete esc per andare indietro e andate in CHANGE BOOT ORDER, premete invio usate i tasti direzionali per spostarvi su debian e premete + finché non sarà la prima opzione. A questo punto premete f10 per salvare e premete sempre esc. Se il kernel dà errore fsck.ext4 va reinstallato. Enjoy " 15 60
}

function selectDistro {
quale=$(dialog --output-fd 1 --backtitle "Quale versione selezionare" \
--radiolist "Quale versione selezionare:" 10 70 4 \
 1 "Bookworm (necessario per il PI 400)" off \
 2 "bullseye" on \
 3 "Buster" off \
 4 "Stretch" off) 
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
/dev/sda1  /boot           vfat    defaults          0       2
/dev/sda2  /               ext4    defaults,noatime  0       1
/dev/sda3 /boot/efi	vfat	umask=0077 	0	1" >> ${1}/etc/fstab
}

function createhostname {
echo "${1}-rpi64" >> ${2}/etc/hostname
}

function createaptsource {
echo "deb http://deb.debian.org/debian/ $quale main contrib non-free
deb-src http://deb.debian.org/debian/ $quale main contrib non-free
deb http://deb.debian.org/debian/ ${1}-updates main contrib non-free
deb-src http://deb.debian.org/debian/ ${1}-updates main contrib non-free
deb http://deb.debian.org/debian ${1}-backports main contrib non-free
deb-src http://deb.debian.org/debian ${1}-backports main contrib non-free">> ${2}/etc/apt/sources.list
if [ $quale = "bookworm" ]; then
echo "deb http://security.debian.org/debian-security  ${1}-security main contrib
deb-src http://security.debian.org/debian-security  ${1}-security main contrib">> ${2}/etc/apt/sources.list
elif [ $quale = "bullseye" ]; then
echo "deb http://security.debian.org/debian-security  ${1}-security main contrib
deb-src http://security.debian.org/debian-security  ${1}-security main contrib">> ${2}/etc/apt/sources.list
else
echo "deb http://security.debian.org/debian-security  ${1}/updates main contrib
deb-src http://security.debian.org/debian-security  ${1}/updates main contrib">> ${2}/etc/apt/sources.list
fi
}


function getSdd {
result=1;
while [[ $result -eq 1 ]]; do
	dialog --title "inserire dispostivo a blocchi" \
	--backtitle "Inserire dispositivo a blocchi" \
	--inputbox "Inserire il nome del dispositivo a blocchi relativo l'hard disk gia' partizionato da montare senza la path." 8 60 2>/tmp/result.txt
	result=$?
done
}

function umountsdd {
umount /dev/${sdd}3
umount /dev/${sdd}2
umount /dev/${sdd}1
}


notRoot

installPrerequisites

checkParameters $#

preambolo

getSdd
sdd=`cat /tmp/result.txt`
rm /tmp/result.txt

mount /dev/${sdd}2 ${1}
mkdir ${1}/boot
mount /dev/${sdd}1 ${1}/boot
mkdir ${1}/boot/efi
mount /dev/${sdd}3 ${1}/boot/efi

if [ $? -eq 1 ]; then
	exit 1
fi


selectDistro

case $? in

1) quale=bookworm
;;

2) quale=bullseye
;;
3) quale=buster
;;
4) quale=stretch
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

#attendi 10

chmod 755 ${1}
chown root:root ${1}
umountsdd 

postambolo

dialog --title "Tutto fatto" \
	--backtitle "OK" \
	--msgbox "L'hard disk è stato smontato. Collegarlo al raspberry per vederne i risultati.\nRicordatevi di chiudere e disabilitare le socket systemd-initctl e systemd-udevd-control.\nCopyright 2023 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal.\nHappy Hacking :)" 40 60

