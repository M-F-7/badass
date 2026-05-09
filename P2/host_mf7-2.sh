#!/bin/sh

# Host 2 overlay config.

ip addr flush dev eth0
ip link set eth0 up
ip addr add 30.1.1.2/24 dev eth0
