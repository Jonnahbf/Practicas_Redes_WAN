#!/bin/sh

key_1=`mpls nhlfe add key 0 instructions push gen 10005 \
	nexthop eth0 ipv4 15.0.0.3 | grep key | cut -d " " -f 4`

key_2=`mpls nhlfe add key 0 instructions push gen 20002 \
	nexthop eth0 ipv4 15.0.0.3 | grep key | cut -d " " -f 4`


ip route add 11.0.0.0/24 via 15.0.0.3 mpls $key_1 
ip route add 14.0.0.0/24 via 15.0.0.3 mpls $key_2


mpls labelspace set dev eth0 labelspace 0
mpls ilm add label gen 10003 labelspace 0

