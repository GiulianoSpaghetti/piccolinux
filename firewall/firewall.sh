#!/bin/sh
#Autre Giulio Sorentino <gsorre84@gmail.com>
iptables -A INPUT -i eth0 -j DROP
iptables -A FORWARD -i eth0 -j DROP
