# piccolinux
Semplice script per l'installazione di Debian sui sistemi arm64, con particolare riferimento al Raspberry.
Il sistema offre come personalizzazione l'installazione dei driver mesa, non più attuale.
È possibile installare diverse distribuzioni Linux semplicemente cambiando la dicitura nella riga che comincia per debootstrap.
Per ulteriori informazioni fare riferimento a man debootstrap, per ottenere una lista delle distro installabili fare riferimento alla directory /usr/share/debostrap/scripts.
È possibile cambiare anche la piattaforma di riferimento sostituendo arm64 con una di quelle elencate nel man, tipo amd64, PowerPC o x32.

# Modalità interattiva di base

Avviando gli script su gnu/Linux mettendo come prefisso la stringa "bash -x" si avvia la modalità di debug di bash, permettendo di studiare meglio il codice.
