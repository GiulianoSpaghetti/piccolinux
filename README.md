# piccolinux
Semplice script per l'installazione di Debian sui sistemi arm64, con particolare riferimento al Raspberry.
Il sistema offre come personalizzazione l'installazione dei driver mesa, non più attuale.
È possibile installare diverse distribuzioni Linux semplicemente cambiando la dicitura nella riga che comincia per debootstrap.
Per ulteriori informazioni fare riferimento a man debootstrap, per ottenere una lista delle distro installabili fare riferimento alla directory /usr/share/debostrap/scripts.
È possibile cambiare anche la piattaforma di riferimento sostituendo arm64 con una di quelle elencate nel man, tipo amd64, PowerPC o x32.

# Modalità interattiva di bash

Avviando gli script su gnu/Linux mettendo come prefisso la stringa "bash -x" si avvia la modalità di debug di bash, permettendo di studiare meglio il codice.

# Bug noti
Quando viene avviata la grafica, viene creato un file temporaneo /tmp/result.txt per ogni schermata
 
Andando a modificare manualmente quel file il risultato può uscire falsato, ma è questa la sintassi corretta per l'utilizzo del framework dialog.
 
# Donazione

[![paypal](https://www.paypalobjects.com/it_IT/IT/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=H4ZHTFRCETWXG)

Puoi donare anche tramite carta Hype a patto di avere il mio numero di cellulare nella rubrica. Sai dove lo puoi trovare? Sul mio curriculum.
Apri l'app Hype, fai il login, seleziona PAGAMENTI, INVIA DENARO, seleziona il mio numero nella rubrica, imposta l'importo, INSERISCI LA CAUSALE e segui le istruzioni a video.
