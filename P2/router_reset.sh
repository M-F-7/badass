#!/bin/sh

# Reset Part 2 runtime networking on a router.
# Run this before switching between static and multicast VXLAN modes.

ip link set vxlan10 down 2>/dev/null || true
ip link set eth1 nomaster 2>/dev/null || true
ip link set vxlan10 nomaster 2>/dev/null || true
ip link del vxlan10 2>/dev/null || true
ip link set br0 down 2>/dev/null || true
ip link del br0 2>/dev/null || true
ip addr flush dev eth0
ip addr flush dev eth1
ip link set eth0 up
ip link set eth1 up
