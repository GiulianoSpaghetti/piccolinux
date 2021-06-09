#!/bin/sh
#Autore Giulio Sorentino <gsorre84@gmail.com>
iptables -A INPUT -i enp31s0 -j DROP
iptables -A FORWARD -i enp31s0 -j DROP
iptables -A INPUT -i wlp37s0 -j DROP
iptables -A FORWARD -i wlp37s0 -j DROP

