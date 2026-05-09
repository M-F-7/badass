#!/bin/sh

# Router 1 static VXLAN config.
# Underlay: 10.0.0.1/24 on eth0
# Host-facing: eth1
# Overlay: VNI 10 bridged into br0

ip addr flush dev eth0
ip addr flush dev eth1
ip link set eth0 up
ip link set eth1 up
ip addr add 10.0.0.1/24 dev eth0

ip link add br0 type bridge
ip link set br0 up
ip link set eth1 master br0

ip link add vxlan10 type vxlan id 10 local 10.0.0.1 remote 10.0.0.2 dstport 4789 dev eth0
ip link set vxlan10 up
ip link set vxlan10 master br0
