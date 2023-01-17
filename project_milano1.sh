#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

function aggiungiRepo {
case $sistema in
	12) dialog --title "Repository non disponibile" \
--backtitle "Repository non disponibile" \
--msgbox "Il repository non è disponibile per bookworm" 7 60
	return 0
	;;
	11) repo="bullseye"
	;; 
	10) repo="buster";;
	*) repo="strech";;
esac
echo "deb http://numeronesoft.ddns.net/ ${repo} main "> /etc/apt/sources.list.d/numeronesoft.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52B68EEB
return 1
}

function notRoot {
if [[ $EUID -ne 0 ]]; then
	dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Lo script deve essere avviato da root" 7 60
   	return 1
fi
	return 0
}


function InstallMTA {
dialog --title "Installazione MTA" \
--backtitle "Installazione server di posta" \
--yesno "Linux utilizza un sistema di messaggistica interno che viene attivato nel momento in cui viene installato (perr esempio abuso di sudo), solo che non si può leggere perché non c'è nessun server dui posta per ricevere l'email.\n
VUoi tu installare postfix e selezionare solo messaggistica locale per leggere i messaggi inviati da linux?" 15 60
return $?
}

function checkSystem {
read -d / sistema < /etc/debian_version
if [ $sistema = "bookworm" ]; then
	sistema=12
elif [ $sistema = "bullseye" ]; then
	sistema=11
else
	read -d . sistema < /etc/debian_version
fi
return $sistema
}

function selezionaInit {
quale=$(dialog --output-fd 1 --backtitle "Quale init selezionare" \
--radiolist "Quale init selezionare:" 10 40 3 \
 1 "System D" off \
 2 "SysV" on \
 3 "runit" off)
if [ $? -eq 0 ]; then
	init=$quale
else
	init=0
fi
return $init
}

function selezionaDesktop {
quale=$(dialog --output-fd 1 --backtitle "Quale desktop selezionare" \
--radiolist "Quale desktop selezionare" 20 40 9 \
1 "Gnome" off \
2 "Cinnamon" off \
3 "KDE" off \
4 "LXDE" off \
5 "LXQT" off \
6 "XFCE" on \
7 "IceWM" off \
8 "Openbox" off)
if [ $? -eq 0 ]; then
	desktop=$quale
else
	desktop=0
fi
return $desktop
}

function selezionaLogin {
quale=$(dialog --output-fd 1 --backtitle "Quale schermata di login utilizzare" \
--radiolist "Quale schermata di login utilizzare" 20 40 6 \
1 "GDM3" off \
2 "SDDM" off \
3 "Lightdm" on \
4 "Wdm" off \
5 "LXdm" off \
6 "Xdm" off)
if [ $? -eq 0 ]; then
	login=$quale
else
	login=0
fi
return $login
}

function selezionaInstallazioneLingua {
dialog --title "Installazione traduzioni" \
--backtitle "Installazione traduzioni" \
--yesno "Vuoi installare le traduzioni per le applicazioni piu' comuni?" 7 60
return $?
}

function selezionaInstallazioneBootLoader {
dialog --title "Installazione BootLoader" \
--backtitle "Installazione BootLoder" \
--yesno "Vuoi installare il bootloader PROPRIETARIO? (senza non si avvia, ma con non puoi diffondere l'immagine della microsd)." 7 60
return $?
}

function selezionaInstallazioneWallpapers {
dialog --title "Installazione Wallpapers" \
--backtitle "Installazione Wallpaprs" \
--yesno "Vuoi installare i wallpaper sotto licenza ShareALike 4.0 international?" 7 60
return $?
}

function aggiornaSid {
dialog --title "Aggiornamento a SID" \
--backtitle "Aggiornamento a SID" \
--yesno "E' caldamente consigliato l'aggiornamento a debian Sid che, sebbene sperimentale, accelera il testing del nuovo wayland consentendo così una maggiore velocità di sviluppo dei futuri debian, a scapito della stabilità di sistema e della sicurezza dei propri files. Vuoi procedere?"  10 60
return $?
}

function installLibDrm {
if [ ! -f /etc/apt/souces.list.d/numeronesoft.list ]; then
	aggiungiRepo
fi
if [ $? -eq 1 ]; then
apt update
apt upgrade
fi
}

function InstallLibMesa {
if [ ! -f /etc/apt/souces.list.d/numeronesoft.list ]; then
	aggiungiRepo
fi
if [ $? -eq 1 ]; then
apt update
apt upgrade
apt install libegl1 libgl1 libgles2
fi
} 

