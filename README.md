# piccolinux
Una serie di script per gestire l'installazione "from scratch" di debian per il raspberry a 64 bit

# Cosa è
Questi due script sono un tool per la creazione di una installazione di debian arm a 64 bit.
Non fanno niente altro che configurare un sistema debian (sia esso buster o bullseye) con i pacchetti fondamentali e uboot, poi richiedono il desktop manager da installare e configura il sistema aggiungendo un utente, impostando la password di root e permettendo la configurazione del fuso orario, della lingua e della tastiera.
Vanno scaricati entrambi gli script (project_milano0.sh e project_milano1.sh) e messi nella stessa cartella.
Siccome il filesystem di GNU/Linux è in continua evoluzione, bisogna prima preparare opportunbamente la microsd, inserendo due partizioni una fat32 di boot e una ext4 del sistema, in seguito bisogna dire il dispositivo a blocchi contenente le partizioni e a quel punto quale sistema installare. Farà tutto lui.

# Errori noti
Durante l'installazione si ottengono errori relativi al linguaggio, che vengono risolti con la configurazione dello stesso.
Al momento sia buster che bullseye per arm64 sono imputtanati, per cui i sistemi non funzionano corettamente e bisogna aspettare che debian risolva.

# Video esplificativi

https://youtu.be/V-cluqFi4Cw
https://www.youtube.com/watch?v=0fWG4x99j_M
