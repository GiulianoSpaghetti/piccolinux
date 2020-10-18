#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "Lo script deve essere avviato da root" 1>&2
   exit 1
fi

apt-get update
apt-get upgrade

read -d / sistema < /etc/debian_version

if [ $sistema = "bullseye" ]; then
	sistema=11
else
	read d . sistema < /etc/debian_version
fi


echo "1. SystemD
2. Sysv
3. runit
Quale init si desidera utilizzare?"
read init
if [[ $sistema -eq 11 && $init -eq 1 ]]; then
	echo "Scelta non valida. In bullseye attualmente systemd è corrotto. Si userà sysv."
	init=2
fi
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
;;
3) apt-get install runit-init
	apt-get remove --purge systemd sysvinit-core
	initstr=runit-init
	apt-get install --reinstall --purge $(dpkg --get-selections | grep -w 'install$' | cut -f1) $initstr -y
	mv /sbin/start-stop-daemon.REAL /sbin/start-stop-daemon
;;
*) echo "Scelta non corretta, si resta con quello già fornito"
;;
esac

kernel=`apt-cache search ^linux-image-5.[0-9] [0-9]+-arm64$ | cut -d\  -f1`
apt-get install u-boot-rpi $kernel -y

apt-get install locales
echo "Adesso verrà configurata la lingua. Premere invio per continuare."
read dummy;
dpkg-reconfigure locales

apt-get install console-setup keyboard-configuration sudo curl wget dbus usbutils ca-certificates net-tools less fbset debconf-utils avahi-daemon fake-hwclock nfs-common apt-utils man-db pciutils ntfs-3g apt-listchanges wpasupplicant wireless-tools firmware-atheros firmware-brcm80211 firmware-libertas firmware-misc-nonfree firmware-realtek net-tools apt-file tzdata apt-show-versions unattended-upgrades $initstr -y
#apt-get install network-manager #da aggiungere quando systemd sarà apposto
apt-file update

echo "1. Gnome
2. Cinnamon
3. KDE
4. LXDE
5. LXQT
6. XFCE
7. IceWM
8. Openbox
0. Nessuno
Quale desktop si desidera installare?"
read desktop;
if [ $init -ne 1 ]; then 
	if [ $desktop -lt 3 ] && [ $desktop -gt 0 ]; then 
		echo "Scelta non valida. Con init diverso da systemd si può installare non si possono installare kde, gnome e cinnamon. Verrà installato xfce.";
		desktop=6;
	fi
fi 

case $desktop in
1) desktop=task-gnome-deskop
;;
2) desktop=task-cinnamon-desktop
;;
3) desktop=task-kde-desktop
;;
4) desktop=task-lxde-desktop
;;
5) desktop=task-lxqt-desktop
;;
6) desktop=task-xfce-desktop
;;
7) desktop=icewm
;;
8) desktop=openbox
;;
*) desktop=1
;;
esac

if [ $desktop != 1 ]; then
	apt-get install $desktop $initstr
	apt-get remove --purge network-manager* wicd* lightdm

	echo "1. GDM3
2. Lightdm
3 .wdm
4. lxdm
5. xdm
Quale login grafico si desidera utilizzare?"
	read login
	if [ $init -ne 1 ]; then
		if [ $login = 1 ]; then
			echo "Scelta non valida con init diverso da systemd non si può installare gdm. Verrà installato xdm."
			login=5
		fi
	fi
	case $login in
		1) apt-get install gdm3	 $initstr;;
		2) apt-get install lightdm  $initstr;;
		3) apt-get install wdm 	 $initstr;;
		4) apt-get install lxdm  $initstr;;
		5) apt-get install xdm 	 $initstr;;
		*) echo "Scelta non valida" ;;
	esac
	if [ $init -eq 1  ]; then
		apt-get install network-manager-gtk
	else
		apt-get install connman-gtk $initstr
	fi
else
	echo "Si continua senza desktop. Premere invio per continuare."
	read dummy;
	if [ $init -eq 1 ]; then
		apt-get install network-manager
	else
		apt-get install connman $initstr
	fi
fi

apt-get remove --purge ssh* openssh* rpcbind -y

echo "Adesso configuriamo il fuso orario. Premere invio per continuare."
read dummy
dpkg-reconfigure tzdata

