#!/bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "Lo script deve essere avviato da root" 1>&2
   exit 1
fi

if [ $# -ne 1 ]; then
	echo "Bisogna passare la directory di installazione. Il programma termina."
	exit 1
fi

apt-get install qemu-user-static debootstrap rsync wget -y

echo "1: buster
2: bullseye
3: stretch
Indicare su quale debian si vuole basare il piccolinux: "

read quale

case $quale in

1) quale=buster
;;

2) quale=bullseye
;;
3) quale=stretch
;;
*)
echo "Parametro non valido"
exit
;;
esac

debootstrap --arch=arm64 $quale ${1}

umount ${1}/proc
umount ${1}/sys
umount ${1}/dev
umount ${1}/dev/pts

mount -o bind /proc ${1}/proc
mount -o bind /sys ${1}/sys
mount -o bind /dev ${1}/dev
mount -o bind /dev/pts ${1}/dev/pts

rm ${1}/etc/fstab
rm ${1}/etc/hostname
rm ${1}/etc/apt/sources.list

echo "proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1" >> ${1}/etc/fstab

echo "$quale-rpi64" >> ${1}/etc/hostname

echo "deb http://debian.fastweb.it/debian/ $quale main contrib non-free
deb-src http://debian.fastweb.it/debian/ $quale main contrib non-free

deb http://debian.fastweb.it/debian/ $quale-updates main contrib non-free
deb-src http://debian.fastweb.it/debian/ $quale-updates main contrib non-free

deb http://security.debian.org/debian-security  $quale/updates main contrib
deb-src http://security.debian.org/debian-security  $quale/updates main contrib

deb http://debian.fastweb.it/debian $quale-backports main contrib non-free
deb-src http://debian.fastweb.it/debian $quale-backports main contrib non-free" >> ${1}/etc/apt/sources.list

cp ./project_milano1.sh ${1}
echo "Eseguire lo script project_milano1.sh"

chroot ${1}

umount ${1}/dev/pts
umount ${1}/dev
umount ${1}/sys
umount ${1}/proc

echo "Attendi 10 secondi"
sleep 10

echo "Inserire il dispositivo a blocchi relativo la scheda microsd già partizionata da montare."
read sd

umount /dev/${sd}1
umount /dev/${sd}2

echo "Attendi 5 secondi"
sleep 5

mkdir /media/piccolinux
mkdir /media/piccolinuxboot

mount /dev/${sd}1 /media/piccolinuxboot
mount /dev/${sd}2 /media/piccolinux


rsync -avh --remove-source-files ${1}/boot/* /media/piccolinuxboot
umount /dev/${sd}1

echo "Attendi 5 secondi"
sleep 5

rmdir /media/piccolinuxboot

rsync -avh --remove-source-files ${1}/* /media/piccolinux
umount /dev/${sd}2

echo "Attendi 15 secondi"
sleep 15

find ${1} -type d -empty -delete
rmdir /media/piccolinux

echo "Tutto fatto. La microsd è stata smontata. Metterla nel raspberry per vederne i risultati. Ricordatevi di chiudere e disabilitare le socket systemd-initctl e systemd-udevd-control.
Happy Hacking :)"

