# Copyright 2023 Giulio Sorrentino, Some Right Reserved
# Parameters: number of processors to use, name of the windows home directory
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc git

if [ $# -ne 2 ]; then
echo "Non sono stati passati due parametri, il programma termina."
exit
fi

git clone https://github.com/microsoft/WSL2-Linux-Kernel.git


cd WSL2-Linux-Kernel/
cat /proc/config.gz | gunzip > .config
make oldconfig
make prepare modules_prepare

make -j $1
sudo make install

cp vmlinux /mnt/c/Users/$2/
echo "[wsl2]
kernel=C:\\Users\\<yourwindowsloginname>\\vmlinux" > /mnt/c/Users/<yourwindowsloginname>/.wslconfig

echo "[network]
generateResolvConf = false" > /etc/wsl.conf
