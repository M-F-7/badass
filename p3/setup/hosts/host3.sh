#!/bin/sh
# host_wil-3 -> wil-4 eth0

ip addr add 20.1.1.3/24 dev eth0
ip link set eth0 up
