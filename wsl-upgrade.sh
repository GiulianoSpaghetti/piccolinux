# Copyrigth 2023 Giulio Sorrentino, Some Right Reserved
# original source: https://gist.github.com/charlie-x/96a92aaaa04346bdf1fb4c3621f3e392#file-gistfile1-txt-L31
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc wget

if [ $# -ne 2 ]; then
echo "Bisogna passare due parametri: il primo il numero di processori da utilizzare, il secondo il nome della propria home directory di windows. Il programma termina."
exit
fi

if [ -f linux-msft-wsl-6.1.21.1.tar.gz ]; then
rm linux-msft-wsl-6.1.21.1.tar.gz
fi

wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-6.1.21.1.tar.gz
tar -xfv linux-msft-wsl-6.1.21.1.tar.gz

cd WSL2-Linux-Kernel-linux-msft-wsl-6.1.21.1.tar.gz
cat /proc/config.gz | gunzip > .config
make oldconfig
make prepare modules_prepare

make -j $1
sudo make install

cp vmlinux /mnt/c/Users/${2}/
if [ -f /mnt/c/Users/${2}/.wslconfig ]; then
mv /mnt/c/Users/${2}/.wslconfig /mnt/c/Users/${2}/wslconfig.old
echo "Backuppato il vecchio wslconfig"
fi
echo "[wsl2]
kernel=C:\\\\Users\\\\${2}\\\\vmlinux" | sudo tee -a /mnt/c/Users/${2}/.wslconfig > /dev/null
 
