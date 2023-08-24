# piccolinux

# in loving Memory of Giuseppe

# Attenzione

il poccolinux viene dismesso. Oggi é sufficiente scaricare il boot loader (https://github.com/pftf/RPi4/releases) ed installarlo secondo le modalità indicate e farsi una pennetta con debian arm64 per bootare un sistema efi compliant ed installare il sostema in meno di metà del tempo.

![IMG_20230821_191345_HDR](https://github.com/numerunix/piccolinux/assets/49764967/f135994e-92ac-41ef-99d4-8cd650a7c397)

https://youtu.be/edBtoWvWphk


# Informazioni
Semplice script per l'installazione di Debian sui sistemi arm64, con particolare riferimento al Raspberry.
Il sistema offre come personalizzazione l'installazione dei driver mesa, non più attuale.
È possibile installare diverse distribuzioni Linux semplicemente cambiando la dicitura nella riga che comincia per debootstrap.
Per ulteriori informazioni fare riferimento a man debootstrap, per ottenere una lista delle distro installabili fare riferimento alla directory /usr/share/debostrap/scripts.
È possibile cambiare anche la piattaforma di riferimento sostituendo arm64 con una di quelle elencate nel man, tipo amd64, PowerPC o x32.

# Modalità interattiva di bash

Avviando gli script su gnu/Linux mettendo come prefisso la stringa "bash -x" si avvia la modalità di debug di bash, permettendo di studiare meglio il codice.

# Gli script
oem2chiacchio traduce i mesa oem in mesa di chiacchio, è necessario il reboot. Legacy.

blu ray dialog scarica i blu ray single layer o double layer di debian.

c(d)vd scarica i cd o i dvd della versione in uso di debian

c(d)vd_resumed scarica i dvd o i cd di qualsiasi versione di debian, potrebbero non essere disponibiiì tutti i file

chiacchio2oem traduce i mesa chiacchio in mesa oem, legacy.

debianvnc_o.3 dovrebbe essere un tentativo di un docker grafico, non funziona.

project milano 0 e 1 sono gli script ufficiali, vanno usati in coppia (lo 0 richiama l'1) e necessita di un hard disk usb opportunamente configurato come riportato (la versione pubblicata in data 09/08/2023 si deve alla tabaccheria caiaffa)

unr4r ricompila il winrar

wsl-recompile ricompila il kernel in uso sul wsl di windows

wsl upgrade installa un kernel vecchio o nuovo per il wsl di windows

firewall è un firewall legacy

iptables save sono i salvataggi incompleti del firewall trovato online.

piccolinux sono i sorgenti dei package legacy di salsa.debian.org modificati.

# Partizionamento del disco
/dev/sda1 è /boot
/dev/sda2 è /
/dev/sda3 è /boot/efi


# Bug noti
Quando viene avviata la grafica, viene creato un file temporaneo /tmp/result.txt per ogni schermata
 
Andando a modificare manualmente quel file il risultato può uscire falsato, ma è questa la sintassi corretta per l'utilizzo del framework dialog.
 
# Donazione

[![paypal](https://www.paypalobjects.com/it_IT/IT/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=H4ZHTFRCETWXG)

Puoi donare anche tramite carta Hype a patto di avere il mio numero di cellulare nella rubrica. Sai dove lo puoi trovare? Sul mio curriculum.
Apri l'app Hype, fai il login, seleziona PAGAMENTI, INVIA DENARO, seleziona il mio numero nella rubrica, imposta l'importo, INSERISCI LA CAUSALE e segui le istruzioni a video.
