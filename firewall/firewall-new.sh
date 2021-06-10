#!/bin/sh
#Autore Giulio Sorentino <gsorre84@gmail.com>
#Concesso in licenza secondo la GPL V3
#dediato a francesca salerno dei centri sociali

for i in `ls /sys/class/net`; do 
if [[ $i != "lo" ]]; then
 iptables -A INPUT -i $i -j DROP
 iptables -A FORWARD -i $i -j DROP
fi
done
