#!/bin/sh
# RR : eth0->wil-2, eth1->wil-3, eth2->wil-4

ip addr add 10.1.1.1/30 dev eth0 && ip link set eth0 up
ip addr add 10.1.1.5/30 dev eth1 && ip link set eth1 up
ip addr add 10.1.1.9/30 dev eth2 && ip link set eth2 up
ip addr add 1.1.1.1/32 dev lo   && ip link set lo up

kill -9 $(cat /var/run/frr/*.pid 2>/dev/null) 2>/dev/null
rm -f /var/run/frr/*.pid
sleep 1

cat > /etc/frr/frr.conf <<'EOF'
hostname wil-1
router ospf
 ospf router-id 1.1.1.1
 network 10.1.1.0/30 area 0
 network 10.1.1.4/30 area 0
 network 10.1.1.8/30 area 0
 network 1.1.1.1/32 area 0
router bgp 1
 bgp router-id 1.1.1.1
 no bgp default ipv4-unicast
 neighbor LEAVES peer-group
 neighbor LEAVES remote-as 1
 neighbor LEAVES update-source lo
 neighbor 1.1.1.2 peer-group LEAVES
 neighbor 1.1.1.3 peer-group LEAVES
 neighbor 1.1.1.4 peer-group LEAVES
 address-family l2vpn evpn
  neighbor LEAVES activate
  neighbor LEAVES route-reflector-client
 exit-address-family
line vty
EOF

/usr/lib/frr/frrinit.sh restart
