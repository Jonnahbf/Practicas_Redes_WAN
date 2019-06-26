#!/bin/sh

#Envio de PC1 a PC2
mpls labelspace set dev eth0 labelspace 0
mpls ilm add label gen 10002 labelspace 0

key_1=`mpls nhlfe add key 0 instructions push gen 10003 \
	nexthop eth1 ipv4 15.0.0.4 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10002 ilm_labelspace 0 nhlfe_key $key_1


#Envio de PC2 a PC1
mpls labelspace set dev eth1 labelspace 0
mpls ilm add label gen 10005 labelspace 0

key_1=`mpls nhlfe add key 0 instructions push gen 10006 \
	nexthop eth0 ipv4 13.0.0.2 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10005 ilm_labelspace 0 nhlfe_key $key_1
