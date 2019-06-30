tc qdisc add dev eth0 handle ffff: ingress

#Paquetes enviados por PC1
tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src \
	192.168.1.10/32 flowid :1

#Paquetes enviados por PC2
tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src \
	192.168.1.20/32 flowid :2

#Paquetes enviados por PC3
tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src \
	192.168.2.30/32 flowid :3

tc qdisc add dev eth1 root handle 1:0 dsmark indices 1

#Cambiamos el DSCP a 000000 para quitar el diffserv
tc class change dev eth1 classid 1:1 dsmark mask 0x0 value 0x00
tc class change dev eth1 classid 1:2 dsmark mask 0x0 value 0x00
tc class change dev eth1 classid 1:3 dsmark mask 0x0 value 0x00

tc filter add dev eth1 parent 1:0 protocol ip prio 1 \
	handle 1 tcindex classid 1:1

tc filter add dev eth1 parent 1:0 protocol ip prio 1 \
	handle 2 tcindex classid 1:2

tc filter add dev eth1 parent 1:0 protocol ip prio 1 \
	handle 3 tcindex classid 1:3

