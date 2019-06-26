#Envio de PC1 a PC2
mpls labelspace set dev eth2 labelspace 0
mpls ilm add label gen 10001 labelspace 0

key_1=`mpls nhlfe add key 0 instructions push gen 10002 \
	nexthop eth0 ipv4 13.0.0.3 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10001 ilm_labelspace 0 nhlfe_key $key_1

#Envio de PC2 a PC1
mpls labelspace set dev eth0 labelspace 0
mpls ilm add label gen 10006 labelspace 0

key_1=`mpls nhlfe add key 0 instructions push gen 10007 \
	nexthop eth2 ipv4 12.0.0.1 | grep key | cut -d " " -f 4`

mpls xc add ilm_label gen 10006 ilm_labelspace 0 nhlfe_key $key_1
