# Copyright 2023 Giulio Sorrentino, Some Right Reserved
# This script is under GPL v3 or, in your humble opinion, any later version 
# original source: https://gist.github.com/charlie-x/96a92aaaa04346bdf1fb4c3621f3e392#file-gistfile1-txt-L31
# Parameters: number of processors to use
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc wget libncurses-dev python3

if [ $# -ne 1 ]; then
echo "Bisogna un parametro: il numero di processori da utilizzare. Il programma termina."
exit
fi

if  [ -f  linux-msft-wsl-$(uname -r | cut -d - -f 1).tar.gz ]; then
	rm  linux-msft-wsl-$(uname -r | cut -d - -f 1).tar.gz
fi
wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-$(uname -r | cut -d - -f 1).tar.gz

tar -xvf  linux-msft-wsl-$(uname -r | cut -d - -f 1).tar.gz
cd WSL2-Linux-Kernel-linux-msft-wsl-$(uname -r | cut -d - -f 1)
cat /proc/config.gz | gunzip > .config
make menuconfig
make prepare modules_prepare

make -j $1
sudo make install

