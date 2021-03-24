#!/bin/bash
#Autore: Giulio Sorrentino <gsorre84@gmail.com>

sudo apt install dpkg-dev devscripts -y

sudo apt source unrar
sudo apt build-dep unrar
cd unrar-nonfree-?.?.?
dpkg-buildpackage
cd ..
mv unrar_*.deb ./Scaricati
mv libunrar*.deb ./Scaricati
rm -rf *unrar*
sudo dpkg -i ./Scaricati/unrar_*.deb
