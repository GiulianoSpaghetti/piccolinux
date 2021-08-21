#! /bin/bash
# Autore: Giulio Sorrentino <gsorre84@gmail.com>

function notRoot {
if [[ $EUID -ne 0 ]]; then
	dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Lo script deve essere avviato da root" 7 60
   	return 1
fi
	return 0
}

function Installkernel {
dialog --title "Installazione kernel" \
--backtitle "Installazione kernel" \
--yesno "Vuoi installare il kernel ufficiale raspberry per avere il firewall funzionante?" 7 60
return $?
}


function InstallMTA {
dialog --title "Installazione MTA" \
--backtitle "Installazione server di posta" \
--yesno "Linux utilizza un sistema di messaggistica interno che viene attivato nel momento in cui viene installato (perr esempio abuso di sudo), solo che non si può leggere perfcché non c'è nessun server dui posta per ricevere l'email.\n
VUoi tu installare postfix e selezionare solo messaggistica locale per leggere i messaggi inviati da linux?" 7 60
return $?
}

function checkSystem {
read -d / sistema < /etc/debian_version

if [ $sistema = "bullseye" ]; then
	sistema=11
else
	read -d . sistema < /etc/debian_version
fi
return $sistema
}

function selezionaInit {
dialog --backtitle "Quale init selezionare" \
--radiolist "Quale init selezionare:" 10 40 3 \
 1 "System D" off \
 2 "SysV" on \
 3 "runit" off >/dev/tty 2>/tmp/result.txt 
if [ $? -eq 0 ]; then
	init=`cat /tmp/result.txt`
else
	init=1
fi
rm /tmp/result.txt
return $init
}

function selezionaDesktop {
dialog --backtitle "Quale desktop selezionare" \
--radiolist "Quale desktop selezionare" 20 40 9 \
1 "Gnome" off \
2 "Cinnamon" off \
3 "KDE" off \
4 "LXDE" off \
5 "LXQT" off \
6 "XFCE" on \
7 "IceWM" off \
8 "Openbox" off > /dev/tty 2>/tmp/result.txt
if [ $? -eq 0 ]; then
	desktop=`cat /tmp/result.txt`
else
	desktop=0
fi
rm /tmp/result.txt
return $desktop
}

function selezionaLogin {
dialog --backtitle "Quale schermata di login utilizzare" \
--radiolist "Quale schermata di login utilizzare" 20 40 6 \
1 "GDM3" off \
2 "SDDM" off \
3 "Lightdm" on \
4 "Wdm" off \
5 "LXdm" off \
6 "Xdm" off > /dev/tty 2>/tmp/result.txt
if [ $? -eq 0 ]; then
	login=`cat /tmp/result.txt`
else
	login=0
fi
rm /tmp/result.txt
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
--yesno "Vuoi installare il bootloader PROPRIETARIO? (senza non si avvia, ma con non puoi diffondere l'immagine della microsd).\nNon è necessario se hai installato il kernel di raspberry." 7 60
return $?
}

function aggiornaSid {
dialog --title "Aggiornamento a SID" \
--backtitle "Aggiornamento a SID" \
--yesno "E' caldamente consigliato l'aggionramento a debian Sid che, sebbene sperimentale, accelera il testing del nuovo wayland consentendo così una maggiore velocità di sviluppo dei futuri debian, a scapito della stabilità di sistema e della sicurezza dei propri files. Vuoi procedere?"  10 60
return $?
}

function installaBootLoader {
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
	wget https://raw.githubusercontent.com/raspberrypi/firmware/master/boot/overlays/enc28j60.dtber
	
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
}


function configureCmdLine {
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait hdmi=1" > /boot/cmdline.txt
}

function installLibDrm {
	mkdir /tmp/libdrm
	cd /tmp/libdrm
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-amdgpu1_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-amdgpu1-dbgsym_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-common_2.4.105-1-ilaria_all.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-etnaviv1_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-freedreno1_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-libkms_2.4.105-1-iaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-nouveau2_2.4.105-1-ilaria_arm64.deb	
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-radeon1_2.4.105-1-ilaria_arm64.deb 
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-tegra0_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-tests_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm2_2.4.105-1-ilaria_arm64.deb
	wget https://github.com/numerunix/piccolinux/releases/download/2.4.105-francy/libdrm-dev_2.4.105-1-ilaria_arm64.deb
	dpkg -i *.deb
	cd ..
	rm -rf libdrm 
	apt-get -f install
}

function InstallLibMesa {
	mkidr /tmp/mesa
	cd /tmp/mesa
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
	apt-get -f install
} 
 


