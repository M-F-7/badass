#!/bin/sh

# Host 1 overlay config.

ip addr flush dev eth0
ip link set eth0 up
ip addr add 30.1.1.1/24 dev eth0
