#!/bin/bash
if [ $UID -ne 0 ]; then
	echo 'Lo scipt deve essere avviato da root.'
	exit 0
fi

apt clean
apt-get install --reinstall $(dpkg --get-selections | grep -w 'install$' | cut -f1)