function configureConfig {
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

# uncomment to force a specific HDMI mode (this will 
force VGA)
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
#dtparam=i2c_arm=onwget https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/raspberrypi-kernel_1.20210805-1_arm64.deb

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
dtoverlay=vc4-kms-v3d-p4
start_x=1
gpu_mem=256
hdmi_enable_4kp60=0" > /boot/config.txt
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
	if [ $1 -gt 9 ]; then
		mkdir /tmp/wxbriscola
		cd /tmp/wxbriscola
		if [ $1 -eq 10 ]; then 
			wget https://github.com/numerunix/wxBriscola/releases/download/4k/wxbriscola_0.3.6_bullseye_arm64.deb
		else
			wget https://github.com/numerunix/wxBriscola/releases/download/4k/wxbriscola_0.3.6_buster_arm64.deb
		fi
		wget https://github.com/numerunix/wxBriscola/releases/download/4k/wxbriscola-i18n_0.3.6_all.deb
		wget https://github.com/numerunix/wxBriscola/releases/download/0.3.6/wxbriscola-mazzi-hd-napoletano_0.3.6_all.deb
		wget https://github.com/numerunix/wxBriscola/releases/download/0.3.6/wxbriscola-mazzi-hd-dr-francy_0.3.6_all.deb
		wget https://github.com/numerunix/wxBriscola/releases/download/0.3.6/wxbriscola-mazzi-hd-gatti_0.3.6_all.deb
		wget https://github.com/numerunix/wxBriscola/releases/download/0.3.6/wxbriscola-mazzi-hd-playing-mario_0.3.6_all.deb
		apt-get install *.deb
		cd ..
		rm -rf wxbriscola
		cd
	else
 		dialog --title "Errore" \
		--backtitle "Errore" \
		--msgbox "La briscola non e' disponibile per stretch perche' e' troppo vecchio. Grazie per la collaborazione." 7 60
fi		
}


function installFirewall {
	dialog --title "Installazione firewall" \
--backtitle "Installazione di un firewall" \
--yesno "Vuoi installare un firewall?" 7 60
if [ $? -eq 0 ]; then
# Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established sessions to receive traffic
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Adesso viene installato il programma che farà parttire il firewall all'avvio, voi dovete solo abilittare il servizio \"netfilter persisent\" e dire che volete salvare le regole attuali quando l'installer lo chiede" 40 60

apt-get install iptables-persistent
if [ $init -ne 1 ]; then
	ln -s /etc/init.d/netfilter-persistent /etc/rc3.d/S15netfilter-persistent
	ln -s /etc/init.d/netfilter-persistent /etc/rc3.d/S15netfilter-persistent
	ln -s /etc/init.d/netfilter-persistent /etc/rc3.d/S15netfilter-persistent
fi
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


Installkernel
if [ $? -eq 0 ]; then
    cd /tmp
    wget https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/raspberrypi-kernel_1.20210805-1_arm64.deb
    dpkg -i raspberrypi-kernel_1.20210805-1_arm64.deb
    rm raspberrypi-kernel_1.20210805-1_arm64.deb
    apt get install uboot-rpi
else
    kernel=`apt-cache search ^linux-image-5.[0-9] [0-9]+-arm64$ | cut -d\  -f1`
    apt-get install u-boot-rpi $kernel -y
fi

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
3) apt-get install runit-init runit-sysv
	apt-get remove --purge systemd sysvinit-core
	initstr=runit-init
	#apt-get install --reinstall --purge $(dpkg --get-selections | grep -w 'install$' | cut -f1) $initstr -y
	mv /sbin/start-stop-daemon.REAL /sbin/start-stop-daemon
        apt-mark hold runit-init runit-sysv
        echo "runit-init" | sudo dpkg --set-selections
        echo "runit-sysv hold" | sudo dpkg --set-selections

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

apt-get install bash-completion console-setup keyboard-configuration sudo curl dbus usbutils ca-certificates nano less fbset debconf-utils avahi-daemon fake-hwclock nfs-common apt-utils man-db pciutils ntfs-3g apt-listchanges wpasupplicant wireless-tools firmware-atheros firmware-brcm80211 firmware-libertas firmware-misc-nonfree firmware-realtek net-tools apt-file tzdata apt-show-versions unattended-upgrades dpkg-repack gnupg2 netcat $initstr -y
apt-file update
apt-get update
apt-get upgrade

selezionaDesktop
desktop=$?

if [ $init -ne 1 ]; then 
	if [ $desktop -lt 3 ] && [ $desktop -gt 0 ]; then 
dialog --title "Errore" \
	--backtitle "Errore" \
	--msgbox "Con init diverso da systemd si puo' installare non si possono installare kde, gnome e cinnamon.\nVerra' installato xfce." 7 60
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
7) desktop=icewm
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
dialog --title "inserire Nome Utente" \
--backtitle "Inserire nome Utente" \
--inputbox "Inserire il nome utente dell'utente non privilegiato da aggiungere" 8 60 2>/tmp/result.txt
result=$?
done
user=`cat /tmp/result.txt`
rm /tmp/result.txt

adduser $user
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

selezionaInstallazioneBootLoader
boot=$?
if [ $boot -eq 0 ]; then
	installaBootLoader
fi

configureCmdLine
configureConfig

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
fiiptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
selezionaBriscola
if [ $? -eq 0 ]; then
	InstallBriscola
fi
InstallMTA
if [ $? -eq 0 ]
	apt-get install postfix
fi
dialog --title "Informazione" \
	--backtitle "Informazione" \
	--msgbox "Debian e' pronto. Puoi applicare cambiamenti, tipo installare ulteriore software tramite apt e quando hai finito digita exit.\nCopyright 2020 Giulio Sorrentino <gsorre84@gmail.com>\nIl software viene concesso in licenza secondo la GPL v3 o, secondo la tua opionione, qualsiasi versione successiva.\nIl software viene concesso per COME E', senza NESSUNA GARANZIA ne' implicita ne' esplicita.\nSe ti piace, considera una donazione tramite paypal." 40 60

