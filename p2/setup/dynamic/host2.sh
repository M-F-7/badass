ip addr add 10.2.0.2/24 dev eth1
ip link set eth1 up
ip route add default via 10.2.0.1
ip link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth1
ip link add br0 type bridge
ip link set vxlan10 master br0
ip link set vxlan10 mtu 1450
ip link set br0 mtu 1450
ip link set vxlan10 up
ip link set br0 up
ip addr add 30.1.1.2/24 dev br0
bridge fdb append 00:00:00:00:00:00 dev vxlan10 dst 10.1.0.2