#!/bin/sh
#Autore Giulio Sorentino <gsorre84@gmail.com>
#Concesso in licenza secondo la GPL V3

#iptables -A INPUT -i enp31s0 -j DROP
#iptables -A FORWARD -i enp31s0 -j DROP
#iptables -A INPUT -i wlp37s0 -j DROP
#iptables -A FORWARD -i wlp37s0 -j DROP

for i in `ls /sys/class/net`; do 
if [[ $i != "lo" ]]; then
 iptables -A INPUT -i $i -j DROP
 iptables -A FORWARD -i $i -j DROP
fi
done
