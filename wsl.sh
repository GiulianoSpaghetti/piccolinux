# Copyrigth 2023 Giulio Sorrentino, Some Right Reserved
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc git

git clone https://github.com/microsoft/WSL2-Linux-Kernel.git


cd WSL2-Linux-Kernel/
cat /proc/config.gz | gunzip > .config
make oldconfig
make prepare modules_prepare

make -j nproc (a numero, non a variabile)
sudo make install

cp vmlinux /mnt/c/Users/<yourwindowsloginname>/
echo "[wsl2]
kernel=C:\\Users\\<yourwindowsloginname>\\vmlinux" > /mnt/c/Users/<yourwindowsloginname>/.wslconfig

echo "[network]
generateResolvConf = false" > /etc/wsl.conf
