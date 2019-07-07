#!/bin/bash

iptables -t nat -F
iptables -t nat -Z
iptables -t filter -F
iptables -t filter -Z

#Las redes privadas pueden salir a internet
iptables -t nat -A POSTROUTING -s 10.7.22.0/24 -o eth2 -j SNAT --to-source 90.0.0.1
iptables -t nat -A POSTROUTING -s 10.8.22.0/24 -o eth2 -j SNAT --to-source 90.0.0.1

#Permitir acceso al firewall desde las subredes privadas
iptables -A INPUT -s 10.7.22.0/24 -i eth0 -j ACCEPT
iptables -A INPUT -s 10.8.22.0/24 -i eth0 -j ACCEPT

#Permitir desde internet hacia la DMZ
#Al puerto 7 UDP de pc4
iptables -A FORWARD -d 80.0.0.40 -i eth2 -p udp --dport 7 -j ACCEPT
#Al puerto 13 UDP de pc
iptables -A FORWARD -d 80.0.0.50 -i eth2 -p udp --dport 13 -j ACCEPT
#El resto se niega
iptables -A FORWARD -d 80.0.0.0/24 -i eth2 -j DROP

#Comunicacion DMZ con Subredes Privadas
#Servidor echo de pc1 a pc4
iptables -A FORWARD -s 10.7.22.10 -d 80.0.0.40 -i eth0 -o eth1 -p tcp --dport 7 -j ACCEPT
#PC1 acceder via telnet a pc5
iptables -A FORWARD -s 10.7.22.10 -d 80.0.0.50 -i eth0 -o eth1 -p tcp --dport 23 -j ACCEPT
#El resto se niega
iptables -A FORWARD -d 80.0.0.0/24 -i eth0 -j DROP

#DMZ no se puede comunicar con las redes privadas
iptables -A FORWARD -s 80.0.0.0/24 -d 10.0.0.0/8 -j DROP
#DMZ no puede acceder al firewall
iptables -A INPUT -s 80.0.0.0/24 -j DROP
