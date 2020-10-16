# piccolinux
Una serie di script per gestire l'installazione "from scratch" di debian per il raspberry a 64 bit

# Cosa è
Questi due scrpt sono un tool per la creazione di una installazione di debian arm a 64 bit.
Non fanno niente altro che configurare un sistema debian (sia esso buster, bullseye o sid) con i pacchetti fondamentali e uboot, poi richiedono il desktop manager da installare e configura il sistema aggiungendo un utente, impostando la password di root e permettendo la configurazione del fuso orario, della lingua e della tastiera.
Vanno scaricati entrambi gli script.
Dopo la creazione dell'installazione, il sistema verrà copiato sulla microsd tramite rsync. Ho scelto questo metodo perché il filesystem viene continuamente aggiornato, e quindi è opportuno averlo fresco invece di andare su prodotti già pacchettizzati.

# Errori noti
Su sid non funziona, durante l'installazione si hanno degli errori di lingua non selezionata, ma tutto si risolve dopo la configurazion della lingua.

