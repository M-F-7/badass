#!/bin/sh
# host_wil-2 -> wil-3 eth0

ip addr add 20.1.1.2/24 dev eth0
ip link set eth0 up
