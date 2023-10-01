# Copyright 2023 Giulio Sorrentino, Some Right Reserved
# This script is under GPL v3 or, in your humble opinion, any later version 
# Parameters: version of kernel, number of processors to use and path of the windows home directory
# original source: https://gist.github.com/charlie-x/96a92aaaa04346bdf1fb4c3621f3e392#file-gistfile1-txt-L31
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc wget python3

if [ $# -ne 3 ]; then
echo "Bisogna passare tre parametri: il primo è il numero di kernel, il secondo è il numero di processori da utilizzare, il secondo il nome della propria home directory di windows. Il programma termina."
exit
fi

if [ -f linux-msft-wsl-${1}.tar.gz ]; then
rm linux-msft-wsl-${1}.tar.gz
fi

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-${1}.tar.gz
tar -xvf linux-msft-wsl-${1}.tar.gz

cd WSL2-Linux-Kernel-linux-msft-wsl-${1}
cat /proc/config.gz | gunzip > .config
make oldconfig
make prepare modules_prepare

make -j $2
sudo make install

cp vmlinux /mnt/c/Users/${3}/
if [ -f /mnt/c/Users/${3}/.wslconfig ]; then
mv /mnt/c/Users/${3}/.wslconfig /mnt/c/Users/${3}/wslconfig.old
echo "Backuppato il vecchio wslconfig"
fi
echo "[wsl2]
kernel=C:\\\\Users\\\\${3}\\\\vmlinux" | sudo tee -a /mnt/c/Users/${3}/.wslconfig > /dev/null
