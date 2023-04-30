# Copyrigth 2023 Giulio Sorrentino, Some Right Reserved
# original source: https://gist.github.com/charlie-x/96a92aaaa04346bdf1fb4c3621f3e392#file-gistfile1-txt-L31
#!/bin/bash
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev bc git

if [ $# -ne 2 ]; then
echo "Bisogna passare due parametri: il primo il numero di processori da utilizzare, il secondo il nome della propria home directory di windows. Il programma termina."
exit
fi

#git clone https://github.com/microsoft/WSL2-Linux-Kernel.git


cd WSL2-Linux-Kernel/
cat /proc/config.gz | gunzip > .config
#make oldconfig
#make prepare modules_prepare

#make -j $1
#sudo make install

#cp vmlinux /mnt/c/Users/${2}/
if [ -f /mnt/c/Users/${2}/.wslconfig ]; then
mv /mnt/c/Users/${2}/.wslconfig /mnt/c/Users/${2}/wslconfig.old
echo "Backuppato il vecchio wslconfig"
fi
echo "[wsl2]
kernel=C:\\\\Users\\\\${2}\\\\vmlinux" | sudo tee -a /mnt/c/Users/${2}/.wslconfig > /dev/null
 