echo "Adesso configuriamo la tastiera. Premere invio per continuare."
read dummy
dpkg-reconfigure keyboard-configuration

echo "Inserire il nome dell'utente da aggiungere"
read user

adduser $user
usermod -aG video,audio,cdrom,sudo,plugdev.netdev,lpadmin,scanner,dip $user

echo "Adesso configuriamo la password di root. Premere invio per continuare."
read dummy
passwd

echo "1. Si
2. No
Vuoi scaricare i driver PROPRIETARI della scheda di rete?"
read drivers

if [ $drivers -eq 1 ]; then
	mkdir /tmp/brcm
	cd /tmp/brcm
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43430-sdio.bin
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43430-sdio.clm_blob
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43430-sdio.txt
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43455-sdio.bin
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43455-sdio.clm_blob
	wget https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43455-sdio.txt 
	mv /tmp/brcm /lib/firmware
fi


echo "1. Si
2. No
Vuoi scaricare il boot loader PROPRIETARIO?"
read boot

if [ $boot -eq 1 ]; then
	mkdir /tmp/boot
	cd /tmp/boot
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/COPYING.linux
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/LICENCE.broadcom
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-b-plus.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-b-rev1.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-b.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-cm.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-zero-w.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2708-rpi-zero.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2709-rpi-2-b.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2710-rpi-2-b.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2710-rpi-3-b-plus.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2710-rpi-3-b.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2710-rpi-cm3.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2711-rpi-4-b.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bcm2711-rpi-cm4.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/bootcode.bin
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup4.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup4cd.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup4db.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup4x.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup_cd.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup_db.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/fixup_x.dat
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/kernel.img
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/kernel7.img
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/kernel7l.img
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/kernel8.img
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start4.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start4cd.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start4db.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start4x.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start_cd.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start_db.elf
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/start_x.elf
	

	mkdir ./overlays
	cd ./overlays

	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/README
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/act-led.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/adafruit18.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/adau1977-adc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/adau7002-simple.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ads1015.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ads1115.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ads7846.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/adv7282m.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/adv728x-m.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/akkordion-iqdacplus.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/allo-boss-dac-pcm512x-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/allo-digione.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/allo-katana-dac-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/allo-piano-dac-pcm512x-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/allo-piano-dac-plus-pcm512x-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/anyspi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/apds9960.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/applepi-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/at86rf233.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audioinjector-addons.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audioinjector-isolated-soundcard.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audioinjector-ultra.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audioinjector-wm8731-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audiosense-pi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/audremap.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/balena-fin.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/cma.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dht11.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dionaudio-loco-v2.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dionaudio-loco.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/disable-bt.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/disable-wifi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dpi18.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dpi24.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/draws.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dwc-otg.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/dwc2.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/enc28j60-spi2.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/enc28j60.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/exc3000.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/fe-pi-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/goodix.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/googlevoicehat-soundcard.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-fan.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-ir-tx.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-ir.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-key.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-no-bank0-irq.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-no-irq.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-poweroff.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/gpio-shutdown.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hd44780-lcd.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hdmi-backlight-hwhack-gpio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-amp.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dacplus.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dacplusadc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dacplusadcpro.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dacplusdsp.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-dacplushd.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-digi-pro.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hifiberry-digi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/highperi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hy28a.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hy28b-2017.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/hy28b.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i-sabre-q2m.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-bcm2708.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-gpio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-mux.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-pwm-pca9685a.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-rtc-gpio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-rtc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c-sensor.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c0.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c1.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c3.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c4.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c5.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2c6.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/i2s-gpio28-31.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ilitek251x.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/imx219.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/imx290.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/imx477.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/iqaudio-codec.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/iqaudio-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/iqaudio-dacplus.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/iqaudio-digi-wm8804-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/irs1125.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/jedec-spi-nor.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/justboom-both.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/justboom-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/justboom-digi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ltc294x.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/max98357a.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/maxtherm.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mbed-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp23017.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp23s17.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp2515-can0.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp2515-can1.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp3008.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp3202.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mcp342x.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/media-center.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/merus-amp.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/midi-uart0.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/midi-uart1.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/miniuart-bt.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mmc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mpu6050.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/mz61581.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ov5647.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ov7251.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ov9281.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/overlay_map.dtb
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/papirus.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pca953x.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pibell.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pifacedigital.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/piglow.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/piscreen.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/piscreen2r.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pisound.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pitft22.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pitft28-capacitive.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pitft28-resistive.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pitft35-resistive.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pps-gpio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pwm-2chan.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pwm-ir-tx.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/pwm.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/qca7000.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rotary-encoder.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-backlight.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-cirrus-wm5102.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-dac.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-display.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-ft5406.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-poe.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-proto.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-sense.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpi-tv.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rpivid-v4l2.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/rra-digidac1-wm8741-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sainsmart18.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sc16is750-i2c.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sc16is752-i2c.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sc16is752-spi0.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sc16is752-spi1.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sdhost.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sdio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sdtweak.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sh1106-spi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/smi-dev.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/smi-nand.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/smi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi-gpio35-39.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi-gpio40-45.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi-rtc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi0-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi0-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi1-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi1-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi1-3cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi2-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi2-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi2-3cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi3-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi3-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi4-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi4-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi5-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi5-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi6-1cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/spi6-2cs.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ssd1306-spi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ssd1306.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/ssd1351-spi.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/superaudioboard.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/sx150x.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/tc358743-audio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/tc358743.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/tinylcd35.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/tpm-slb9670.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart0.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart1.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart2.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart3.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart4.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/uart5.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/udrc.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/upstream-pi4.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/upstream.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/vc4-fkms-v3d.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/vc4-kms-kippah-7inch.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/vc4-kms-v3d-pi4.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/vc4-kms-v3d.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/vga666.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/w1-gpio-pullup.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/w1-gpio.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/w5500.dtbo
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/wittypi.dtbo

	cp  -r /tmp/boot/* /boot
	rm -rf /tmp/boot
fi

echo "#!/bin/bash
#Authore: Giulio Sorrentino <gsorre84@gmail.com>
iptables -A INPUT -j REJECT
iptables -A FORWARD -j REJECT" > /usr/sbin/firewall.sh

echo "[Unit]
Description=Firewall rules

[Service]
# temporary safety check until all DMs are converted to correct
# display-manager.service symlink handling
ExecStart=/usr/sbin/firewall.sh
Type=simple

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/firewall.service

echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait hdmi=1" > /boot/cmdline.txt

echo "# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details

# uncomment if you get no picture on HDMI for a default "safe" mode
#hdmi_safe=1

# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1

# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16

# uncomment to force a console size. By default it will be display's size minus
# overscan.
#framebuffer_width=1280
#framebuffer_height=720

# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1

# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1

# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2

# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
config_hdmi_boost=4

# uncomment for composite PAL
#sdtv_mode=2

#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800

# Uncomment some or all of these to enable the optional hardware interfaces
#dtparam=i2c_arm=on
#dtparam=i2s=on
#dtparam=spi=on

# Uncomment this to enable infrared communication.
#dtoverlay=gpio-ir,gpio_pin=17
#dtoverlay=gpio-ir-tx,gpio_pin=18

# Additional overlays and parameters are documented /boot/overlays/README

# Enable audio (loads snd_bcm2835)
dtparam=audio=on

[pi4]
# Enable DRM VC4 V3D driver on top of the dispmanx display stack
max_framebuffers=2
arm_64bit=1
kernel=kernel8.img

[all]
dtoverlay=vc4-fkms-v3d
start_x=1
gpu_mem=256
hdmi_enable_4kp60=0" > /boot/config.txt

rm -rf /tmp/piccolinux
rm /project_milano1.sh
apt-get autoremove
apt-get clean

if [ $sistema -eq 10 ]; then
        echo "1. Si
2. No
Vuoi installare la briscola?"
        read briscola
        if [ $briscola -eq 1 ]; then
                cd /tmp
		wget https://github.com/numerunix/wxBriscola/releases/download/0.3.3/wxbriscola_0.3.3-1_arm64.deb
		dpkg -i ./wxbriscola_0.3.3-1_arm64.deb
		apt -f install -y
	fi
fi
echo "Debian è pronto. Puoi applicare cambiamenti, tipo installare ulteriore software tramite apt e quando hai finito digita exit."
