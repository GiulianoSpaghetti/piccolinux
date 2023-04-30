# Copyright 2023 Giulio Sorrentino, Some Right Reserved
# original source: https://gist.github.com/charlie-x/96a92aaaa04346bdf1fb4c3621f3e392#file-gistfile1-txt-L31
# Parameters: number of processors to use
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc wget

if [ $# -ne 1 ]; then
echo "Bisogna un parametro: il numero di processori da utilizzare. Il programma termina."
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
generateResolvConf = false" | sudo tee -a /etc/wsl.conf > /dev/null
