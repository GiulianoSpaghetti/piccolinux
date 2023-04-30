# Copyright 2023 Giulio Sorrentino, Some Right Reserved
# Parameters: number of processors to use
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc wget

if [ $# -ne 1 ]; then
echo "Bisogna passare due parametri: il primo il numero di processori da utilizzare, il secondo il nome della propria home directory di windows. Il programma termina."
exit
fi

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux--msft-wsl-$(uname -r | cut -d -f 1).tar.gz

tar -xfv linux-msft-wsl-$(uname -r | cut -d - -f 1).tar.gz
cat /proc/config.gz | gunzip > .config
make oldconfig
make prepare modules_prepare

make -j $1
sudo make install

echo "[network]
generateResolvConf = false" > /etc/wsl.conf
