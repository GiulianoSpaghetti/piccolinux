#! /bin/bash
#autore Giulio Sorrentino <gsorre84@gmail.com>

function installPrerequisites {
apt-get install dialog -y
}

function notRoot {
if [[ $EUID -ne 0 ]]; then
	echo "Lo script deve essere avviato da root"
   	exit 1
fi
}

function checkSystem {
if [ ! -f "/etc/debian_version" ]; then
	echo "Non sei su debian." 
	exit 1
fi
}

function installLibDrm {
	cd /tmp
	mkdir lidrm
	cd libdrm
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-amdgpu1_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-common_2.4.105-1-francy_all.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-etnaviv1_2.4.105-1-francy_arm64.deb	
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-freedreno1_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-libkms_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-nouveau2_2.4.105-1-francy_arm64.deb	
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-radeon1_2.4.105-1-francy_arm64.deb 
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-tegra0_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-tests_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm2_2.4.105-1-francy_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-dev_2.4.105-1-francy_arm64.deb
	dpkg -i *.deb
	cd ..
	rm -rf libdrm 
}

function InstallLibMesa {
	cd /tmp
	mkidr mesa
	cd mesa
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libd3dadapter9-mesa_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libegl-mesa0_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libegl1-mesa_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libegl1_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgbm1_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgl1-mesa-dri_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgl1-mesa-glx_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgl1_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libglapi-mesa_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgles2-mesa_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libgles2_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libglx-mesa0_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/libosmesa6_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/mesa-opencl-icd_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/mesa-va-drivers_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/mesa-vdpau-drivers_20.3.5-1-chiacchio_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/20.3.5-chiacchio/mesa-vulkan-drivers_20.3.5-1-chiacchio_arm64.deb
	dpkg -r --force-depends libglvnd0 libglx0
	dpkg -i *.deb
	cd ..
	rm -rf mesa
}
notRoot
checkSystem
installPrerequisites


dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Eseguo le operazioni, rimuovendo libglvnd0 e libglx0.\n
Purtroppo raspberry sta togliendo i pacchetti necessari all'installazione dei miei dai loro repository, per cui dovete abilitare il repository backports di debian.\nFatelo prima di premere ok." 40 60
dpkg -r --force-depends libglvnd0 libglx0
installLibDrm
InstallLibMesa
apt-get -f install

dialog --title "Informazioni" --backtitle "Informazioni" --msgbox "Copyright 2021 Gulio Sorrentino\nConcesso in licenza secondo la GPL v3 o, secondo la tua opinione, qualsiasi versione successiva.\nIlsoftware viene concesso per come è, senza nessuna garanzia, né implicita né esplicita.\nSe ti è sembrato interessante considera una donazione su paypal.\nDedicato a Francesca dei centri sociali (san severino? milano? salerno?)" 40 60
