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

echo "Inserire il dispositivo a blocchi relativo la scheda microsd già partiuzionata da montare."
read sd

mkdir /media/piccolinux
mkdir /media/piccolinuxboot

umount /dev/${sd}1
umount /dev/${sd}2

echo "Attendi 5 secondi"
sleep 5

mount /dev/${sd}2 /media/piccolinux
echo "Attendi 5 secondi"
sleep 5
mount /dev/${sd}1 /media/piccolinuxboot

echo "1: buster
2: bullseye
Indicare su quale debian si vuole basare il piccolinux: "

read quale

case $quale in

1) quale=buster
#mkdir -p /tmp/buster/libdrm
#mkdir -p /tmp/buster/mesa
#wget -O /tmp/buster/libdrm/libdrm-amdgpu1_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-amdgpu1_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-common_2.4.101~git_all.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-common_2.4.101~git_all.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-dev_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-dev_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-etnaviv1_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-etnaviv1_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-freedreno1_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-freedreno1_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-kms_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-kms_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-nouveau2_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-nouveau2_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-radeon1_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-radeon1_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm-tegra0_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm-tegra0_2.4.101~git_arm64.deb?raw=true
#wget -O /tmp/buster/libdrm/libdrm2_2.4.101~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/libdrm/libdrm2_2.4.101~git_arm64.deb?raw=true

#wget -O /tmp/buster/mesa/libegl1-mesa_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libegl1-mesa_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libegl1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libegl1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgbm1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgbm1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgbm1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgbm1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgbm1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgbm1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgl1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgl1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libglapi-mesa_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libglapi-mesa_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgles1_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgles1_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/libgles2-mesa_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/mesa-va-drivers_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/mesa-va-drivers_20.0.6~git_arm64.deb?raw=true
#wget -O /tmp/buster/mesa/mesa-vdpau-drivers_20.0.6~git_arm64.deb https://github.com/numerunix/piccolinux/blob/main/piccolinux/buster/mesa/mesa-vdpau-drivers_20.0.6~git_arm64.deb?raw=true
;;

2) quale=bullseye
;;
*)
echo Parametro non valido
exit
;;
esac

debootstrap --arch=arm64 $quale /media/piccolinux

umount /media/piccolinux/proc
umount /media/piccolinux/sys
umount /media/piccolinux/dev
umount /media/piccolinux/dev/pts

mount -o bind /proc /media/piccolinux/proc
mount -o bind /sys /media/piccolinux/sys
mount -o bind /dev /media/piccolinux/dev
mount -o bind /dev/pts /media/piccolinux/dev/pts

rm /media/piccolinux/etc/fstab
rm /media/piccolinux/etc/hostname
rm /media/piccolinux/etc/apt/sources.list

echo "proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1" >> /media/piccolinux/etc/fstab

echo "$quale-rpi64" >> /media/piccolinux/etc/hostname

echo "deb http://debian.fastweb.it/debian/ $quale main contrib non-free
deb-src http://debian.fastweb.it/debian/ $quale main contrib non-free

deb http://debian.fastweb.it/debian/ $quale-updates main contrib non-free
deb-src http://debian.fastweb.it/debian/ $quale-updates main contrib non-free

deb http://security.debian.org/debian-security  $quale/updates main contrib
deb-src http://security.debian.org/debian-security  $quale/updates main contrib

deb http://debian.fastweb.it/debian $quale-backports main contrib non-free
deb-src http://debian.fastweb.it/debian $quale-backports main contrib non-free" >> /media/piccolinux/etc/apt/sources.list

cp ./install_2.sh /media/piccolinux/install_2.sh
echo Eseguire lo script install_2.sh

#mv /tmp/u-boot-rpi.deb /media/piccolinux/tmp/
#mv /tmp/buster /media/piccolinux/mnt

chroot /media/piccolinux

echo "Attendi 10 secondi"
sleep 10

umount /media/piccolinux/dev/pts
umount /media/piccolinux/dev
umount /media/piccolinux/sys
umount /media/piccolinux/proc


rsync -avh /media/piccolinux/boot/* /media/piccolinuxboot
rm -rf /media/piccolinux/boot/*

umount /dev/${sd}2
umount /dev/${sd}1

echo "Attendere 10 secondi"
echo "Attendi 15 secondi"
sleep 15

rmdir /media/piccolinux
rmdir /media/piccolinuxbooy
echo "Tutto fatto. La microsd è stata smontata. Metterla nel raspberry per vederne i risultati. Ricordatevi di chiudere e disabilitare le socket systemd-initctl e systemd-udevd-control.
Happy Hacking :)"
