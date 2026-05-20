#!/bin/sh
# host_wil-1 -> wil-2 eth1 (PDF : interface e1 cote host)

ip addr add 20.1.1.1/24 dev eth1
ip link set eth1 up
