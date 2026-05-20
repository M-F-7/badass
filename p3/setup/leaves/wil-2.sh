#!/bin/sh
# VTEP : eth0->RR, eth1->host_wil-1

ip addr add 10.1.1.2/30 dev eth0 && ip link set eth0 up
ip addr add 1.1.1.2/32 dev lo    && ip link set lo up

ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.2 nolearning
ip link add br0 type bridge
ip link set vxlan10 mtu 1450 master br0 up
ip link set br0 mtu 1450 up
ip link set eth1 master br0 up   # eth1 -> host_wil-1 (eth1 cote host, cf. PDF)


kill -9 $(cat /var/run/frr/*.pid 2>/dev/null) 2>/dev/null
rm -f /var/run/frr/*.pid
sleep 1

cat > /etc/frr/frr.conf <<'EOF'
hostname wil-2
router ospf
 ospf router-id 1.1.1.2
 network 10.1.1.0/30 area 0
 network 1.1.1.2/32 area 0
router bgp 1
 bgp router-id 1.1.1.2
 no bgp default ipv4-unicast
 neighbor 1.1.1.1 remote-as 1
 neighbor 1.1.1.1 update-source lo
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
  advertise-all-vni
 exit-address-family
line vty
EOF

/usr/lib/frr/frrinit.sh restart
