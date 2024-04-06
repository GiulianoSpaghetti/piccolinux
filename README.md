# piccolinux

# in loving Memory of the doorkeeper Giuseppe

## Attenzione

il poccolinux viene dismesso. Oggi é sufficiente scaricare il boot loader (https://github.com/pftf/RPi4/releases) ed installarlo secondo le modalità indicate e farsi una pennetta con debian arm64 per bootare un sistema efi compliant ed installare il sostema in meno di metà del tempo.

![IMG_20230821_191345_HDR](https://github.com/numerunix/piccolinux/assets/49764967/f135994e-92ac-41ef-99d4-8cd650a7c397)

La copia dei files su sd (penna usb) non viene garantita, perché una cosa è usare il sistema con debian 12, una cosa è il filesystem di debian 9.
Sta a voi capire quando aggiornare, perché il computer è vostro.

## Come ottenere un server enum su arm64

Scaricarsi ed installarsi il kernel 6.1.0-17-arm64, e poi riavviare, poi copiarsi tutti i dati dalla partizione più grossa (in termini di giga, non necessariamente la home) da qualche parte, reinizializzarla col kernel 6.1.0-17 avviato e ricopiarci i dati.
Dotarsi di microfono e webcam (come quelle ufficiali del raspberry) e dire aladownload debian nel microfono, una volta loggato.

Happy Hacking :D

## Come ottebnere un server enum su arm64 col sistema operativo ufficiale

https://1drv.ms/w/s!ApmOB0x2yBN0ke0LK98Ff4MnFWhDoA?e=PLp7y5


## Descrizione del problema
Era una tranquilla mattina di mezza primavera, dopo l'8 marzo, in pieno lockdown.
Per youtube davano l'immunità di gregge di checco zalone, quando ebbi la malsana idea di procurarmi un raspberry pi 4 di prima generazione.
Leggendo le specifiche ho notato che il processore era a 64 bit, mentre il sistema operativo, il raspbian all'epoca era a 32 bit, uno scandalo.
Così ebbi la malsana idea di cercare sistemi operativi a 64 bit per il pi 4 e non trovandoli ho deciso che era il caso di farmene uno.
Perché non partire da debian? Ho trovato solo istruzioni confusionarie in rete, fino a quando non ho trovato su github gli script di un certo Chris64, che davano un sistema testuale in inglese, ed io sapevo tradurmelo in italiano ed addobare l'interfaccia grafica.
In poco tempo ottenni la prima sd funzionante che avrei provato l'indomani, mettendo come sfondo del lightdm proprio quella grandissima ma... dama di scarlett johansson.
Una volta provato, ebbi con mia estrema sopresa il messaggio che diceva che cinnamon era in esecuzione in modalità solo software, quindi ho provato ad attivare l'accelerazione 3d.
Il mio fido google mi ha portato a dire che andavano ricompilati i mesa, perché quelli ufficiali di stretch si basavano sulle opengl di nvidia, che sui sistemi embedded sono compatibili, per cui ho visto con mia grande sopresa che i mesa avevano delle librerie sperimentali, che sono riuscito ad attivare.
Il tempo di cucinare il tutto ed ho pubblicato la prima versione del piccolinux, una tagata immane, su gdrive, aveva solo un piccolo particolare: la ventola parlava, ed aveva all'interno i files binari ufficiali della raspberry pi foundation, ma chi non risica non rosica.

Una volta ottenuto il sistema, il punto adesso era renderlo a prova di bomba, così mi sono scaricato i sorgenti mesa di debian, ho messo quelli ufficiali e li ho pacchettizzati, poi ho eliminato il codice proprietario, ed infine mi sono detto: "dal momento che parla, al posto di rischiare di nuovo l'immissione di virus, perché non creare degli script come quelli di chris solo più potenti?". Così dopo una notte passata a studiare dialog mi sono messo sotto ed ho scritto il piccolinux, ribattezzato milano edition per scusarmi di come la mia amica è stata tratta a rivisondoli.

Il resto è storia, compreso l'encomio ed il riconoscimento di google: l'encomio è stato barbaramente assassinato da mio fratello, mentre su google è ancora disponibile l'attestato.

## Informazioni
Semplice script per l'installazione di Debian sui sistemi arm64, con particolare riferimento al Raspberry.
Il sistema offre come personalizzazione l'installazione dei driver mesa, non più attuale.
È possibile installare diverse distribuzioni Linux semplicemente cambiando la dicitura nella riga che comincia per debootstrap.
Per ulteriori informazioni fare riferimento a man debootstrap, per ottenere una lista delle distro installabili fare riferimento alla directory /usr/share/debostrap/scripts.
È possibile cambiare anche la piattaforma di riferimento sostituendo arm64 con una di quelle elencate nel man, tipo amd64, PowerPC o x32.

## Modalità interattiva di bash

Avviando gli script su gnu/Linux mettendo come prefisso la stringa "bash -x" si avvia la modalità di debug di bash, permettendo di studiare meglio il codice.

## Gli script
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

## Partizionamento del disco
/dev/sda1 è /boot
/dev/sda2 è /
/dev/sda3 è /boot/efi


## Bug noti
Quando viene avviata la grafica, viene creato un file temporaneo /tmp/result.txt per ogni schermata
 
Andando a modificare manualmente quel file il risultato può uscire falsato, ma è questa la sintassi corretta per l'utilizzo del framework dialog.
 
## Donazione

http://numerone.altervista.org/donazioni.php