function abilitaDriverVideo {
dialog --title "Installazione driver video" \
--backtitle "Installazione driver video" \
--yesno "Vuoi installare i driver video (obbligatori per buster, sono necessari i repository backports di debian)?" 7 60
return $?
}

function selezionaBriscola {
dialog --title "Installazione briscola" \
--backtitle "Installazione briscola" \
--yesno "Vuoi installare la briscola?" 7 60
return $?
}

function InstallBriscola {
if [ ! -f /etc/apt/souces.list.d/numeronesoft.list ]; then
	aggiungiRepo
fi
if [ $? -eq 1 ]; then
apt update
apt install wxbriscola wxbriscola-i18n wxbriscola-mazzi-hd-napoletano wxbriscola-mazzi-hd-dr-francy wxbriscola-mazzi-hd-gatti wxbriscola-mazzi-hd-playing-mario
fi
}


function installFirewall {
	dialog --title "Installazione firewall" \
--backtitle "Installazione di un firewall" \
--yesno "Vuoi installare un firewall?" 7 60
if [ $? -eq 0 ]; then
	dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso viene installato il programma che farà parttire il firewall all'avvio, voi dovete solo abilittare il servizio \"netfilter persisent\" e dire che NON volete salvare le regole attuali quando l'installer lo chiede." 40 60

apt-get install iptables-persistent
if [ $init -ne 1 ]; then
	ln -s /etc/init.d/netfilter-persistent /etc/rc3.d/S15netfilter-persistent
	ln -s /etc/init.d/netfilter-persistent /etc/rc4.d/S15netfilter-persistent
	ln -s /etc/init.d/netfilter-persistent /etc/rc5.d/S15netfilter-persistent
fi
mkdir /etc/iptables
cd /etc/iptables
wget https://raw.githubusercontent.com/numerunix/piccolinux/main/iptables-save/rules/rules.v4
fi
}


notRoot

if [ $? -eq 1 ]; then
	exit 1;
fi

apt-get update
apt-get upgrade
apt-get install dialog wget -y

checkSystem
sistema=$?


kernel=`apt-cache search ^linux-image-[5-6].[0-9] [0-9]+-arm64$ | cut -d\  -f1`
apt-get install dosfstools $kernel -y


selezionaInit
init=$?

case $init in
1)
	apt-get install systemd
	apt-get remove --purge sysvinit-core runit-init
	initstr=systemd
;;
2) apt-get install sysvinit-core
	apt-get remove --purge systemd runit-init
	initstr=sysvinit-core
	apt-get install --reinstall --purge $(dpkg --get-selections | grep -w 'install$' | cut -f1) $initstr -y
	mv /sbin/start-stop-daemon.REAL /sbin/start-stop-daemon
        apt-mark hold sysvinit-core
        echo "sysvinit-core hold" | sudo dpkg --set-selections
;;
3) initstr="runit"
	if [ $sistema -eq 11 ]; then
		initstr=$initstr-init
	fi
	apt-get install $initstr
	apt-get remove --purge systemd sysvinit-core
	apt-get install --reinstall --purge $(dpkg --get-selections | grep -w 'install$' | cut -f1) $initstr -y
	mv /sbin/start-stop-daemon.REAL /sbin/start-stop-daemon
        apt-mark hold runit-init
        echo "runit-init hold" | sudo dpkg --set-selections

;;
*) dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Scelta non corretta. Si resta con quello gia' fornito" 7 60
	init=1
	initstr=""
;;
esac

apt-get install locales -y
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso verra' configurato il linguaggio" 7 60
dpkg-reconfigure locales

apt install apt-file ntp kbd sudo
apt-file update
apt-get update
apt-get upgrade

selezionaDesktop
desktop=$?

if [ $init -ne 1 ]; then 
	if [ $desktop -lt 3 ] && [ $desktop -gt 0 ]; then 
dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Con init diverso da systemd non si possono installare kde, gnome e cinnamon.\nVerra' installato xfce." 7 60
		desktop=6;
	fi
fi 

case $desktop in
1) desktop=task-gnome-desktop
;;
2) desktop=task-cinnamon-desktop
;;
3) desktop=task-kde-desktop
;;
4) desktop=task-lxde-desktop
;;
5) desktop=task-lxqt-desktop
;;
6) desktop="task-xfce-desktop gvfs-backends"
;;
7) desktop=icewmW
;;
8) desktop=openbox
;;
*) desktop=1
;;
esac

