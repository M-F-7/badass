#!/bin/sh
# VTEP : eth2->RR, eth0->host_wil-3

ip addr add 10.1.1.10/30 dev eth2 && ip link set eth2 up
ip addr add 1.1.1.4/32 dev lo     && ip link set lo up

ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.4 nolearning
ip link add br0 type bridge
ip link set vxlan10 mtu 1450 master br0 up
ip link set br0 mtu 1450 up
ip link set eth0 master br0 up


kill -9 $(cat /var/run/frr/*.pid 2>/dev/null) 2>/dev/null
rm -f /var/run/frr/*.pid
sleep 1

cat > /etc/frr/frr.conf <<'EOF'
hostname wil-4
router ospf
 ospf router-id 1.1.1.4
 network 10.1.1.8/30 area 0
 network 1.1.1.4/32 area 0
router bgp 1
 bgp router-id 1.1.1.4
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
