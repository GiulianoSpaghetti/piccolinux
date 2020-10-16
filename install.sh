#!/bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

if [ $# -ne 1 ]; then
echo "Errore: indicare la path dove salvare i files."
exit
fi

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "Lo script deve essere avviato da root" 1>&2
   exit 1
fi

apt install qemu-user-static debootstrap rsync wget -y

echo "1: buster
2: bullseye
3: sid
Indicare su quale debian si vuole basare il piccolinux: "

read quale

case $quale in

1) quale=buster
wget http://ftp.it.debian.org/debian/pool/main/u/u-boot/u-boot-rpi_2016.11+dfsg1-4_arm64.deb -O /tmp/u-boot-rpi.deb
;;
2) quale=bullseye
wget http://ftp.it.debian.org/debian/pool/main/u/u-boot/u-boot-rpi_2019.01+dfsg-7_arm64.deb -O /tmp/u-boot-rpi.deb
;;
3) quale=sid
;;
*)
echo Parametro non valido
exit
;;
esac

debootstrap --arch=arm64 $quale ${1}

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

deb http://security.org/debian-security $quale-updates main contrib non-free
deb-src http://security.debian.org/debian-security $quale-updates main contrib non-free

deb http://debian.fastweb.it/debian $quale-backports main contrib non-free
deb-src http://debian.fastweb.it/debian $quale-backports main contrib non-free" >> ${1}/etc/apt/sources.list

cp ./install_2.sh ${1}/install_2.sh
echo Eseguire lo script install_2.sh

mv /tmp/u-boot-rpi.deb ${1}/tmp/

chroot ${1}

echo "Attendi 10 secondi"
sleep 10

umount ${1}/dev/pts
umount ${1}/dev
umount ${1}/sys
umount ${1}/proc

echo "Inserire il dispositivo a blocchi relativo la scheda microsd già partiuzionata da montare."
read sd

mkdir /media/piccolinux
mkdir /media/piccolinuxboot

echo "Attendi 5 secondi"
sleep 5

sudo umount /dev/sd/${sd}1
sudo umount /dev/sd/${sd}2

echo "Attendi 5 secondi"
sleep 5

sudo mount /dev/${sd}2 /media/piccolinux
sudo mount /dev/${sd}1 /media/piccolinuxboot

rsync -avh ${1}/boot/* /media/piccolinuxboot
rsync -avh --exclude "boot" ${1}/* /media/piccolinux/

echo "Attendi 15 secondi"
sleep 15

umount /dev/${sd}2
umount /dev/${sd}1
rmdir /media/piccolinux
rmdir /media/piccolinuxboot
echo "Tutto fatto. La microsd è stata smontata. Metterla nel raspberry per vederne i risultati.
Happy Hacking :)"
