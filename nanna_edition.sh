#!/bin/bash
#Autore: Giulio Sorrentino <gsorre84@gmail.com>

sudo apt install dpkg-dev devscripts -y

apt source unrar
cd unrar-*
debuild -us -uc -nc
cd ..
mv unrar_*.deb ./Scaricati
rm -rf *rar*
sudo dpkg -i ./Scaricati/unrar_*.deb