if [ "$desktop" != 1 ]; then
	apt-get install $desktop $initstr
	apt-get remove --purge network-manager* wicd* lightdm

	selezionaLogin
	login=$?
	if [ $init -ne 1 ]; then
		if [ $login = 1 ]; then
dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Con init diverso da systemd si puo' installare non si puo' installare GDM.\nVerra' installato XDM." 7 60
		login=6
		fi
	fi
	case $login in
		1) apt-get install gdm3	 $initstr; temp="gdm3";;
		2) apt-get install sddm $initstr; temp="ssdm";;
		3) apt-get install lightdm  $initstr; temp="lightdm";;
		4) apt-get install wdm 	 $initstr; temp="wdm";;
		5) apt-get install lxdm  $initstr; temp="lxdm";;
		6) apt-get install xdm 	 $initstr; temp="xdm";;
		*) dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Scelta non valida\nSi continua senza login grafico." 7 60

	esac
	if [ $init -eq 1  ]; then
		if [[ $desktop == "task-kde-desktop" ]]; then
			apt-get install plasma-nm
		else 
			if [[ $desktop == "task-lxqt-desktop" ]]; then
				apt install connman-gtk macchanger
		             else	
				apt-get install network-manager-gnome
		     fi
		fi
	else
		apt-get install connman-gtk macchanger $initstr
	fi

else
	dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Si continua senza desktop" 7 60
	if [ $init -eq 1 ]; then
			apt-get install network-manager
	else
		apt-get install connman macchanger $initstr
	fi
fi

selezionaInstallazioneLingua
lingua=$?
        if [ $lingua -eq 0 ]; then

		lang=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1)
		apt install aspell-$lang hunspell-$lang manpages-$lang maint-guide-$lang fortunes-$lang debian-reference-$lang
		if [[ $desktop != 1 ]]; then
			apt-get install  firefox-esr-l10n-$lang thunderbird-l10n-$lang libreoffice-l10n-$lang lightning-l10n-$lang libreoffice-help-$lang mythes-$lang
		fi
		if [[ $desktop == "task-kde-desktop" ]]; then
			apt-get install kde-l10n-$lang
		fi
	fi


apt-get remove --purge ssh* openssh* rpcbind -y

dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso configuriamo il fuso orario" 7 60
dpkg-reconfigure tzdata



dpkg-reconfigure keyboard-configuration

result=1
while [[ $result -eq 1 ]]; do
result=$(dialog --output-fd 1 --title "inserire Nome Utente" \
--backtitle "Inserire nome Utente" \
--inputbox "Inserire il nome utente dell'utente non privilegiato da aggiungere" 8 60)
done

adduser $result
usermod -aG video,audio,cdrom,sudo $user
if [ $desktop != 1 ]; then
usermod -aG plugdev,netdev,lpadmin,scanner,dip $user
fi
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso configuriamo la password di root" 7 60
passwd
echo -n "Premere invio per continuare..."
read dummy;

apt install unzip
cd /tmp
wget https://github.com/pftf/RPi4/releases/download/v1.34/RPi4_UEFI_Firmware_v1.34.zip
unzip ./RPi4_UEFI_Firmware_v1.34.zip -d /boot
rm ./RPi4_UEFI_Firmware_v1.34.zip
cd ..

apt install grub-efi-arm64
grub-install
update-grub

apt-get autoremove
apt-get clean

aggiornaSid
if [ $? -eq 0 ]; then
mv /etc/apt/sources.list /etc/apt/sources.list.old
echo "deb http://deb.debian.org/debian/ sid main
deb-src http://deb.debian.org/debian/ sid main" > /etc/apt/sources.list
apt clean
apt update
apt dist-upgrade -y
mv /etc/apt/sources.list /etc/apt/sources.list.sid
mv /etc/apt/sources.list.old /etc/apt/sources.list
dialog --title "Grazie" \
	--backtitle "Grazie" \
	--msgbox "Grazie per l'aiuto che dai alla comunità" 7 60
else
abilitaDriverVideo
if [ $? -eq 0 ]; then
	installLibDrm
	InstallLibMesa
fi
fi
installFirewall

selezionaBriscola
if [ $? -eq 0 ]; then
	InstallBriscola
fi
InstallMTA
if [ $? -eq 0 ]; then
	apt install postfix
fi

selezionaInstallazioneWallpapers
if [ $? -eq 0 ]; then
	apt install numeronesoft-backgrounds-cornetti
fi 


dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Debian e' pronto. Puoi applicare cambiamenti, tipo installare ulteriore software tramite apt e quando hai finito digita exit.\nCopyright 2023 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal." 40 60

