#!/bin/sh

#Envio de pc3 a pc2
key_3=`mpls nhlfe add key 0 instructions push gen 20001 \
	nexthop eth0 ipv4 13.0.0.3 | grep key | cut -d " " -f 4`
	 
ip route add 17.0.0.0/24 via 13.0.0.3 mpls $key_3

#Envio de pc1 a pc2
mpls labelspace set dev eth2 labelspace 0
mpls ilm add label gen 10001 labelspace 0

key_1=`mpls nhlfe add key 0 instructions push gen 10002 \
	nexthop eth0 ipv4 13.0.0.3 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10001 ilm_labelspace 0 nhlfe_key $key_1 

#Envio de pc4 a pc1
mpls labelspace set dev eth0 labelspace 0
mpls ilm add label gen 10006 labelspace 0

key_2=`mpls nhlfe add key 0 instructions push gen 10007 \
	nexthop eth2 ipv4 12.0.0.2 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10006 ilm_labelspace 0 nhlfe_key $key_2 


mpls labelspace set dev eth0 labelspace 0
mpls ilm add label gen 20003 labelspace 0
