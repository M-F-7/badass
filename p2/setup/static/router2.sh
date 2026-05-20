echo 1 > /proc/sys/net/ipv4/ip_forward
ip addr add 10.0.0.2/24 dev eth0
ip addr add 10.2.0.1/24 dev eth1
ip link set eth0 up
ip link set eth1 up
ip route add 10.1.0.0/24 via 10.0.0.1
