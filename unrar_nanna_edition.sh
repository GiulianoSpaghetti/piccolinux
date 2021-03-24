#!/bin/bash
#Autore: Giulio Sorrentino <gsorre84@gmail.com>

sudo apt install dpkg-dev devscripts -y

apt source unrar
apt build-dep unrar
cd unrar-nonfree-?.?.?
dpkg-buildpackage
cd ..
mv unrar_*.deb ./Scaricati
mv libunrar*.eb ./Scaricati
rm -rf *unrar*
sudo dpkg -i ./Scaricati/unrar_*.deb
