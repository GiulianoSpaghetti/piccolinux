#!/bin/bash
#Autore: Giulio Sorrentino <gsorre84@gmail.com>

sudo apt install dpkg-dev devscripts -y

apt source rar
cd rar-*
debuild -us -uc -nc
cd ..
mv rar_*.deb ./Scaricati
rm -rf rar*
sudo dpkg -i ./Scaricati/rar_*.deb
